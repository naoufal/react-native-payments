//
//  PPOTDevice.h
//  Copyright © 2009 PayPal, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPOTDevice : NSObject

/*!
 @return the hardware platform used
*/
+ (nonnull NSString *)hardwarePlatform;

/*!
 @return the name of the device
*/
+ (nonnull NSString *)deviceName;

/*!
 @return the device's locale
*/
+ (nonnull NSString *)complicatedDeviceLocale;

/*!
 @brief Generates a device identifier and stores it.

 @return a generated device identifier
*/
+ (nonnull NSString *)appropriateIdentifier;

/*!
 @brief Clears any stored device identifier.
*/
+ (void)clearIdentifier;

@end
