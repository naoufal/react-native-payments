// adapted from https://raw.github.com/rackspace/rackspace-ios/master/Classes/Keychain.m

//
//  PPOTSimpleKeychain.m
//  OpenStack
//
//  Based on CardIOKeychain
//  Based on KeychainWrapper in BadassVNC by Dylan Barrie
//
//  Created by Mike Mayo on 10/1/10.
//  The OpenStack project is provided under the Apache 2.0 license.
//

#import "PPOTSimpleKeychain.h"
#import "PPOTMacros.h"
#import <Security/Security.h>
#import <TargetConditionals.h>

@implementation PPOTSimpleKeychain

+ (NSString *)keychainKeyForKey:(NSString *)key {
    // WARNING: don't change this line unless you know what you doing
    // If the app upgraded from mSDK (PayPal Touch) to OTC, we want to re-use app GUID;
    // therefore we are using the same keychain key.
    return [NSString stringWithFormat:CARDIO_STR(@"card.io - %@"), key];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key {
    if (!key) {
        return NO;
    }

    BOOL success = YES;

    key = [self keychainKeyForKey:key];

#if TARGET_IPHONE_SIMULATOR
    // since keychain sometimes is not available when running unit tests from the terminal
    // we decided to simply use user defaults
    [[NSUserDefaults standardUserDefaults] setValue:data ? data : [NSData data] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return success;
#else

    // First check if it already exists, by creating a search dictionary and requesting that
    // nothing be returned, and performing the search anyway.
    NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];

    [existsQueryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    // Add the keys to the search dict
    [existsQueryDictionary setObject:CARDIO_STR(@"service") forKey:(__bridge id)kSecAttrService];
    [existsQueryDictionary setObject:key forKey:(__bridge id)kSecAttrAccount];

    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)existsQueryDictionary, NULL);
    if (res == errSecItemNotFound) {
        if (data) {
            NSMutableDictionary *addDict = existsQueryDictionary;
            [addDict setObject:data forKey:(__bridge id)kSecValueData];
            [addDict setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];

            res = SecItemAdd((__bridge CFDictionaryRef)addDict, NULL);
            if (res != errSecSuccess) {
                success = NO;
            }
        }
    } else if (res == errSecSuccess) {
        if(data) {
            // Modify an existing one
            // Actually pull it now off the keychain at this point.
            NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:data forKey:(__bridge id)kSecValueData];

            res = SecItemUpdate((__bridge CFDictionaryRef)existsQueryDictionary, (__bridge CFDictionaryRef)attributeDict);
            if (res != errSecSuccess) {
                success = NO;
            }
        } else {
            SecItemDelete((__bridge CFDictionaryRef)existsQueryDictionary);
        }
    } else {
        success = NO;
    }

    return success;
#endif
}

+ (NSData *)dataForKey:(NSString *)key {

    key = [self keychainKeyForKey:key];

#if TARGET_IPHONE_SIMULATOR
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
#else

    NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];

    [existsQueryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    // Add the keys to the search dict
    [existsQueryDictionary setObject:CARDIO_STR(@"service") forKey:(__bridge id)kSecAttrService];
    [existsQueryDictionary setObject:key forKey:(__bridge id)kSecAttrAccount];

    // We want the data back!
    [existsQueryDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

    CFTypeRef cfData = NULL;
    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)existsQueryDictionary, &cfData);
    NSData *data = (id)CFBridgingRelease(cfData);
    if (res == errSecSuccess) {
        return data;
    }
    
    return nil;
#endif
}

+ (id)unarchiveObjectWithDataForKey:(NSString *)key {
    NSData *data = [PPOTSimpleKeychain dataForKey:key];
    if ([data length]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    else {
        return nil;
    }
}

@end
