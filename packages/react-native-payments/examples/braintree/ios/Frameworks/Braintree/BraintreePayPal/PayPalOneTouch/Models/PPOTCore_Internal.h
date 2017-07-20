//
//  PPOTCore_Internal.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTCore.h"

// eg PayPalSDK/OneTouchCore-iOS 1.2.1-g1234567-dirty (iOS 8.1; iPhone 6+; DEBUG)
#ifdef DEBUG
#define PP_PRODUCT_STRING [NSString stringWithFormat:@"PayPalSDK/OneTouchCore-iOS %@ (%@; %@; %@)", PayPalOTVersion(), [PPOTDevice deviceName], [PPOTDevice hardwarePlatform], @"DEBUG"]
#else
#define PP_PRODUCT_STRING [NSString stringWithFormat:@"PayPalSDK/OneTouchCore-iOS %@ (%@; %@; %@)", PayPalOTVersion(), [PPOTDevice deviceName], [PPOTDevice hardwarePlatform], @"RELEASE"]
#endif

@interface PPOTCore ()

+ (BOOL)isValidURLAction:(NSURL *)urlAction;

@end
