#import "BTThreeDSecureDriver_Internal.h"
#if __has_include("BraintreeCore.h")
#import "BTAPIClient_Internal.h"
#else
#import <BraintreeCore/BTAPIClient_Internal.h>
#endif
#if __has_include("BraintreeCard.h")
#import "BTCardNonce_Internal.h"
#else
#import <BraintreeCard/BTCardNonce_Internal.h>
#endif
#import "BTLogger_Internal.h"
#import "BTThreeDSecureAuthenticationViewController.h"
#import "BTThreeDSecureDriver.h"
#import "BTThreeDSecureLookupResult.h"
#import "BTThreeDSecureCardNonce.h"


@interface BTThreeDSecureDriver () <BTThreeDSecureAuthenticationViewControllerDelegate>

@end

@implementation BTThreeDSecureDriver

+ (void)load {
    if (self == [BTThreeDSecureDriver class]) {
        [[BTTokenizationService sharedService] registerType:@"ThreeDSecure" withTokenizationBlock:^(BTAPIClient *apiClient, __unused NSDictionary *options, void (^completionBlock)(BTPaymentMethodNonce *paymentMethodNonce, NSError *error)) {
            if (options[BTTokenizationServiceViewPresentingDelegateOption] == nil ||
                [options[BTTokenizationServiceNonceOption] length] == 0 ||
                options[BTTokenizationServiceAmountOption] == nil) {
                NSError *error = [NSError errorWithDomain:BTTokenizationServiceErrorDomain
                                                     code:BTTokenizationServiceErrorTypeNotRegistered
                                                 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Invalid parameters"],
                                                            NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"BTThreeDSecureDriver has invalid parameters"],
                                                            NSLocalizedRecoverySuggestionErrorKey: [NSString stringWithFormat:@"Check options parmeters"]
                                                            }];
                completionBlock(nil, error);
            } else {
                BTThreeDSecureDriver *driver = [[BTThreeDSecureDriver alloc] initWithAPIClient:apiClient delegate:options[BTTokenizationServiceViewPresentingDelegateOption]];

                [driver verifyCardWithNonce:options[BTTokenizationServiceNonceOption]
                                           amount:options[BTTokenizationServiceAmountOption]
                                       completion:completionBlock];
            }
        }];
    }
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"-init is not available for BTThreeDSecureDriver. Use -initWithAPIClient:delegate: instead." userInfo:nil];
}

- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient delegate:(id<BTViewControllerPresentingDelegate>)delegate {
    // Defensive programming: apiClient and delegate parameters are annotated as nonnull
    if (apiClient == nil || delegate == nil) {
        return nil;
    }
    if (self = [super init]) {
        _apiClient = apiClient;
        _delegate = delegate;
    }
    return self;
}

#pragma mark - Custom accessors

- (void)setDelegate:(id<BTViewControllerPresentingDelegate>)delegate {
    if (![delegate conformsToProtocol:@protocol(BTViewControllerPresentingDelegate)]) {
        [[BTLogger sharedLogger] warning:@"Delegate does not conform to BTViewControllerPresentingDelegate"];
    }
    _delegate = delegate;
}

#pragma mark - Public methods

- (void)verifyCardWithNonce:(NSString *)nonce
                     amount:(NSDecimalNumber *)amount
                 completion:(void (^)(BTThreeDSecureCardNonce *, NSError *))completionBlock
{
    [self lookupThreeDSecureForNonce:nonce
                   transactionAmount:amount
                          completion:^(BTThreeDSecureLookupResult *lookupResult, NSError *error) {
                              if (error) {
                                  completionBlock(nil, error);
                                  return;
                              }

                              if (lookupResult.requiresUserAuthentication) {
                                  self.completionBlockAfterAuthenticating = [completionBlock copy];

                                  BTThreeDSecureAuthenticationViewController *authenticationViewController = [[BTThreeDSecureAuthenticationViewController alloc] initWithLookupResult:lookupResult];
                                  authenticationViewController.delegate = self;
                                  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:authenticationViewController];
                                  [self informDelegateRequestsPresentationOfViewController:navigationController];
                                  [self.apiClient sendAnalyticsEvent:@"ios.threedsecure.authentication-start"];
                              } else {
                                  completionBlock(lookupResult.tokenizedCard, nil);
                              }
                          }];

}

- (void)lookupThreeDSecureForNonce:(NSString *)nonce
                 transactionAmount:(NSDecimalNumber *)amount
                        completion:(void (^)(BTThreeDSecureLookupResult *lookupResult, NSError *error))completionBlock
{
    if (!self.apiClient) {
        NSError *error = [NSError errorWithDomain:BTThreeDSecureErrorDomain
                                             code:BTThreeDSecureErrorTypeIntegration
                                         userInfo:@{NSLocalizedDescriptionKey: @"BTThreeDSecureDriver failed because BTAPIClient is nil."}];
        completionBlock(nil, error);
        return;
    }
    
    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }

        NSMutableDictionary *requestParameters = [@{ @"amount": amount } mutableCopy];

        if (configuration.json[@"merchantAccountId"]) {
            requestParameters[@"merchant_account_id"] = [configuration.json[@"merchantAccountId"] asString];
        }
        NSString *urlSafeNonce = [nonce stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.apiClient POST:[NSString stringWithFormat:@"v1/payment_methods/%@/three_d_secure/lookup", urlSafeNonce]
                  parameters:requestParameters
                  completion:^(BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error) {

                      if (error) {
                          // Provide more context for card validation error when status code 422
                          if ([error.domain isEqualToString:BTHTTPErrorDomain] &&
                              error.code == BTHTTPErrorCodeClientError &&
                              ((NSHTTPURLResponse *)error.userInfo[BTHTTPURLResponseKey]).statusCode == 422) {

                              NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
                              BTJSON *errorBody = error.userInfo[BTHTTPJSONResponseBodyKey];

                              if ([errorBody[@"error"][@"message"] isString]) {
                                  userInfo[NSLocalizedDescriptionKey] = [errorBody[@"error"][@"message"] asString];
                              }
                              if ([errorBody[@"threeDSecureInfo"] isObject]) {
                                  userInfo[BTThreeDSecureInfoKey] = [errorBody[@"threeDSecureInfo"] asDictionary];
                              }
                              if ([errorBody[@"error"] isObject]) {
                                  userInfo[BTThreeDSecureValidationErrorsKey] = [errorBody[@"error"] asDictionary];
                              }

                              error = [NSError errorWithDomain:BTThreeDSecureErrorDomain
                                                         code:BTThreeDSecureErrorTypeFailedLookup
                                                     userInfo:userInfo];
                          }

                          completionBlock(nil, error);
                          return;
                      }

                      BTJSON *lookupJSON = body[@"lookup"];

                      BTThreeDSecureLookupResult *lookup = [[BTThreeDSecureLookupResult alloc] init];
                      lookup.acsURL = [lookupJSON[@"acsUrl"] asURL];
                      lookup.PAReq = [lookupJSON[@"pareq"] asString];
                      lookup.MD = [lookupJSON[@"md"] asString];
                      lookup.termURL = [lookupJSON[@"termUrl"] asURL];
                      lookup.tokenizedCard = [BTThreeDSecureCardNonce cardNonceWithJSON:body[@"paymentMethod"]];

                      completionBlock(lookup, nil);
                  }];
    }];
}

#pragma mark BTThreeDSecureAuthenticationViewControllerDelegate

- (void)threeDSecureViewController:(__unused BTThreeDSecureAuthenticationViewController *)viewController
               didAuthenticateCard:(BTThreeDSecureCardNonce *)tokenizedCard
                        completion:(void (^)(BTThreeDSecureViewControllerCompletionStatus))completionBlock
{
    self.upgradedTokenizedCard = tokenizedCard;
    completionBlock(BTThreeDSecureViewControllerCompletionStatusSuccess);
    [self.apiClient sendAnalyticsEvent:@"ios.threedsecure.authenticated"];
}

- (void)threeDSecureViewController:(__unused BTThreeDSecureAuthenticationViewController *)viewController
                  didFailWithError:(NSError *)error {
    if ([error.domain isEqualToString:BTThreeDSecureErrorDomain] && error.code == BTThreeDSecureErrorTypeFailedAuthentication) {
        [self.apiClient sendAnalyticsEvent:@"ios.threedsecure.error.auth-failure"];
    } else {
        [self.apiClient sendAnalyticsEvent:@"ios.threedsecure.error.unrecognized-error"];
    }

    self.upgradedTokenizedCard = nil;
    self.completionBlockAfterAuthenticating(nil, error);
    self.completionBlockAfterAuthenticating = nil;
    [self informDelegateRequestsDismissalOfViewController:viewController];
}

- (void)threeDSecureViewControllerDidFinish:(BTThreeDSecureAuthenticationViewController *)viewController {
    if (self.completionBlockAfterAuthenticating != nil) {
        if (self.upgradedTokenizedCard) {
            self.completionBlockAfterAuthenticating(self.upgradedTokenizedCard, nil);
        } else {
            self.completionBlockAfterAuthenticating(nil, nil);
            [self.apiClient sendAnalyticsEvent:@"ios.threedsecure.canceled"];
        }

        self.completionBlockAfterAuthenticating = nil;
        [self informDelegateRequestsDismissalOfViewController:viewController];
    } else {
        [self.apiClient sendAnalyticsEvent:@"ios.threedsecure.error.finished-without-handler"];
    }
}

- (void)threeDSecureViewController:(__unused BTThreeDSecureAuthenticationViewController *)viewController
      didPresentErrorForURLRequest:(NSURLRequest *)request {
    [self.apiClient sendAnalyticsEvent:[NSString stringWithFormat:@"ios.threedsecure.error.webview-error.%@", request.URL.host]];
}

#pragma mark Delegate informer helpers

- (void)informDelegateRequestsPresentationOfViewController:(UIViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(paymentDriver:requestsPresentationOfViewController:)]) {
        [self.delegate paymentDriver:self requestsPresentationOfViewController:viewController];
    }
}

- (void)informDelegateRequestsDismissalOfViewController:(UIViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(paymentDriver:requestsDismissalOfViewController:)]) {
        [self.delegate paymentDriver:self requestsDismissalOfViewController:viewController];
    }
}

@end
