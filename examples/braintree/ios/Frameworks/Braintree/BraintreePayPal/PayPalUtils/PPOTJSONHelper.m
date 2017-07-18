//
//  PPOTJSONHelper.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTJSONHelper.h"
#import "PPOTString.h"

@implementation PPOTJSONHelper

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSString *string = nil;
    if ([dictionary[key] isKindOfClass:[NSString class]]) {
        string = dictionary[key];
    }
    return string;
}

+ (NSDictionary *)dictionaryFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSDictionary *dict = nil;
    if ([dictionary[key] isKindOfClass:[NSDictionary class]]) {
        dict = dictionary[key];
    }
    return dict;
}

+ (NSArray *)arrayFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSArray *array = nil;
    if ([dictionary[key] isKindOfClass:[NSArray class]]) {
        array = dictionary[key];
    }
    return array;
}

+ (NSArray *)stringArrayFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSArray *array = [PPOTJSONHelper arrayFromDictionary:dictionary withKey:key];
    for (id item in array) {
        if (![item isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    return array;
}

+ (NSArray *)dictionaryArrayFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSArray *array = [PPOTJSONHelper arrayFromDictionary:dictionary withKey:key];
    for (id item in array) {
        if (![item isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
    }
    return array;
}

+ (NSString *)base64EncodedJSONStringWithDictionary:(NSDictionary*)dictionary {
    NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    if ([json length]) {
        return [PPOTString stringByBase64EncodingData:json];
    }
    else {
        return @"";
    }
}
+ (NSDictionary *)dictionaryWithBase64EncodedJSONString:(NSString*)base64String {
    NSData *data = [PPOTString decodeBase64WithString:base64String];
    if ([data length]) {
        return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    else {
        return @{};
    }
}

+ (NSNumber *)numberFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key {
    NSNumber *number = nil;
    if ([dictionary[key] isKindOfClass:[NSNumber class]]) {
        number = dictionary[key];
    } else {
        NSString *stringNumber = [self stringFromDictionary:dictionary withKey:key];
        if (stringNumber.length) {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            number = [formatter numberFromString:stringNumber];
        }
    }
    return number;
}

@end
