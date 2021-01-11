#import "ReactNativePayments.h"
#import <React/RCTUtils.h>
#import <React/RCTEventDispatcher.h>

@implementation ReactNativePayments
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (NSDictionary *)constantsToExport
{
    return @{
             @"canMakePayments": @([PKPaymentAuthorizationViewController canMakePayments]),
             @"supportedGateways": [GatewayManager getSupportedGateways]
             };
}

RCT_EXPORT_METHOD(canMakePaymentsUsingNetworks:
                  (NSArray *)paymentNetworks
                  callback:(RCTResponseSenderBlock)callback)
{
    callback(@[[NSNull null], @([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentNetworks])]);
}

RCT_EXPORT_METHOD(createPaymentRequest: (NSDictionary *)methodData
                  details: (NSDictionary *)details
                  options: (NSDictionary *)options
                  callback: (RCTResponseSenderBlock)callback)
{
    NSString *merchantId = methodData[@"merchantIdentifier"];
    NSDictionary *gatewayParameters = methodData[@"paymentMethodTokenizationParameters"][@"parameters"];
    
    if (gatewayParameters) {
        self.hasGatewayParameters = true;
        self.gatewayManager = [GatewayManager new];
        [self.gatewayManager configureGateway:gatewayParameters merchantIdentifier:merchantId];
    }
    
    self.paymentRequest = [[PKPaymentRequest alloc] init];
    self.paymentRequest.merchantIdentifier = merchantId;
    self.paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
    self.paymentRequest.countryCode = methodData[@"countryCode"];
    self.paymentRequest.currencyCode = methodData[@"currencyCode"];
    self.paymentRequest.supportedNetworks = [self getSupportedNetworksFromMethodData:methodData];
    self.paymentRequest.paymentSummaryItems = [self getPaymentSummaryItemsFromDetails:details];
    self.paymentRequest.shippingMethods = [self getShippingMethodsFromDetails:details];
    
    [self setRequiredShippingAddressFieldsFromOptions:options];
    
    // Set options so that we can later access it.
    self.initialOptions = options;
    
    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(show:(RCTResponseSenderBlock)callback)
{
    
    self.viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: self.paymentRequest];
    self.viewController.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = RCTPresentedViewController();
        [rootViewController presentViewController:self.viewController animated:YES completion:nil];
        callback(@[[NSNull null]]);
    });
}

RCT_EXPORT_METHOD(abort: (RCTResponseSenderBlock)callback)
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    
    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(complete: (NSString *)paymentStatus
                  callback: (RCTResponseSenderBlock)callback)
{
    if ([paymentStatus isEqualToString: @"success"]) {
        self.completion(PKPaymentAuthorizationStatusSuccess);
    } else {
        self.completion(PKPaymentAuthorizationStatusFailure);
    }
    
    callback(@[[NSNull null]]);
}


-(void) paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onuserdismiss" body:nil];
}

RCT_EXPORT_METHOD(handleDetailsUpdate: (NSDictionary *)details
                  callback: (RCTResponseSenderBlock)callback)

{
    if (!self.shippingContactCompletion && !self.shippingMethodCompletion) {
        // TODO:
        // - Call callback with error saying shippingContactCompletion was never called;
        
        return;
    }
    
    NSArray<PKShippingMethod *> * shippingMethods = [self getShippingMethodsFromDetails:details];
    
    NSArray<PKPaymentSummaryItem *> * paymentSummaryItems = [self getPaymentSummaryItemsFromDetails:details];
    
    
    if (self.shippingMethodCompletion) {
        self.shippingMethodCompletion(
                                      PKPaymentAuthorizationStatusSuccess,
                                      paymentSummaryItems
                                      );
        
        // Invalidate `self.shippingMethodCompletion`
        self.shippingMethodCompletion = nil;
    }
    
    if (self.shippingContactCompletion) {
        // Display shipping address error when shipping is needed and shipping method count is below 1
        if (self.initialOptions[@"requestShipping"] && [shippingMethods count] == 0) {
            return self.shippingContactCompletion(
                                                  PKPaymentAuthorizationStatusInvalidShippingPostalAddress,
                                                  shippingMethods,
                                                  paymentSummaryItems
                                                  );
        } else {
            self.shippingContactCompletion(
                                           PKPaymentAuthorizationStatusSuccess,
                                           shippingMethods,
                                           paymentSummaryItems
                                           );
        }
        // Invalidate `aself.shippingContactCompletion`
        self.shippingContactCompletion = nil;
        
    }
    
    // Call callback
    callback(@[[NSNull null]]);
    
}

// DELEGATES
// ---------------
- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                        didAuthorizePayment:(PKPayment *)payment
                                 completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    // Store completion for later use
    self.completion = completion;
    
    if (self.hasGatewayParameters) {
        [self.gatewayManager createTokenWithPayment:payment completion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if (error) {
                [self handleGatewayError:error];
                return;
            }
            
            [self handleUserAccept:payment paymentToken:token];
        }];
    } else {
        [self handleUserAccept:payment paymentToken:nil];
    }
}


// Shipping Contact
- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingContact:(PKContact *)contact
                                 completion:(nonnull void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
    self.shippingContactCompletion = completion;
    
    CNPostalAddress *postalAddress = contact.postalAddress;
    // street, subAdministrativeArea, and subLocality are supressed for privacy
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onshippingaddresschange"
                                                    body:@{
                                                           @"recipient": [NSNull null],
                                                           @"organization": [NSNull null],
                                                           @"addressLine": [NSNull null],
                                                           @"city": postalAddress.city,
                                                           @"region": postalAddress.state,
                                                           @"country": [postalAddress.ISOCountryCode uppercaseString],
                                                           @"postalCode": postalAddress.postalCode,
                                                           @"phone": [NSNull null],
                                                           @"languageCode": [NSNull null],
                                                           @"sortingCode": [NSNull null],
                                                           @"dependentLocality": [NSNull null]
                                                           }];
}

// Shipping Method delegates
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
    self.shippingMethodCompletion = completion;
    
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onshippingoptionchange" body:@{
                                                                                                         @"selectedShippingOptionId": shippingMethod.identifier
                                                                                                         }];
    
}

// PRIVATE METHODS
// https://developer.apple.com/reference/passkit/pkpaymentnetwork
// ---------------
- (NSArray *_Nonnull)getSupportedNetworksFromMethodData:(NSDictionary *_Nonnull)methodData
{
    NSMutableDictionary *supportedNetworksMapping = [[NSMutableDictionary alloc] init];
    
    CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (iOSVersion >= 8) {
        [supportedNetworksMapping setObject:PKPaymentNetworkAmex forKey:@"amex"];
        [supportedNetworksMapping setObject:PKPaymentNetworkMasterCard forKey:@"mastercard"];
        [supportedNetworksMapping setObject:PKPaymentNetworkVisa forKey:@"visa"];
    }
    
    if (iOSVersion >= 9) {
        [supportedNetworksMapping setObject:PKPaymentNetworkDiscover forKey:@"discover"];
        [supportedNetworksMapping setObject:PKPaymentNetworkPrivateLabel forKey:@"privatelabel"];
    }
    
    if (iOSVersion >= 9.2) {
        [supportedNetworksMapping setObject:PKPaymentNetworkChinaUnionPay forKey:@"chinaunionpay"];
        [supportedNetworksMapping setObject:PKPaymentNetworkInterac forKey:@"interac"];
    }
    
    if (iOSVersion >= 10.1) {
        [supportedNetworksMapping setObject:PKPaymentNetworkJCB forKey:@"jcb"];
        [supportedNetworksMapping setObject:PKPaymentNetworkSuica forKey:@"suica"];
    }
    
    if (iOSVersion >= 10.3) {
        [supportedNetworksMapping setObject:PKPaymentNetworkCarteBancaire forKey:@"cartebancaires"];
        [supportedNetworksMapping setObject:PKPaymentNetworkIDCredit forKey:@"idcredit"];
        [supportedNetworksMapping setObject:PKPaymentNetworkQuicPay forKey:@"quicpay"];
    }
    
    if (iOSVersion >= 11) {
        [supportedNetworksMapping setObject:PKPaymentNetworkCarteBancaires forKey:@"cartebancaires"];
    }

    if (iOSVersion >= 12.1) {
        [supportedNetworksMapping setObject:PKPaymentNetworkMada forKey:@"mada"];
    }
    
    if (iOSVersion >= 12.1) {
        [supportedNetworksMapping setObject:PKPaymentNetworkMada forKey:@"mada"];
    }
    
    // Setup supportedNetworks
    NSArray *jsSupportedNetworks = methodData[@"supportedNetworks"];
    NSMutableArray *supportedNetworks = [NSMutableArray array];
    for (NSString *supportedNetwork in jsSupportedNetworks) {
        [supportedNetworks addObject: supportedNetworksMapping[supportedNetwork]];
    }
    
    return supportedNetworks;
}

- (NSArray<PKPaymentSummaryItem *> *_Nonnull)getPaymentSummaryItemsFromDetails:(NSDictionary *_Nonnull)details
{
    // Setup `paymentSummaryItems` array
    NSMutableArray <PKPaymentSummaryItem *> * paymentSummaryItems = [NSMutableArray array];
    
    // Add `displayItems` to `paymentSummaryItems`
    NSArray *displayItems = details[@"displayItems"];
    if (displayItems.count > 0) {
        for (NSDictionary *displayItem in displayItems) {
            [paymentSummaryItems addObject: [self convertDisplayItemToPaymentSummaryItem:displayItem]];
        }
    }
    
    // Add total to `paymentSummaryItems`
    NSDictionary *total = details[@"total"];
    [paymentSummaryItems addObject: [self convertDisplayItemToPaymentSummaryItem:total]];
    
    return paymentSummaryItems;
}

- (NSArray<PKShippingMethod *> *_Nonnull)getShippingMethodsFromDetails:(NSDictionary *_Nonnull)details
{
    // Setup `shippingMethods` array
    NSMutableArray <PKShippingMethod *> * shippingMethods = [NSMutableArray array];
    
    // Add `shippingOptions` to `shippingMethods`
    NSArray *shippingOptions = details[@"shippingOptions"];
    if (shippingOptions.count > 0) {
        for (NSDictionary *shippingOption in shippingOptions) {
            [shippingMethods addObject: [self convertShippingOptionToShippingMethod:shippingOption]];
        }
    }
    
    return shippingMethods;
}

- (PKPaymentSummaryItem *_Nonnull)convertDisplayItemToPaymentSummaryItem:(NSDictionary *_Nonnull)displayItem;
{
    NSDecimalNumber *decimalNumberAmount = [NSDecimalNumber decimalNumberWithString:displayItem[@"amount"][@"value"]];
    PKPaymentSummaryItem *paymentSummaryItem = [PKPaymentSummaryItem summaryItemWithLabel:displayItem[@"label"] amount:decimalNumberAmount];
    
    return paymentSummaryItem;
}

- (PKShippingMethod *_Nonnull)convertShippingOptionToShippingMethod:(NSDictionary *_Nonnull)shippingOption
{
    PKShippingMethod *shippingMethod = [PKShippingMethod summaryItemWithLabel:shippingOption[@"label"] amount:[NSDecimalNumber decimalNumberWithString: shippingOption[@"amount"][@"value"]]];
    shippingMethod.identifier = shippingOption[@"id"];
    
    // shippingOption.detail is not part of the PaymentRequest spec.
    if ([shippingOption[@"detail"] isKindOfClass:[NSString class]]) {
        shippingMethod.detail = shippingOption[@"detail"];
    } else {
        shippingMethod.detail = @"";
    }
    
    return shippingMethod;
}

- (void)setRequiredShippingAddressFieldsFromOptions:(NSDictionary *_Nonnull)options
{
    // Request Shipping
    if (options[@"requestShipping"]) {
        self.paymentRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress;
    }

    if (options[@"requestBilling"]) {
        self.paymentRequest.requiredBillingAddressFields = PKAddressFieldPostalAddress;
    }
    
    if (options[@"requestPayerName"]) {
        self.paymentRequest.requiredShippingAddressFields = self.paymentRequest.requiredShippingAddressFields | PKAddressFieldName;
    }
    
    if (options[@"requestPayerPhone"]) {
        self.paymentRequest.requiredShippingAddressFields = self.paymentRequest.requiredShippingAddressFields | PKAddressFieldPhone;
    }
    
    if (options[@"requestPayerEmail"]) {
        self.paymentRequest.requiredShippingAddressFields = self.paymentRequest.requiredShippingAddressFields | PKAddressFieldEmail;
    }
}

- (NSString *_Nonnull)contactToString:(PKContact *_Nonnull)contact
{
    NSString *namePrefix = contact.name.namePrefix;
    NSString *givenName = contact.name.givenName;
    NSString *middleName = contact.name.middleName;
    NSString *familyName = contact.name.familyName;
    NSString *nameSuffix = contact.name.nameSuffix;
    NSString *nickname = contact.name.nickname;
    NSString *street = contact.postalAddress.street;
    NSString *subLocality = contact.postalAddress.subLocality;
    NSString *city = contact.postalAddress.city;
    NSString *subAdministrativeArea = contact.postalAddress.subAdministrativeArea;
    NSString *state = contact.postalAddress.state;
    NSString *postalCode = contact.postalAddress.postalCode;
    NSString *country = contact.postalAddress.country;
    NSString *ISOCountryCode = contact.postalAddress.ISOCountryCode;
    NSString *phoneNumber = contact.phoneNumber.stringValue;
    NSString *emailAddress = contact.emailAddress;
    
    NSDictionary *contactDict = @{
         @"name" : @{
                 @"namePrefix" : namePrefix ?: @"",
                 @"givenName" : givenName ?: @"",
                 @"middleName" : middleName ?: @"",
                 @"familyName" : familyName ?: @"",
                 @"nameSuffix" : nameSuffix ?: @"",
                 @"nickname" : nickname ?: @"",
         },
         @"postalAddress" : @{
                 @"street" : street ?: @"",
                 @"subLocality" : subLocality ?: @"",
                 @"city" : city ?: @"",
                 @"subAdministrativeArea" : subAdministrativeArea ?: @"",
                 @"state" : state ?: @"",
                 @"postalCode" : postalCode ?: @"",
                 @"country" : country ?: @"",
                 @"ISOCountryCode" : ISOCountryCode ?: @""
         },
         @"phoneNumber" : phoneNumber ?: @"",
         @"emailAddress" : emailAddress ?: @""
    };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contactDict options:0 error:&error];
    
    if (! jsonData) {
       return @"";
    } else {
       return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
}

- (NSDictionary *_Nonnull)paymentMethodToString:(PKPaymentMethod *_Nonnull)paymentMethod
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]initWithCapacity:4];

    if(paymentMethod.displayName) {
        [result setObject:paymentMethod.displayName forKey:@"displayName"];
    }
    if (paymentMethod.network) {
        [result setObject:paymentMethod.network forKey:@"network"];
    }
    NSString *type = [self paymentMethodTypeToString:paymentMethod.type];
    [result setObject:type forKey:@"type"];
    if(paymentMethod.paymentPass) {
        NSDictionary *paymentPass = [self paymentPassToDictionary:paymentMethod.paymentPass];
        [result setObject:paymentPass forKey:@"paymentPass"];
    }

    return result;
}

- (NSString *_Nonnull)paymentMethodTypeToString:(PKPaymentMethodType)paymentMethodType
{
    NSArray *arr = @[@"PKPaymentMethodTypeUnknown",
                     @"PKPaymentMethodTypeDebit",
                     @"PKPaymentMethodTypeCredit",
                     @"PKPaymentMethodTypePrepaid",
                     @"PKPaymentMethodTypeStore"];
    return (NSString *)[arr objectAtIndex:paymentMethodType];
}

- (NSDictionary *_Nonnull)paymentPassToDictionary:(PKPaymentPass *_Nonnull)paymentPass
{
    return @{
        @"primaryAccountIdentifier" : paymentPass.primaryAccountIdentifier,
        @"primaryAccountNumberSuffix" : paymentPass.primaryAccountNumberSuffix,
        @"deviceAccountIdentifier" : paymentPass.deviceAccountIdentifier,
        @"deviceAccountNumberSuffix" : paymentPass.deviceAccountNumberSuffix,
        @"activationState" : [self paymentPassActivationStateToString:paymentPass.activationState]
    };
}

- (NSString *_Nonnull)paymentPassActivationStateToString:(PKPaymentPassActivationState)paymentPassActivationState
{
    NSArray *arr = @[@"PKPaymentPassActivationStateActivated",
                     @"PKPaymentPassActivationStateRequiresActivation",
                     @"PKPaymentPassActivationStateActivating",
                     @"PKPaymentPassActivationStateSuspended",
                     @"PKPaymentPassActivationStateDeactivated"];
    return (NSString *)[arr objectAtIndex:paymentPassActivationState];
}

- (void)handleUserAccept:(PKPayment *_Nonnull)payment
            paymentToken:(NSString *_Nullable)token
{
    NSMutableDictionary *paymentResponse = [[NSMutableDictionary alloc]initWithCapacity:6];

    NSString *transactionId = payment.token.transactionIdentifier;
    [paymentResponse setObject:transactionId forKey:@"transactionIdentifier"];

    NSString *paymentData = [[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding];
    [paymentResponse setObject:paymentData forKey:@"paymentData"];

    NSDictionary *paymentMethod = [self paymentMethodToString:payment.token.paymentMethod];
    [paymentResponse setObject:paymentMethod forKey:@"paymentMethod"];

    if (token) {
        [paymentResponse setObject:token forKey:@"paymentToken"];
    }

    if (payment.billingContact) {
        paymentResponse[@"billingContact"] = [self contactToString:payment.billingContact];
    }
   
    if (payment.shippingContact) {
        paymentResponse[@"shippingContact"] = [self contactToString:payment.shippingContact];
    }
    
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onuseraccept"
                                                    body:paymentResponse
     ];
}

- (void)handleGatewayError:(NSError *_Nonnull)error
{
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:ongatewayerror"
                                                    body: @{
                                                            @"error": [error localizedDescription]
                                                            }
     ];
}

@end
