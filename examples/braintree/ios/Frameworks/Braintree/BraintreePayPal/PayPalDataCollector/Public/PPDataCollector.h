//
//  PPDataCollector.h
//  PayPalDataCollector
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPDataCollector : NSObject

/*!
 @brief Returns a client metadata ID.

 @note This returns a raw client metadata ID, which is not the correct format for device data
 when creating a transaction. Instead, it is recommended to use `collectPayPalDeviceData`.

 @param pairingID a pairing ID to associate with this clientMetadataID must be 10-32 chars long or null
 @return a client metadata ID to send as a header
*/
+ (nonnull NSString *)clientMetadataID:(nullable NSString *)pairingID;

/*!
 @brief Returns a client metadata ID.

 @note This returns a raw client metadata ID, which is not the correct format for device data
 when creating a transaction. Instead, it is recommended to use `collectPayPalDeviceData`.

 @return a client metadata ID to send as a header
*/
+ (nonnull NSString *)clientMetadataID DEPRECATED_MSG_ATTRIBUTE("Use [PPDataCollector collectPayPalDeviceData] to generate a device data string.");

/*!
 @brief Collects device data for PayPal.

 @discussion This should be used when the user is paying with PayPal or Venmo only.

 @return a deviceData string that should be passed into server-side calls, such as `Transaction.sale`,
         for PayPal transactions. This JSON serialized string contains a PayPal fraud ID.
*/
+ (nonnull NSString *)collectPayPalDeviceData;

@end
