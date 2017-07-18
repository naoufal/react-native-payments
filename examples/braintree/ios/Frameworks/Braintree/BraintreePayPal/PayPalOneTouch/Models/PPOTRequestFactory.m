//
//  PPOTRequestFactory.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTRequestFactory.h"

#import "PPOTCheckoutRequest_Internal.h"
#import "PPOTAuthorizationRequest_Internal.h"

@implementation PPOTRequestFactory

+ (nullable PPOTCheckoutRequest *)checkoutRequestWithApprovalURL:(nonnull NSURL *)approvalURL
                                                        clientID:(nonnull NSString *)clientID
                                                     environment:(nonnull NSString *)environment
                                               callbackURLScheme:(nonnull NSString *)callbackURLScheme {
    return [PPOTCheckoutRequest requestWithApprovalURL:approvalURL
                                              clientID:clientID
                                           environment:environment
                                     callbackURLScheme:callbackURLScheme];
}

+ (nullable PPOTCheckoutRequest *)checkoutRequestWithApprovalURL:(nonnull NSURL *)approvalURL
                                                       pairingId:(nullable NSString *)pairingId
                                                        clientID:(nonnull NSString *)clientID
                                                     environment:(nonnull NSString *)environment
                                               callbackURLScheme:(nonnull NSString *)callbackURLScheme {
    return [PPOTCheckoutRequest requestWithApprovalURL:approvalURL
                                             pairingId:pairingId
                                              clientID:clientID
                                           environment:environment
                                     callbackURLScheme:callbackURLScheme];
}

+ (nullable PPOTAuthorizationRequest *)authorizationRequestWithScopeValues:(nonnull NSSet *)scopeValues
                                                                privacyURL:(nonnull NSURL *)privacyURL
                                                              agreementURL:(nonnull NSURL *)agreementURL
                                                                  clientID:(nonnull NSString *)clientID
                                                               environment:(nonnull NSString *)environment
                                                         callbackURLScheme:(nonnull NSString *)callbackURLScheme {
    return [PPOTAuthorizationRequest requestWithScopeValues:scopeValues
                                                 privacyURL:privacyURL
                                               agreementURL:agreementURL
                                                   clientID:clientID
                                                environment:environment
                                          callbackURLScheme:callbackURLScheme];
}

+ (nullable PPOTBillingAgreementRequest *)billingAgreementRequestWithApprovalURL:(nonnull NSURL *)approvalURL
                                                                        clientID:(nonnull NSString *)clientID
                                                                     environment:(nonnull NSString *)environment
                                                               callbackURLScheme:(nonnull NSString *)callbackURLScheme {
    return [PPOTBillingAgreementRequest requestWithApprovalURL:approvalURL
                                                      clientID:clientID
                                                   environment:environment
                                             callbackURLScheme:callbackURLScheme];
}

+ (nullable PPOTBillingAgreementRequest *)billingAgreementRequestWithApprovalURL:(nonnull NSURL *)approvalURL
                                                                       pairingId:(nullable NSString *)pairingId
                                                                        clientID:(nonnull NSString *)clientID
                                                                     environment:(nonnull NSString *)environment
                                                               callbackURLScheme:(nonnull NSString *)callbackURLScheme {
    return [PPOTBillingAgreementRequest requestWithApprovalURL:approvalURL
                                                     pairingId:pairingId
                                                      clientID:clientID
                                                   environment:environment
                                             callbackURLScheme:callbackURLScheme];
}

@end
