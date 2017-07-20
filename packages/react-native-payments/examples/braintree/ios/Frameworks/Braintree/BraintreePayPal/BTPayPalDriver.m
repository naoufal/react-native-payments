#import "BTPayPalDriver_Internal.h"

#import "PPOTRequest.h"
#import "PPOTCore.h"

#if __has_include("BraintreeCore.h")
#import "BTAPIClient_Internal.h"
#import "BTPayPalAccountNonce_Internal.h"
#import "BTPostalAddress.h"
#import "BTLogger_Internal.h"
#else
#import <BraintreeCore/BTAPIClient_Internal.h>
#import <BraintreeCore/BTPayPalAccountNonce_Internal.h>
#import <BraintreeCore/BTTokenizedPayPalCheckout_Internal.h>
#import <BraintreeCore/BTPostalAddress.h>
#import <BraintreeCore/BTLogger_Internal.h>
#endif
#import <SafariServices/SafariServices.h>
#import "BTConfiguration+PayPal.h"

NSString *const BTPayPalDriverErrorDomain = @"com.braintreepayments.BTPayPalDriverErrorDomain";

static void (^appSwitchReturnBlock)(NSURL *url);

typedef NS_ENUM(NSUInteger, BTPayPalPaymentType) {
    BTPayPalPaymentTypeUnknown = 0,
    BTPayPalPaymentTypeFuturePayments,
    BTPayPalPaymentTypeCheckout,
    BTPayPalPaymentTypeBillingAgreement,
};

@interface BTPayPalDriver () <SFSafariViewControllerDelegate>
@end

@implementation BTPayPalDriver

+ (void)load {
    if (self == [BTPayPalDriver class]) {
        PayPalClass = [PPOTCore class];
        
        [[BTAppSwitch sharedInstance] registerAppSwitchHandler:self];
        
        [[BTTokenizationService sharedService] registerType:@"PayPal" withTokenizationBlock:^(BTAPIClient *apiClient, __unused NSDictionary *options, void (^completionBlock)(BTPaymentMethodNonce *paymentMethodNonce, NSError *error)) {
            BTPayPalDriver *driver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
            driver.viewControllerPresentingDelegate = options[BTTokenizationServiceViewPresentingDelegateOption];
            driver.appSwitchDelegate = options[BTTokenizationServiceAppSwitchDelegateOption];
            [driver authorizeAccountWithAdditionalScopes:options[BTTokenizationServicePayPalScopesOption] completion:completionBlock];
        }];
        
        [[BTPaymentMethodNonceParser sharedParser] registerType:@"PayPalAccount" withParsingBlock:^BTPaymentMethodNonce * _Nullable(BTJSON * _Nonnull payPalAccount) {
            return [self payPalAccountFromJSON:payPalAccount];
        }];
    }
}

- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient {
    if (self = [super init]) {
        BTClientMetadataSourceType source = [self isiOSAppAvailableForAppSwitch] ? BTClientMetadataSourcePayPalApp : BTClientMetadataSourcePayPalBrowser;
        _apiClient = [apiClient copyWithSource:source integration:apiClient.metadata.integration];
    }
    return self;
}

- (instancetype)init {
    return nil;
}

#pragma mark - Authorization (Future Payments)

- (void)authorizeAccountWithCompletion:(void (^)(BTPayPalAccountNonce *paymentMethod, NSError *error))completionBlock {
    [self authorizeAccountWithAdditionalScopes:[NSSet set] completion:completionBlock];
}

- (void)authorizeAccountWithAdditionalScopes:(NSSet<NSString *> *)additionalScopes completion:(void (^)(BTPayPalAccountNonce *, NSError *))completionBlock {
    [self authorizeAccountWithAdditionalScopes:additionalScopes forceFuturePaymentFlow:false completion:completionBlock];
}

- (void)authorizeAccountWithAdditionalScopes:(NSSet<NSString *> *)additionalScopes forceFuturePaymentFlow:(BOOL)forceFuturePaymentFlow completion:(void (^)(BTPayPalAccountNonce *, NSError *))completionBlock {
    if (!self.apiClient) {
        NSError *error = [NSError errorWithDomain:BTPayPalDriverErrorDomain
                                             code:BTPayPalDriverErrorTypeIntegration
                                         userInfo:@{NSLocalizedDescriptionKey: @"BTPayPalDriver failed because BTAPIClient is nil."}];
        completionBlock(nil, error);
        return;
    }
    
    [self setAuthorizationAppSwitchReturnBlock:completionBlock];
    
    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        if (error) {
            if (completionBlock) completionBlock(nil, error);
            return;
        }
        
        if (configuration.isBillingAgreementsEnabled && !forceFuturePaymentFlow) {
            // Switch to Billing Agreements flow
            BTPayPalRequest *payPalRequest = [[BTPayPalRequest alloc] init]; // Drop-in only supports Vault flow, which does not use currency code or amount
            [self requestBillingAgreement:payPalRequest completion:completionBlock];
            return;
        }
        
        if (![self verifyAppSwitchWithRemoteConfiguration:configuration.json error:&error]) {
            if (completionBlock) completionBlock(nil, error);
            return;
        }
        
        PPOTAuthorizationRequest *request =
        [self.requestFactory requestWithScopeValues:[self.defaultOAuth2Scopes setByAddingObjectsFromSet:(additionalScopes ? additionalScopes : [NSSet set])]
                                         privacyURL:[configuration.json[@"paypal"][@"privacyUrl"] asURL]
                                       agreementURL:[configuration.json[@"paypal"][@"userAgreementUrl"] asURL]
                                           clientID:[self paypalClientIdWithRemoteConfiguration:configuration.json]
                                        environment:[self payPalEnvironmentForRemoteConfiguration:configuration.json]
                                  callbackURLScheme:self.returnURLScheme];
        
        if (self.apiClient.clientToken) {
            request.additionalPayloadAttributes = @{ @"client_token": self.apiClient.clientToken.originalValue };
        } else if (self.apiClient.tokenizationKey) {
            request.additionalPayloadAttributes = @{ @"client_key": self.apiClient.tokenizationKey };
        }

        if (![SFSafariViewController class]) {
            [self informDelegateWillPerformAppSwitch];
        }
        [request performWithAdapterBlock:^(BOOL success, NSURL *url, PPOTRequestTarget target, NSString *clientMetadataId, NSError *error) {
            self.clientMetadataId = clientMetadataId;
            
            [self sendAnalyticsEventForInitiatingOneTouchForPaymentType:BTPayPalPaymentTypeFuturePayments withSuccess:success target:target];

            [self handlePayPalRequestWithSuccess:success error:error requestURL:url target:target paymentType:BTPayPalPaymentTypeFuturePayments completion:completionBlock];
        }];
    }];
}

- (void)setAuthorizationAppSwitchReturnBlock:(void (^)(BTPayPalAccountNonce *account, NSError *error))completionBlock {
    [self setAppSwitchReturnBlock:completionBlock forPaymentType:BTPayPalPaymentTypeFuturePayments];
}

#pragma mark - Billing Agreement

- (void)requestBillingAgreement:(BTPayPalRequest *)request completion:(void (^)(BTPayPalAccountNonce *tokenizedCheckout, NSError *error))completionBlock {
    [self requestExpressCheckout:request isBillingAgreement:YES handler:nil completion:completionBlock];
}

- (void)requestBillingAgreement:(BTPayPalRequest *)request handler:(id<BTPayPalApprovalHandler>)handler completion:(void (^)(BTPayPalAccountNonce * _Nullable, NSError * _Nullable))completionBlock {
    [self requestExpressCheckout:request isBillingAgreement:YES handler:handler completion:completionBlock];
}

- (void)setBillingAgreementAppSwitchReturnBlock:(void (^)(BTPayPalAccountNonce *tokenizedAccount, NSError *error))completionBlock {
    [self setAppSwitchReturnBlock:completionBlock forPaymentType:BTPayPalPaymentTypeBillingAgreement];
}

#pragma mark - Express Checkout (One-Time Payments)

- (void)requestOneTimePayment:(BTPayPalRequest *)request completion:(void (^)(BTPayPalAccountNonce *tokenizedCheckout, NSError *error))completionBlock {
    [self requestExpressCheckout:request isBillingAgreement:NO handler:nil completion:completionBlock];
}

- (void)requestOneTimePayment:(BTPayPalRequest *)request handler:(id<BTPayPalApprovalHandler>)handler completion:(void (^)(BTPayPalAccountNonce *tokenizedCheckout, NSError *error))completionBlock {
    [self requestExpressCheckout:request isBillingAgreement:NO handler:handler completion:completionBlock];
}

- (void)setOneTimePaymentAppSwitchReturnBlock:(void (^)(BTPayPalAccountNonce *tokenizedAccount, NSError *error))completionBlock {
    [self setAppSwitchReturnBlock:completionBlock forPaymentType:BTPayPalPaymentTypeCheckout];
}

#pragma mark - Helpers

/// A "Hermes checkout" is used by both Billing Agreements and Express Checkout
- (void)requestExpressCheckout:(BTPayPalRequest *)request
           isBillingAgreement:(BOOL)isBillingAgreement
                       handler:(id<BTPayPalApprovalHandler>)handler
                   completion:(void (^)(BTPayPalAccountNonce *tokenizedCheckout, NSError *error))completionBlock {
    if (!self.apiClient) {
        NSError *error = [NSError errorWithDomain:BTPayPalDriverErrorDomain
                                             code:BTPayPalDriverErrorTypeIntegration
                                         userInfo:@{NSLocalizedDescriptionKey: @"BTPayPalDriver failed because BTAPIClient is nil."}];
        completionBlock(nil, error);
        return;
    }
    
    if (!request || (!isBillingAgreement && !request.amount)) {
        completionBlock(nil, [NSError errorWithDomain:BTPayPalDriverErrorDomain code:BTPayPalDriverErrorTypeInvalidRequest userInfo:nil]);
        return;
    }
    
    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        if (error) {
            if (completionBlock) completionBlock(nil, error);
            return;
        }
        
        if (![self verifyAppSwitchWithRemoteConfiguration:configuration.json error:&error]) {
            if (completionBlock) completionBlock(nil, error);
            return;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *experienceProfile = [NSMutableDictionary dictionary];
        
        if (!isBillingAgreement) {
            parameters[@"intent"] = [self.class intentTypeToString:request.intent];
            if (request.amount != nil) {
                parameters[@"amount"] = request.amount;
            }
        } else {
            if (request.billingAgreementDescription.length > 0) {
                parameters[@"description"] = request.billingAgreementDescription;
            }
        }
        
        parameters[@"offer_paypal_credit"] = @(request.offerCredit);
        
        experienceProfile[@"no_shipping"] = @(!request.isShippingAddressRequired);

        experienceProfile[@"brand_name"] = request.displayName ?: [configuration.json[@"paypal"][@"displayName"] asString];

        NSString *landingPageTypeValue = [self.class landingPageTypeToString:request.landingPageType];
        if (landingPageTypeValue != nil) {
            experienceProfile[@"landing_page_type"] = landingPageTypeValue;
        }

        if (request.localeCode != nil) {
            experienceProfile[@"locale_code"] = request.localeCode;
        }
        
        // Currency code should only be used for Hermes Checkout (one-time payment).
        // For BA, currency should not be used.
        NSString *currencyCode = request.currencyCode ?: [configuration.json[@"paypal"][@"currencyIsoCode"] asString];
        if (!isBillingAgreement && currencyCode) {
            parameters[@"currency_iso_code"] = currencyCode;
        }
        
        if (request.shippingAddressOverride != nil) {
            experienceProfile[@"address_override"] = @YES;
            BTPostalAddress *shippingAddress = request.shippingAddressOverride;
            parameters[@"line1"] = shippingAddress.streetAddress;
            parameters[@"line2"] = shippingAddress.extendedAddress;
            parameters[@"city"] = shippingAddress.locality;
            parameters[@"state"] = shippingAddress.region;
            parameters[@"postal_code"] = shippingAddress.postalCode;
            parameters[@"country_code"] = shippingAddress.countryCodeAlpha2;
            parameters[@"recipient_name"] = shippingAddress.recipientName;
        } else {
            experienceProfile[@"address_override"] = @NO;
        }
        
        NSString *returnURI;
        NSString *cancelURI;
        
        [[self.class payPalClass] redirectURLsForCallbackURLScheme:self.returnURLScheme
                                                     withReturnURL:&returnURI
                                                     withCancelURL:&cancelURI];
        if (!returnURI || !cancelURI) {
            completionBlock(nil, [NSError errorWithDomain:BTPayPalDriverErrorDomain
                                                     code:BTPayPalDriverErrorTypeIntegrationReturnURLScheme
                                                 userInfo:@{NSLocalizedFailureReasonErrorKey: @"Application may not support One Touch callback URL scheme.",
                                                            NSLocalizedRecoverySuggestionErrorKey: @"Check the return URL scheme" }]);
            return;
        }
        
        if (returnURI) {
            parameters[@"return_url"] = returnURI;
        }
        if (cancelURI) {
            parameters[@"cancel_url"] = cancelURI;
        }
        
        parameters[@"experience_profile"] = experienceProfile;
        
        self.payPalRequest = request;
        
        NSString *url = isBillingAgreement ? @"setup_billing_agreement" : @"create_payment_resource";
        
        [self.apiClient POST:[NSString stringWithFormat:@"v1/paypal_hermes/%@",url]
                  parameters:parameters
                  completion:^(BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error) {
                      
                      if (error) {
                          NSString *errorDetailsIssue = ((BTJSON *)error.userInfo[BTHTTPJSONResponseBodyKey][@"paymentResource"][@"errorDetails"][0][@"issue"]).asString;
                          if (error.userInfo[NSLocalizedDescriptionKey] == nil && errorDetailsIssue != nil) {
                              NSMutableDictionary *dictionary = [error.userInfo mutableCopy];
                              dictionary[NSLocalizedDescriptionKey] = errorDetailsIssue;
                              error = [NSError errorWithDomain:error.domain code:error.code userInfo:dictionary];
                          }
                          
                          if (completionBlock) completionBlock(nil, error);
                          return;
                      }
                      
                      if (isBillingAgreement) {
                          [self setBillingAgreementAppSwitchReturnBlock:completionBlock];
                      } else {
                          [self setOneTimePaymentAppSwitchReturnBlock:completionBlock];
                      }
                      
                      NSString *payPalClientID = [configuration.json[@"paypal"][@"clientId"] asString];
                      
                      if (!payPalClientID && [self payPalEnvironmentForRemoteConfiguration:configuration.json] == PayPalEnvironmentMock) {
                          payPalClientID = @"FAKE-PAYPAL-CLIENT-ID";
                      }
                      
                      NSURL *approvalUrl = [body[@"paymentResource"][@"redirectUrl"] asURL];
                      if (approvalUrl == nil) {
                          approvalUrl = [body[@"agreementSetup"][@"approvalUrl"] asURL];
                      }

                      approvalUrl = [self decorateApprovalURL:approvalUrl forRequest:request];

                      PPOTCheckoutRequest *request = nil;
                      if (isBillingAgreement) {
                          request = [self.requestFactory billingAgreementRequestWithApprovalURL:approvalUrl
                                                                                       clientID:payPalClientID
                                                                                    environment:[self payPalEnvironmentForRemoteConfiguration:configuration.json]
                                                                              callbackURLScheme:self.returnURLScheme];
                      } else {
                          request = [self.requestFactory checkoutRequestWithApprovalURL:approvalUrl
                                                                               clientID:payPalClientID
                                                                            environment:[self payPalEnvironmentForRemoteConfiguration:configuration.json]
                                                                      callbackURLScheme:self.returnURLScheme];
                      }

                      // Call custom handler and return before beginning the default approval process
                      if (handler != nil) {
                          [handler handleApproval:request paypalApprovalDelegate:self];
                          return;
                      }

                      if (![SFSafariViewController class]) {
                          [self informDelegateWillPerformAppSwitch];
                      }

                      [request performWithAdapterBlock:^(BOOL success, NSURL *url, PPOTRequestTarget target, NSString *clientMetadataId, NSError *error) {
                          self.clientMetadataId = clientMetadataId;
                          
                          if (isBillingAgreement) {
                              [self sendAnalyticsEventForInitiatingOneTouchForPaymentType:BTPayPalPaymentTypeBillingAgreement withSuccess:success target:target];
                          } else {
                              [self sendAnalyticsEventForInitiatingOneTouchForPaymentType:BTPayPalPaymentTypeCheckout withSuccess:success target:target];
                          }

                          [self handlePayPalRequestWithSuccess:success
                                                         error:error
                                                    requestURL:url
                                                        target:target
                                                   paymentType:isBillingAgreement ? BTPayPalPaymentTypeBillingAgreement : BTPayPalPaymentTypeCheckout
                                                    completion:completionBlock];
                      }];
                  }];
    }];
}

- (void)setAppSwitchReturnBlock:(void (^)(BTPayPalAccountNonce *tokenizedAccount, NSError *error))completionBlock
                 forPaymentType:(BTPayPalPaymentType)paymentType {
    appSwitchReturnBlock = ^(NSURL *url) {
        if (self.safariViewController) {
            [self informDelegatePresentingViewControllerNeedsDismissal];
        } else {
            [self informDelegateWillProcessAppSwitchReturn];
        }
        
        // Before parsing the return URL, check whether the user cancelled by breaking
        // out of the PayPal app switch flow (e.g. "Done" button in SFSafariViewController)
        if ([url.absoluteString isEqualToString:SFSafariViewControllerFinishedURL]) {
            if (completionBlock) completionBlock(nil, nil);
            return;
        }
        
        [[self.class payPalClass] parseResponseURL:url completionBlock:^(PPOTResult *result) {
            
            [self sendAnalyticsEventForHandlingOneTouchResult:result forPaymentType:paymentType];
            
            switch (result.type) {
                case PPOTResultTypeError:
                    if (completionBlock) completionBlock(nil, result.error);
                    break;
                case PPOTResultTypeCancel:
                    if (result.error) {
                        [[BTLogger sharedLogger] error:@"PayPal error: %@", result.error];
                    }
                    if (completionBlock) completionBlock(nil, nil);
                    break;
                case PPOTResultTypeSuccess: {
                    
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    parameters[@"paypal_account"] = [result.response mutableCopy];
                    
                    if (paymentType == BTPayPalPaymentTypeCheckout) {
                        parameters[@"paypal_account"][@"options"] = @{ @"validate": @NO };
                        if (self.payPalRequest) {
                            parameters[@"paypal_account"][@"intent"] = [self.class intentTypeToString:self.payPalRequest.intent];
                        }
                    }
                    if (self.clientMetadataId) {
                        parameters[@"paypal_account"][@"correlation_id"] = self.clientMetadataId;
                    }
                    
                    BTClientMetadata *metadata = [self clientMetadata];
                    parameters[@"_meta"] = @{
                                             @"source" : metadata.sourceString,
                                             @"integration" : metadata.integrationString,
                                             @"sessionId" : metadata.sessionId,
                                             };
                    
                    [self.apiClient POST:@"/v1/payment_methods/paypal_accounts"
                              parameters:parameters
                              completion:^(BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error)
                     {
                         if (error) {
                             [self sendAnalyticsEventForTokenizationFailureForPaymentType:paymentType];
                             if (completionBlock) completionBlock(nil, error);
                             return;
                         }
                         
                         [self sendAnalyticsEventForTokenizationSuccessForPaymentType:paymentType];
                         
                         BTJSON *payPalAccount = body[@"paypalAccounts"][0];
                         BTPayPalAccountNonce *tokenizedAccount = [self.class payPalAccountFromJSON:payPalAccount];

                         [self sendAnalyticsEventIfCreditFinancingInNonce:tokenizedAccount forPaymentType:paymentType];

                         if (completionBlock) completionBlock(tokenizedAccount, nil);
                     }];
                    
                    break;
                }
            }
            appSwitchReturnBlock = nil;
        }];
    };
}

- (void)handlePayPalRequestWithSuccess:(BOOL)success
                                 error:(NSError *)error
                            requestURL:(NSURL *)url
                                target:(PPOTRequestTarget)target
                           paymentType:(BTPayPalPaymentType)paymentType
                            completion:(void (^)(BTPayPalAccountNonce *, NSError *))completionBlock
{
    if (success) {
        // Defensive programming in case PayPal One Touch returns a non-HTTP URL so that SFSafariViewController doesn't crash
        if ([SFSafariViewController class] && ![url.scheme.lowercaseString hasPrefix:@"http"]) {
            NSError *urlError = [NSError errorWithDomain:BTPayPalDriverErrorDomain
                                                    code:BTPayPalDriverErrorTypeUnknown
                                                userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Attempted to open an invalid URL in SFSafariViewController: %@://", url.scheme],
                                                            NSLocalizedRecoverySuggestionErrorKey: @"Try again or contact Braintree Support." }];
            if (completionBlock) completionBlock(nil, urlError);

            NSString *eventName = [NSString stringWithFormat:@"ios.%@.%@.error.safariviewcontrollerbadscheme.%@", [self.class eventStringForPaymentType:paymentType], [self.class eventStringForRequestTarget:target], url.scheme];
            [self.apiClient sendAnalyticsEvent:eventName];

            return;
        }
        [self performSwitchRequest:url];
        if (![SFSafariViewController class]) {
            [self informDelegateDidPerformAppSwitchToTarget:target];
        }
    } else {
        if (completionBlock) completionBlock(nil, error);
    }
}

- (void)performSwitchRequest:(NSURL *)appSwitchURL {
    if ([SFSafariViewController class]) {
        [self informDelegatePresentingViewControllerRequestPresent:appSwitchURL];
    } else {
        UIApplication *application = [UIApplication sharedApplication];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:appSwitchURL options:[NSDictionary dictionary] completionHandler:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [application openURL:appSwitchURL];
#pragma clang diagnostic pop
        }
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [application openURL:appSwitchURL];
#pragma clang diagnostic pop
#endif
    }
}

- (NSString *)payPalEnvironmentForRemoteConfiguration:(BTJSON *)configuration {
    NSString *btPayPalEnvironmentName = [configuration[@"paypal"][@"environment"] asString];
    if ([btPayPalEnvironmentName isEqualToString:@"offline"]) {
        return PayPalEnvironmentMock;
    } else if ([btPayPalEnvironmentName isEqualToString:@"live"]) {
        return PayPalEnvironmentProduction;
    } else {
        // Fall back to mock when configuration has an unsupported value for environment, e.g. "custom"
        // Instead of returning btPayPalEnvironmentName
        return PayPalEnvironmentMock;
    }
}

- (NSString *)paypalClientIdWithRemoteConfiguration:(BTJSON *)configuration {
    if ([[configuration[@"paypal"][@"environment"] asString] isEqualToString:@"offline"] && ![configuration[@"paypal"][@"clientId"] isString]) {
        return @"mock-paypal-client-id";
    } else {
        return [configuration[@"paypal"][@"clientId"] asString];
    }
}

- (BTClientMetadata *)clientMetadata {
    BTMutableClientMetadata *metadata = [self.apiClient.metadata mutableCopy];
    
    if ([self isiOSAppAvailableForAppSwitch]) {
        metadata.source = BTClientMetadataSourcePayPalApp;
    } else {
        metadata.source = BTClientMetadataSourcePayPalBrowser;
    }
    
    return [metadata copy];
}

- (NSSet *)defaultOAuth2Scopes {
    return [NSSet setWithObjects:@"https://uri.paypal.com/services/payments/futurepayments", @"email", nil];
}

+ (BTPostalAddress *)accountAddressFromJSON:(BTJSON *)addressJSON {
    if (!addressJSON.isObject) {
        return nil;
    }
    
    BTPostalAddress *address = [[BTPostalAddress alloc] init];
    address.recipientName = [addressJSON[@"recipientName"] asString]; // Likely to be nil
    address.streetAddress = [addressJSON[@"street1"] asString];
    address.extendedAddress = [addressJSON[@"street2"] asString];
    address.locality = [addressJSON[@"city"] asString];
    address.region = [addressJSON[@"state"] asString];
    address.postalCode = [addressJSON[@"postalCode"] asString];
    address.countryCodeAlpha2 = [addressJSON[@"country"] asString];
    
    return address;
}

+ (BTPostalAddress *)shippingOrBillingAddressFromJSON:(BTJSON *)addressJSON {
    if (!addressJSON.isObject) {
        return nil;
    }
    
    BTPostalAddress *address = [[BTPostalAddress alloc] init];
    address.recipientName = [addressJSON[@"recipientName"] asString]; // Likely to be nil
    address.streetAddress = [addressJSON[@"line1"] asString];
    address.extendedAddress = [addressJSON[@"line2"] asString];
    address.locality = [addressJSON[@"city"] asString];
    address.region = [addressJSON[@"state"] asString];
    address.postalCode = [addressJSON[@"postalCode"] asString];
    address.countryCodeAlpha2 = [addressJSON[@"countryCode"] asString];
    
    return address;
}

+ (BTPayPalCreditFinancingAmount *)creditFinancingAmountFromJSON:(BTJSON *)amountJSON {
    if (!amountJSON.isObject) {
        return nil;
    }

    NSString *currency = [amountJSON[@"currency"] asString];
    NSString *value = [amountJSON[@"value"] asString];

    return [[BTPayPalCreditFinancingAmount alloc] initWithCurrency:currency value:value];
}

+ (BTPayPalCreditFinancing *)creditFinancingFromJSON:(BTJSON *)creditFinancingOfferedJSON {
    if (!creditFinancingOfferedJSON.isObject) {
        return nil;
    }

    BOOL isCardAmountImmutable = [creditFinancingOfferedJSON[@"cardAmountImmutable"] isTrue];

    BTPayPalCreditFinancingAmount *monthlyPayment = [self.class creditFinancingAmountFromJSON:creditFinancingOfferedJSON[@"monthlyPayment"]];

    BOOL payerAcceptance = [creditFinancingOfferedJSON[@"payerAcceptance"] isTrue];
    NSInteger term = [creditFinancingOfferedJSON[@"term"] asIntegerOrZero];
    BTPayPalCreditFinancingAmount *totalCost = [self.class creditFinancingAmountFromJSON:creditFinancingOfferedJSON[@"totalCost"]];
    BTPayPalCreditFinancingAmount *totalInterest = [self.class creditFinancingAmountFromJSON:creditFinancingOfferedJSON[@"totalInterest"]];

    return [[BTPayPalCreditFinancing alloc] initWithCardAmountImmutable:isCardAmountImmutable
                                                         monthlyPayment:monthlyPayment
                                                        payerAcceptance:payerAcceptance
                                                                   term:term
                                                              totalCost:totalCost
                                                          totalInterest:totalInterest];
}

+ (BTPayPalAccountNonce *)payPalAccountFromJSON:(BTJSON *)payPalAccount {
    NSString *nonce = [payPalAccount[@"nonce"] asString];
    NSString *description = [payPalAccount[@"description"] asString];
    
    BTJSON *details = payPalAccount[@"details"];
    
    NSString *email = [details[@"email"] asString];
    NSString *clientMetadataId = [details[@"correlationId"] asString];
    // Allow email to be under payerInfo
    if ([details[@"payerInfo"][@"email"] isString]) {
        email = [details[@"payerInfo"][@"email"] asString];
    }
    
    NSString *firstName = [details[@"payerInfo"][@"firstName"] asString];
    NSString *lastName = [details[@"payerInfo"][@"lastName"] asString];
    NSString *phone = [details[@"payerInfo"][@"phone"] asString];
    NSString *payerId = [details[@"payerInfo"][@"payerId"] asString];
    BOOL isDefault = [payPalAccount[@"default"] isTrue];
    
    BTPostalAddress *shippingAddress = [self.class shippingOrBillingAddressFromJSON:details[@"payerInfo"][@"shippingAddress"]];
    BTPostalAddress *billingAddress = [self.class shippingOrBillingAddressFromJSON:details[@"payerInfo"][@"billingAddress"]];
    if (!shippingAddress) {
        shippingAddress = [self.class accountAddressFromJSON:details[@"payerInfo"][@"accountAddress"]];
    }
    
    // Braintree gateway has some inconsistent behavior depending on
    // the type of nonce, and sometimes returns "PayPal" for description,
    // and sometimes returns a real identifying string. The former is not
    // desirable for display. The latter is.
    // As a workaround, we ignore descriptions that look like "PayPal".
    if ([description caseInsensitiveCompare:@"PayPal"] == NSOrderedSame) {
        description = email;
    }

    BTPayPalCreditFinancing *creditFinancing =  [self.class creditFinancingFromJSON:details[@"creditFinancingOffered"]];

    BTPayPalAccountNonce *tokenizedPayPalAccount = [[BTPayPalAccountNonce alloc] initWithNonce:nonce
                                                                                   description:description
                                                                                         email:email
                                                                                     firstName:firstName
                                                                                      lastName:lastName
                                                                                         phone:phone
                                                                                billingAddress:billingAddress
                                                                               shippingAddress:shippingAddress
                                                                              clientMetadataId:clientMetadataId
                                                                                       payerId:payerId
                                                                                     isDefault:isDefault
                                                                               creditFinancing:creditFinancing];
    
    return tokenizedPayPalAccount;
}

+ (NSString *)intentTypeToString:(BTPayPalRequestIntent)intentType {
    NSString *result = nil;

    switch(intentType) {
        case BTPayPalRequestIntentAuthorize:
            result = @"authorize";
            break;
        case BTPayPalRequestIntentSale:
            result = @"sale";
            break;
        case BTPayPalRequestIntentOrder:
            result = @"order";
            break;
        default:
            result = @"authorize";
            break;
    }

    return result;
}

+ (NSString *)landingPageTypeToString:(BTPayPalRequestLandingPageType)landingPageType {
    switch(landingPageType) {
        case BTPayPalRequestLandingPageTypeLogin:
            return @"login";
        case BTPayPalRequestLandingPageTypeBilling:
            return @"billing";
        default:
            return nil;
    }
}

#pragma mark - Delegate Informers

- (void)informDelegateWillPerformAppSwitch {
    NSNotification *notification = [[NSNotification alloc] initWithName:BTAppSwitchWillSwitchNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    if ([self.appSwitchDelegate respondsToSelector:@selector(appSwitcherWillPerformAppSwitch:)]) {
        [self.appSwitchDelegate appSwitcherWillPerformAppSwitch:self];
    }
}

- (void)informDelegateDidPerformAppSwitchToTarget:(PPOTRequestTarget)target {
    BTAppSwitchTarget appSwitchTarget;
    switch (target) {
        case PPOTRequestTargetBrowser:
            appSwitchTarget = BTAppSwitchTargetWebBrowser;
            break;
        case PPOTRequestTargetOnDeviceApplication:
            appSwitchTarget = BTAppSwitchTargetNativeApp;
            break;
        case PPOTRequestTargetNone:
        case PPOTRequestTargetUnknown:
            appSwitchTarget = BTAppSwitchTargetUnknown;
            // Should never happen
            break;
    }
    
    NSNotification *notification = [[NSNotification alloc] initWithName:BTAppSwitchDidSwitchNotification object:self userInfo:@{ BTAppSwitchNotificationTargetKey : @(appSwitchTarget) } ];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    if ([self.appSwitchDelegate respondsToSelector:@selector(appSwitcher:didPerformSwitchToTarget:)]) {
        [self.appSwitchDelegate appSwitcher:self didPerformSwitchToTarget:appSwitchTarget];
    }
}

- (void)informDelegateWillProcessAppSwitchReturn {
    NSNotification *notification = [[NSNotification alloc] initWithName:BTAppSwitchWillProcessPaymentInfoNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    if ([self.appSwitchDelegate respondsToSelector:@selector(appSwitcherWillProcessPaymentInfo:)]) {
        [self.appSwitchDelegate appSwitcherWillProcessPaymentInfo:self];
    }
}

- (void)informDelegatePresentingViewControllerRequestPresent:(NSURL*) appSwitchURL {
    if (self.viewControllerPresentingDelegate != nil && [self.viewControllerPresentingDelegate respondsToSelector:@selector(paymentDriver:requestsPresentationOfViewController:)]) {
        self.safariViewController = [[SFSafariViewController alloc] initWithURL:appSwitchURL];
        self.safariViewController.delegate = self;
        [self.viewControllerPresentingDelegate paymentDriver:self requestsPresentationOfViewController:self.safariViewController];
    } else {
        [[BTLogger sharedLogger] critical:@"Unable to display View Controller to continue PayPal flow. BTPayPalDriver needs a viewControllerPresentingDelegate<BTViewControllerPresentingDelegate> to be set."];
    }
}

- (void)informDelegatePresentingViewControllerNeedsDismissal {
    if (self.viewControllerPresentingDelegate != nil && [self.viewControllerPresentingDelegate respondsToSelector:@selector(paymentDriver:requestsDismissalOfViewController:)]) {
        [self.viewControllerPresentingDelegate paymentDriver:self requestsDismissalOfViewController:self.safariViewController];
        self.safariViewController = nil;
    } else {
        [[BTLogger sharedLogger] critical:@"Unable to dismiss View Controller to end PayPal flow. BTPayPalDriver needs a viewControllerPresentingDelegate<BTViewControllerPresentingDelegate> to be set."];
    }
}

#pragma mark - SFSafariViewControllerDelegate

static NSString * const SFSafariViewControllerFinishedURL = @"sfsafariviewcontroller://finished";

- (void)safariViewControllerDidFinish:(__unused SFSafariViewController *)controller {
    [self.class handleAppSwitchReturnURL:[NSURL URLWithString:SFSafariViewControllerFinishedURL]];
}

#pragma mark - Preflight check

- (BOOL)verifyAppSwitchWithRemoteConfiguration:(BTJSON *)configuration error:(NSError * __autoreleasing *)error {
    if (![configuration[@"paypalEnabled"] isTrue]) {
        [self.apiClient sendAnalyticsEvent:@"ios.paypal-otc.preflight.disabled"];
        if (error != NULL) {
            *error = [NSError errorWithDomain:BTPayPalDriverErrorDomain
                                         code:BTPayPalDriverErrorTypeDisabled
                                     userInfo:@{ NSLocalizedDescriptionKey: @"PayPal is not enabled for this merchant",
                                                 NSLocalizedRecoverySuggestionErrorKey: @"Enable PayPal for this merchant in the Braintree Control Panel" }];
        }
        return NO;
    }
    
    if (self.returnURLScheme == nil || [self.returnURLScheme isEqualToString:@""]) {
        NSString *recoverySuggestion = @"PayPal requires a return URL scheme to be configured via [BTAppSwitch setReturnURLScheme:]. This custom URL scheme must also be registered with your app.";
        [[BTLogger sharedLogger] critical:recoverySuggestion];

        [self.apiClient sendAnalyticsEvent:@"ios.paypal-otc.preflight.nil-return-url-scheme"];
        if (error != NULL) {
            *error = [NSError errorWithDomain:BTPayPalDriverErrorDomain
                                         code:BTPayPalDriverErrorTypeIntegrationReturnURLScheme
                                     userInfo:@{ NSLocalizedDescriptionKey: @"PayPal app switch is missing a returnURLScheme",
                                                 NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion }];
        }
        return NO;
    }
    
    if (![[self.class payPalClass] doesApplicationSupportOneTouchCallbackURLScheme:self.returnURLScheme]) {
        NSString *recoverySuggestion = [NSString stringWithFormat:@"PayPal requires [BTAppSwitch setReturnURLScheme:] to be configured to begin with your app's bundle ID (%@). Currently, it is set to (%@).", [NSBundle mainBundle].bundleIdentifier, self.returnURLScheme];
        [[BTLogger sharedLogger] critical:recoverySuggestion];
        
        [self.apiClient sendAnalyticsEvent:@"ios.paypal-otc.preflight.invalid-return-url-scheme"];
        if (error != NULL) {
            *error = [NSError errorWithDomain:BTPayPalDriverErrorDomain
                                         code:BTPayPalDriverErrorTypeIntegrationReturnURLScheme
                                     userInfo:@{NSLocalizedFailureReasonErrorKey: @"Application does not support One Touch callback URL scheme",
                                                NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion }];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - Analytics Helpers

+ (NSString *)eventStringForPaymentType:(BTPayPalPaymentType)paymentType {
    switch (paymentType) {
        case BTPayPalPaymentTypeBillingAgreement:
            return @"paypal-ba";
        case BTPayPalPaymentTypeFuturePayments:
            return @"paypal-future-payments";
        case BTPayPalPaymentTypeCheckout:
            return @"paypal-single-payment";
        case BTPayPalPaymentTypeUnknown:
            return nil;
    }
}

+ (NSString *)eventStringForRequestTarget:(PPOTRequestTarget)requestTarget {
    switch (requestTarget) {
        case PPOTRequestTargetNone:
            return @"none";
        case PPOTRequestTargetUnknown:
            return @"unknown";
        case PPOTRequestTargetOnDeviceApplication:
            return @"appswitch";
        case PPOTRequestTargetBrowser:
            return @"webswitch";
    }
}

- (void)sendAnalyticsEventForInitiatingOneTouchForPaymentType:(BTPayPalPaymentType)paymentType
                                                  withSuccess:(BOOL)success
                                                       target:(PPOTRequestTarget)target
{
    if (paymentType == BTPayPalPaymentTypeUnknown) return;
    
    NSString *eventName = [NSString stringWithFormat:@"ios.%@.%@.initiate.%@", [self.class eventStringForPaymentType:paymentType], [self.class eventStringForRequestTarget:target], success ? @"started" : @"failed"];
    [self.apiClient sendAnalyticsEvent:eventName];

    if ((paymentType == BTPayPalPaymentTypeCheckout || paymentType == BTPayPalPaymentTypeBillingAgreement) && self.payPalRequest.offerCredit) {
        NSString *eventName = [NSString stringWithFormat:@"ios.%@.%@.credit.offered.%@", [self.class eventStringForPaymentType:paymentType], [self.class eventStringForRequestTarget:target], success ? @"started" : @"failed"];

        [self.apiClient sendAnalyticsEvent:eventName];
    }
}

- (void)sendAnalyticsEventForHandlingOneTouchResult:(PPOTResult *)result forPaymentType:(BTPayPalPaymentType)paymentType {
    if (paymentType == BTPayPalPaymentTypeUnknown) return;
    
    NSString *eventName = [NSString stringWithFormat:@"ios.%@.%@", [self.class eventStringForPaymentType:paymentType], [self.class eventStringForRequestTarget:result.target]];
    
    switch (result.type) {
        case PPOTResultTypeError:
            if (result.error.code == PPOTErrorCodePersistedDataFetchFailed) {
                return [self.apiClient sendAnalyticsEvent:[NSString stringWithFormat:@"%@.failed-keychain", eventName]];
            }
            return [self.apiClient sendAnalyticsEvent:[NSString stringWithFormat:@"%@.failed", eventName]];
        case PPOTResultTypeCancel:
            if (result.error) {
                return [self.apiClient sendAnalyticsEvent:[NSString stringWithFormat:@"%@.canceled-with-error", eventName]];
            } else {
                return [self.apiClient sendAnalyticsEvent:[NSString stringWithFormat:@"%@.canceled", eventName]];
            }
        case PPOTResultTypeSuccess:
            return [self.apiClient sendAnalyticsEvent:[NSString stringWithFormat:@"%@.succeeded", eventName]];
    }
}

- (void)sendAnalyticsEventIfCreditFinancingInNonce:(BTPayPalAccountNonce *)payPalAccountNonce forPaymentType:(BTPayPalPaymentType)paymentType {
    if ([payPalAccountNonce creditFinancing]) {
        NSString *eventName = [NSString stringWithFormat:@"ios.%@.credit.accepted", [self.class eventStringForPaymentType:paymentType]];

        [self.apiClient sendAnalyticsEvent:eventName];
    }
}

- (void)sendAnalyticsEventForTokenizationSuccessForPaymentType:(BTPayPalPaymentType)paymentType {
    if (paymentType == BTPayPalPaymentTypeUnknown) return;
    
    NSString *eventName = [NSString stringWithFormat:@"ios.%@.tokenize.succeeded", [self.class eventStringForPaymentType:paymentType]];
    [self.apiClient sendAnalyticsEvent:eventName];
}

- (void)sendAnalyticsEventForTokenizationFailureForPaymentType:(BTPayPalPaymentType)paymentType {
    if (paymentType == BTPayPalPaymentTypeUnknown) return;
    
    NSString *eventName = [NSString stringWithFormat:@"ios.%@.tokenize.failed", [self.class eventStringForPaymentType:paymentType]];
    [self.apiClient sendAnalyticsEvent:eventName];
}

#pragma mark - App Switch handling

- (BOOL)isiOSAppAvailableForAppSwitch {
    return [[self.class payPalClass] isWalletAppInstalled];
}

+ (BOOL)canHandleAppSwitchReturnURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    return appSwitchReturnBlock != nil && [PPOTCore canParseURL:url sourceApplication:sourceApplication];
}

+ (void)handleAppSwitchReturnURL:(NSURL *)url {
    if (appSwitchReturnBlock) {
        appSwitchReturnBlock(url);
    }
}

- (NSString *)returnURLScheme {
    if (!_returnURLScheme) {
        _returnURLScheme = [[BTAppSwitch sharedInstance] returnURLScheme];
    }
    return _returnURLScheme;
}

#pragma mark - BTPayPalApprovalHandler delegate methods

- (void)onApprovalComplete:(NSURL *)url {
    [self.class handleAppSwitchReturnURL:url];
}

- (void)onApprovalCancel {
    [self.class handleAppSwitchReturnURL:[NSURL URLWithString:SFSafariViewControllerFinishedURL]];
}

#pragma mark - Internal

- (NSURL *)decorateApprovalURL:(NSURL*)approvalURL forRequest:(BTPayPalRequest *)paypalRequest {
    if (approvalURL != nil && paypalRequest.userAction != BTPayPalRequestUserActionDefault) {
        NSURLComponents* approvalURLComponents = [[NSURLComponents alloc] initWithURL:approvalURL resolvingAgainstBaseURL:NO];
        if (approvalURLComponents != nil) {
            NSString *userActionValue = [BTPayPalDriver userActionTypeToString:paypalRequest.userAction];
            if ([userActionValue length] > 0) {
                NSString *query = [approvalURLComponents query];
                NSString *delimiter = [query length] == 0 ? @"" : @"&";
                query = [NSString stringWithFormat:@"%@%@useraction=%@", query, delimiter, userActionValue];
                approvalURLComponents.query = query;
            }
            return [approvalURLComponents URL];
        }
    }
    return approvalURL;
}

+ (NSString *)userActionTypeToString:(BTPayPalRequestUserAction)userActionType {
    NSString *result = nil;

    switch(userActionType) {
        case BTPayPalRequestUserActionCommit:
            result = @"commit";
            break;
        default:
            result = @"";
            break;
    }

    return result;
}

- (BTPayPalRequestFactory *)requestFactory {
    if (!_requestFactory) {
        _requestFactory = [[BTPayPalRequestFactory alloc] init];
    }
    return _requestFactory;
}

static Class PayPalClass;

+ (void)setPayPalClass:(Class)payPalClass {
    if ([payPalClass isSubclassOfClass:[PPOTCore class]]) {
        PayPalClass = payPalClass;
    }
}

+ (Class)payPalClass {
    return PayPalClass;
}

@end
