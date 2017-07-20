//
//  PPOTString.m
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PPOTString : NSObject

/*!
 @brief URL encodes all characters in a given string including &, %, ?, =, and other URL "safe" characters

 @param aString the string to encode
 @return the encoded string
*/
+ (nonnull NSString *)stringByURLEncodingAllCharactersInString:(nonnull NSString *)aString;

/*!
 @brief Base64 encoded version of the data

 @param data Data to base64 encode
 @return the base64 encoded data as a string
*/
+ (nonnull NSString *)stringByBase64EncodingData:(nonnull NSData *)data;

/*!
 @brief Decoded a base64 string back into data

 @param strBase64 the string base64 encoded
 @return the decoded data
*/
+ (nullable NSData *)decodeBase64WithString:(nonnull NSString *)strBase64;

/*!
 @brief Generates a random identifier

 @return a uniquish identifier
*/
+ (nonnull NSString *)generateUniquishIdentifier;

/*!
 @brief Converts a NSData to a hexadecimal NSString

 @param data the data to convert
 @return a hexadecimal string from given byte data
*/
+ (nonnull NSString *)hexStringFromData:(nonnull NSData *)data;

/*!
 @brief Converts a hexadecimal string into a NSData representation

 @param hexString the string to convert
 @return the converted value representation of the hexadecimal string
*/
+ (nonnull NSData *)dataWithHexString:(nonnull NSString *)hexString;

@end
