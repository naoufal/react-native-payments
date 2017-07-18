//
//  PPOTJSONHelper.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPOTJSONHelper : NSObject

+ (nullable NSString *)stringFromDictionary:(nonnull NSDictionary *)dictionary withKey:(nonnull NSString *)key;
+ (nullable NSDictionary *)dictionaryFromDictionary:(nonnull NSDictionary *)dictionary withKey:(nonnull NSString *)key;

+ (nullable NSArray *)arrayFromDictionary:(nonnull NSDictionary *)dictionary withKey:(nonnull NSString *)key;
+ (nullable  NSArray *)stringArrayFromDictionary:(nonnull NSDictionary *)dictionary withKey:(nonnull NSString *)key;
+ (nullable NSArray *)dictionaryArrayFromDictionary:(nonnull NSDictionary *)dictionary withKey:(nonnull NSString *)key;

+ (nullable NSString *)base64EncodedJSONStringWithDictionary:(nonnull NSDictionary *)dictionary;
+ (nullable NSDictionary *)dictionaryWithBase64EncodedJSONString:(nonnull NSString *)base64String;

+ (nullable NSNumber *)numberFromDictionary:(nonnull NSDictionary *)dictionary withKey:(nonnull NSString *)key;

@end
