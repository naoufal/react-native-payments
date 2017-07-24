//
//  PPOTEncryptionHelper.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPOTEncryptionHelper : NSObject

/*!
 @brief Generates a random 256-bit key to encrypt data with

 @return a 256-bit encryption key
*/
+ (nonnull NSData *)generate256BitKey;

/*!
 @brief Encrypt the data using the encryption key.

 @param plainData the data to encrypt
 @param key the encryption key to use
 @return the encrypted data
*/
+ (nullable NSData *)encryptAESCTRData:(nonnull NSData *)plainData encryptionKey:(nonnull NSData *)key;

/*!
 @brief Decrypt the data using the encryption key.

 @param cipherData the encrypted data
 @param key the encryption key used
 @return the decrypted data
*/
+ (nullable NSData *)decryptAESCTRData:(nonnull NSData *)cipherData encryptionKey:(nonnull NSData *)key;

/*!
 @brief Encrypts data using the given certificate

 @param plainData the data to encrypt
 @param certificate the certificate to use
 @return the encrypted data
*/
+ (nullable NSData *)encryptRSAData:(nonnull NSData *)plainData certificate:(nonnull NSData *)certificate;

@end
