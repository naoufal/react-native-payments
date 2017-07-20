//
//  PPOTError.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTError.h"

@implementation PPOTError

+ (NSError *)errorWithErrorCode:(PPOTErrorCode)errorCode {
    return [self errorWithErrorCode:errorCode userInfo:nil];
}

+ (NSError *)errorWithErrorCode:(PPOTErrorCode)errorCode userInfo:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:kPayPalOneTouchErrorDomain code:errorCode userInfo:userInfo];
}

@end
