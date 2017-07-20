//
//  PPDataCollector.h
//  PayPalDataCollector
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPDataCollector.h"

@interface PPDataCollector ()

/*!
 @brief Generates a client metadata ID using an optional pairing ID.

 @note This is an internal method for generating raw client metadata IDs, which is not
 the correct format for device data when creating a transaction.

 @param pairingID a pairing ID to associate with this clientMetadataID must be 10-32 chars long or null
 @return a client metadata ID to send as a header
*/
+ (nonnull NSString *)generateClientMetadataID:(nullable NSString *)pairingID;

/*!
 @brief Generates a client metadata ID.

 @note This is an internal method for generating raw client metadata IDs, which is not
 the correct format for device data when creating a transaction.

 @return a client metadata ID to send as a header
*/
+ (nonnull NSString *)generateClientMetadataID;

@end
