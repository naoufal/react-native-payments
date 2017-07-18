//
//  PPOTError.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOTCore.h"

@interface PPOTError : NSObject

/*!
 @param errorCode the error code to use
 @return NSError with the code given
*/
+ (NSError *)errorWithErrorCode:(PPOTErrorCode)errorCode;

/*!
 @param errorCode the error code to use
 @param userInfo the error's info dictionary
 @return NSError with the code given
*/
+ (NSError *)errorWithErrorCode:(PPOTErrorCode)errorCode userInfo:(NSDictionary *)userInfo;

@end
