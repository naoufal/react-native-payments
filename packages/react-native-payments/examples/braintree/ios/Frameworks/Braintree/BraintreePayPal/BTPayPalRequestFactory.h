#import <Foundation/Foundation.h>
#import "PPOTRequest.h"
#import "PPOTCore.h"

@interface BTPayPalRequestFactory : NSObject

/*!
 @brief Creates PayPal Express Checkout requests
*/
- (PPOTCheckoutRequest *)checkoutRequestWithApprovalURL:(NSURL *)approvalURL
                                               clientID:(NSString *)clientID
                                            environment:(NSString *)environment
                                      callbackURLScheme:(NSString *)callbackURLScheme;

/*!
 @brief Creates PayPal Billing Agreement requests
*/
- (PPOTBillingAgreementRequest *)billingAgreementRequestWithApprovalURL:(NSURL *)approvalURL
                                                               clientID:(NSString *)clientID
                                                            environment:(NSString *)environment
                                                      callbackURLScheme:(NSString *)callbackURLScheme;

/*!
 @brief Creates PayPal Future Payment requests
*/
- (PPOTAuthorizationRequest *)requestWithScopeValues:(NSSet *)scopeValues
                                          privacyURL:(NSURL *)privacyURL
                                        agreementURL:(NSURL *)agreementURL
                                            clientID:(NSString *)clientID
                                         environment:(NSString *)environment
                                   callbackURLScheme:(NSString *)callbackURLScheme;

@end
