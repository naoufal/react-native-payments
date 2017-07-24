#import "BTPayPalRequestFactory.h"
#import "PPOTRequestFactory.h"

@implementation BTPayPalRequestFactory

- (PPOTCheckoutRequest *)checkoutRequestWithApprovalURL:(NSURL *)approvalURL
                                               clientID:(NSString *)clientID
                                            environment:(NSString *)environment
                                      callbackURLScheme:(NSString *)callbackURLScheme
{
    return [PPOTRequestFactory checkoutRequestWithApprovalURL:approvalURL
                                                    pairingId:[PPOTRequest tokenFromApprovalURL:approvalURL]
                                                     clientID:clientID
                                                  environment:environment
                                            callbackURLScheme:callbackURLScheme];
}

- (PPOTBillingAgreementRequest *)billingAgreementRequestWithApprovalURL:(NSURL *)approvalURL
                                                               clientID:(NSString *)clientID
                                                            environment:(NSString *)environment
                                                      callbackURLScheme:(NSString *)callbackURLScheme
{
    return [PPOTRequestFactory billingAgreementRequestWithApprovalURL:approvalURL
                                                            pairingId:[PPOTRequest tokenFromApprovalURL:approvalURL]
                                                             clientID:clientID
                                                          environment:environment
                                                    callbackURLScheme:callbackURLScheme];
}

- (PPOTAuthorizationRequest *)requestWithScopeValues:(NSSet *)scopeValues
                                          privacyURL:(NSURL *)privacyURL
                                        agreementURL:(NSURL *)agreementURL
                                            clientID:(NSString *)clientID
                                         environment:(NSString *)environment
                                   callbackURLScheme:(NSString *)callbackURLScheme
{
    return [PPOTRequestFactory authorizationRequestWithScopeValues:scopeValues
                                                        privacyURL:privacyURL
                                                      agreementURL:agreementURL
                                                          clientID:clientID
                                                       environment:environment
                                                 callbackURLScheme:callbackURLScheme];
}

@end
