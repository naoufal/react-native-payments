#import "BTKeychain.h"
@import Security;

@implementation BTKeychain

+ (BOOL)setString:(NSString *)string forKey:(NSString *)key {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self setData:data forKey:key];
}

+ (NSString *)stringForKey:(NSString *)key {
    NSData *data = [self dataForKey:key];
    return data == nil ? nil : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)keychainKeyForKey:(NSString *)key {
    return [NSString stringWithFormat:@"com.braintreepayments.Braintree-API.%@", key];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key {
    if(!key) {
        return NO;
    }

    BOOL success = YES;

    key = [self keychainKeyForKey:key];

    // First check if it already exists, by creating a search dictionary and requesting that
    // nothing be returned, and performing the search anyway.
    NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];

    [existsQueryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    // Add the keys to the search dict
    [existsQueryDictionary setObject:@"Service" forKey:(__bridge id)kSecAttrService];
    [existsQueryDictionary setObject:key forKey:(__bridge id)kSecAttrAccount];

    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)existsQueryDictionary, NULL);
    if(res == errSecItemNotFound) {
        if(data) {
            NSMutableDictionary *addDict = existsQueryDictionary;
            [addDict setObject:data forKey:(__bridge id)kSecValueData];
            [addDict setObject:(__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];

            res = SecItemAdd((__bridge CFDictionaryRef)addDict, NULL);
            if (res != errSecSuccess) {
                success = NO;
            }
        }
    }
    else if(res == errSecSuccess) {
        if(data) {
            // Modify an existing one
            // Actually pull it now of the keychain at this point.
            NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:data forKey:(__bridge id)kSecValueData];

            res = SecItemUpdate((__bridge CFDictionaryRef)existsQueryDictionary, (__bridge CFDictionaryRef)attributeDict);
            if (res != errSecSuccess) {
                success = NO;
            }
        } else {
            SecItemDelete((__bridge CFDictionaryRef)existsQueryDictionary);
        }
    }
    else {
        success = NO;
    }

    return success;
}

+ (NSData *)dataForKey:(NSString *)key {

    key = [self keychainKeyForKey:key];

    NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];

    [existsQueryDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    // Add the keys to the search dict
    [existsQueryDictionary setObject:@"Service" forKey:(__bridge id)kSecAttrService];
    [existsQueryDictionary setObject:key forKey:(__bridge id)kSecAttrAccount];

    // We want the data back!
    [existsQueryDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

    CFTypeRef cfData = NULL;
    OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)existsQueryDictionary, &cfData);
    NSData *data = (id)CFBridgingRelease(cfData);
    if(res == errSecSuccess) {
        return data;
    }
    
    return nil;
}

@end
