//
//  PPOTAuthorizationRequest_Internal.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTRequest.h"

@interface PPOTAuthorizationRequest ()

+ (instancetype)requestWithScopeValues:(NSSet *)scopeValues
                            privacyURL:(NSURL *)privacyURL
                          agreementURL:(NSURL *)agreementURL
                              clientID:(NSString *)clientID
                           environment:(NSString *)environment
                     callbackURLScheme:(NSString *)callbackURLScheme;

@end
