//
//  PPOTCheckoutRequest_Internal.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTRequest.h"

@interface PPOTCheckoutRequest ()

/*!
 @brief Factory method. Non-empty values for all parameters MUST be provided.

 @param approvalURL Client has already created a payment on PayPal server; this is the resulting HATEOS ApprovalURL
 @param clientID The app's Client ID, as obtained from developer.paypal.com
 @param environment PayPalEnvironmentProduction, PayPalEnvironmentMock, or PayPalEnvironmentSandbox;
        or else a stage indicated as `base-url:port`
 @param callbackURLScheme The URL scheme to be used for returning to this app, following an app-switch
*/
+ (nullable instancetype)requestWithApprovalURL:(nonnull NSURL *)approvalURL
                                       clientID:(nonnull NSString *)clientID
                                    environment:(nonnull NSString *)environment
                              callbackURLScheme:(nonnull NSString *)callbackURLScheme;

/*!
 @brief Factory method. Only pairingId can be nil.

 @param approvalURL Client has already created a payment on PayPal server; this is the resulting HATEOS ApprovalURL
 @param pairingId The pairingId for the risk component
 @param clientID The app's Client ID, as obtained from developer.paypal.com
 @param environment PayPalEnvironmentProduction, PayPalEnvironmentMock, or PayPalEnvironmentSandbox;
        or else a stage indicated as `base-url:port`
 @param callbackURLScheme The URL scheme to be used for returning to this app, following an app-switch
*/
+ (nullable instancetype)requestWithApprovalURL:(nonnull NSURL *)approvalURL
                                      pairingId:(nullable NSString *)pairingId
                                       clientID:(nonnull NSString *)clientID
                                    environment:(nonnull NSString *)environment
                              callbackURLScheme:(nonnull NSString *)callbackURLScheme;

@end
