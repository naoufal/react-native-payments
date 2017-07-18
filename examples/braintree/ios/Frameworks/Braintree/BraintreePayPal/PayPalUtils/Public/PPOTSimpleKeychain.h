// adapted from https://raw.github.com/rackspace/rackspace-ios/master/Classes/Keychain.h

//
//  PPOTSimpleKeychain.h
//  OpenStack
//
//  Based on CardIOKeychain
//  Based on KeychainWrapper in BadassVNC by Dylan Barrie
//
//  Created by Mike Mayo on 10/1/10.
//  The OpenStack project is provided under the Apache 2.0 license.
//

#import <Foundation/Foundation.h>

/*!
 @brief Wrapper to help deal with Keychain-related things such as storing API keys and passwords.
 @discussion The key used in the methods may not be the actual key used in the keychain
*/
@interface PPOTSimpleKeychain : NSObject

/*!
 @brief Sets the given data for the given key

 @param data the data to set, null if any data associated with the key should be deleted
 @param key the key to use
 @return YES if successful, NO if not
*/
+ (BOOL)setData:(nullable NSData *)data forKey:(nonnull NSString *)key;

/*!
 @brief Retrieves the data associated with the given key

 @param key the key to use
 @return any data associated with the key
*/
+ (nullable NSData *)dataForKey:(nonnull NSString *)key;

/*!
 @brief Retrieves the unarchived object with the given key

 @param key the key to use
 @return the unarchived object associated with the given key
*/
+ (nullable id)unarchiveObjectWithDataForKey:(nonnull NSString *)key;

@end
