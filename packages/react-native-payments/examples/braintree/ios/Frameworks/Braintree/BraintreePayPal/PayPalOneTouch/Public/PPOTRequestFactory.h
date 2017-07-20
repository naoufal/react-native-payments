//
//  PPOTRequestFactory.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOTRequest.h"

@interface PPOTRequestFactory : NSObject

/*!
 @brief Factory method. Non-empty values for all parameters MUST be provided.

 @param approvalURL Client has already created a payment on PayPal server; this is the resulting HATEOS ApprovalURL
 @param clientID The app's Client ID, as obtained from developer.paypal.com
 @param environment `PayPalEnvironmentProduction`, `PayPalEnvironmentMock`, or `PayPalEnvironmentSandbox`;
        or else a stage indicated as `base-url:port`
 @param callbackURLScheme The URL scheme to be used for returning to this app, following an app-switch
*/
+ (nullable PPOTCheckoutRequest *)checkoutRequestWithApprovalURL:(nonnull NSURL *)approvalURL
                                                        clientID:(nonnull NSString *)clientID
                                                     environment:(nonnull NSString *)environment
                                               callbackURLScheme:(nonnull NSString *)callbackURLScheme;

/*!
 @brief Factory method. Only `pairingId` can be nil.

 @param approvalURL Client has already created a payment on PayPal server; this is the resulting HATEOS ApprovalURL
 @param pairingId The pairing ID for the risk component. Optional.
 @param clientID The app's Client ID, as obtained from developer.paypal.com
 @param environment `PayPalEnvironmentProduction`, `PayPalEnvironmentMock`, or `PayPalEnvironmentSandbox`;
        or else a stage indicated as `base-url:port`
 @param callbackURLScheme The URL scheme to be used for returning to this app, following an app-switch
*/
+ (nullable PPOTCheckoutRequest *)checkoutRequestWithApprovalURL:(nonnull NSURL *)approvalURL
                                                       pairingId:(nullable NSString *)pairingId
                                                        clientID:(nonnull NSString *)clientID
                                                     environment:(nonnull NSString *)environment
                                               callbackURLScheme:(nonnull NSString *)callbackURLScheme;

/*!
 @brief Factory method. Non-empty values for all parameters MUST be provided.

 @param scopeValues Set of requested scope-values.
        Available scope-values are listed at https://developer.paypal.com/webapps/developer/docs/integration/direct/identity/attributes/
 @param privacyURL The URL of the merchant's privacy policy
 @param agreementURL The URL of the merchant's user agreement
 @param clientID The app's Client ID, as obtained from developer.paypal.com
 @param environment `PayPalEnvironmentProduction`, `PayPalEnvironmentMock`, or `PayPalEnvironmentSandbox`;
        or else a stage indicated as `base-url:port`
 @param callbackURLScheme The URL scheme to be used for returning to this app, following an app-switch
*/
+ (nullable PPOTAuthorizationRequest *)authorizationRequestWithScopeValues:(nonnull NSSet *)scopeValues
                                                                privacyURL:(nonnull NSURL *)privacyURL
                                                              agreementURL:(nonnull NSURL *)agreementURL
                                                                  clientID:(nonnull NSString *)clientID
                                                               environment:(nonnull NSString *)environment
                                                         callbackURLScheme:(nonnull NSString *)callbackURLScheme;

/*!
 @brief Factory method. Non-empty values for all parameters MUST be provided.

 @param approvalURL Client has already created a payment on PayPal server; this is the resulting HATEOS ApprovalURL
 @param clientID The app's Client ID, as obtained from developer.paypal.com
 @param environment `PayPalEnvironmentProduction`, `PayPalEnvironmentMock`, or `PayPalEnvironmentSandbox`;
        or else a stage indicated as `base-url:port`
 @param callbackURLScheme The URL scheme to be used for returning to this app, following an app-switch
*/
+ (nullable PPOTBillingAgreementRequest *)billingAgreementRequestWithApprovalURL:(nonnull NSURL *)approvalURL
                                                                        clientID:(nonnull NSString *)clientID
                                                                     environment:(nonnull NSString *)environment
                                                               callbackURLScheme:(nonnull NSString *)callbackURLScheme;

/*!
 @brief Factory method. Only pairingId can be nil.

 @param approvalURL Client has already created a payment on PayPal server; this is the resulting HATEOS ApprovalURL
 @param pairingId The pairing ID for the risk component. Optional.
 @param clientID The app's Client ID, as obtained from developer.paypal.com
 @param environment `PayPalEnvironmentProduction`, `PayPalEnvironmentMock`, or `PayPalEnvironmentSandbox`;
        or else a stage indicated as `base-url:port`
 @param callbackURLScheme The URL scheme to be used for returning to this app, following an app-switch
*/
+ (nullable PPOTBillingAgreementRequest *)billingAgreementRequestWithApprovalURL:(nonnull NSURL *)approvalURL
                                                                       pairingId:(nullable NSString *)pairingId
                                                                        clientID:(nonnull NSString *)clientID
                                                                     environment:(nonnull NSString *)environment
                                                               callbackURLScheme:(nonnull NSString *)callbackURLScheme;

@end
