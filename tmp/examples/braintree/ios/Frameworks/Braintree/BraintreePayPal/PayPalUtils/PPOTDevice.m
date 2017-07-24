//
//  PPOTDevice.m
//  Copyright © 2009 PayPal, Inc. All rights reserved.
//

#import "PPOTDevice.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/param.h>
#include <sys/mount.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>

#import "PPOTSimpleKeychain.h"
#import "PPOTString.h"

#define kKeychainDeviceIdentifier           @"PayPal_MPL_DeviceGUID"
#define kPPOTOTDeviceFallbackCountryISOCode     @"US"
#define kPPOTOTDeviceFallbackCountryDialingCode @"1"

@implementation PPOTDevice

+ (NSString *)hardwarePlatform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *)deviceName {
    NSString *model = [[UIDevice currentDevice] model];
    NSString *deviceName = [NSString stringWithFormat:@"%@ (%@)", model, [PPOTDevice hardwarePlatform]];
    return deviceName;
}


+ (NSString *)complicatedDeviceLocale {
    // Start with the device's current language:
    NSString *deviceLocale = [NSLocale preferredLanguages][0];

    // Treat dialect, if present, as region (except for Chinese, where it's a bit more than just a dialect):
    // For example, "en-GB" ("British English", as of iOS 7) -> "en_GB"; and "en-GB_HK" -> "en_GB".
    if (![deviceLocale hasPrefix:@"zh"]) {
        if ([deviceLocale rangeOfString:@"-"].location != NSNotFound) {
            NSUInteger underscoreLocation = [deviceLocale rangeOfString:@"_"].location;
            if (underscoreLocation != NSNotFound) {
                deviceLocale = [deviceLocale substringToIndex:underscoreLocation];
            }
            deviceLocale = [deviceLocale stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        }
    }

    // If no region is specified, then use the device's current locale (if the language matches):
    if ([deviceLocale rangeOfString:@"_"].location == NSNotFound) {
        NSString *deviceLanguage = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        NSString *deviceRegion = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        if (!deviceRegion) {
            // NSLocaleCountryCode can return nil if device's Region is set to English, Esperanto, etc.
            deviceRegion = @"";
        }
        NSString *calculatedDeviceLocale;
        if ([deviceRegion length]) {
            calculatedDeviceLocale = [NSString stringWithFormat:@"%@_%@", deviceLanguage, deviceRegion];
        } else {
            calculatedDeviceLocale = deviceLanguage;
        }

        if ([deviceLanguage hasPrefix:deviceLocale]) {
            deviceLocale = calculatedDeviceLocale;
        }
        else if ([deviceRegion length]) {
            // For language-matching here, treat missing device dialect as wildcard; e.g, "zh" matches either "zh-Hans" or "zh-Hant":
            NSUInteger targetHyphenLocation = [deviceLocale rangeOfString:@"-"].location;
            if (targetHyphenLocation != NSNotFound) {
                NSString *targetLanguage = [deviceLocale substringToIndex:targetHyphenLocation];
                if ([deviceLanguage hasPrefix:targetLanguage]) {
                    deviceLocale = [NSString stringWithFormat:@"%@_%@", deviceLocale, deviceRegion];
                } else if ([deviceLocale caseInsensitiveCompare:@"zh-Hant"] == NSOrderedSame &&
                           ([deviceRegion isEqualToString:@"HK"] || [deviceRegion isEqualToString:@"TW"])) {
                    // Very special case: target language is zh-Hant, and device region is either xx_HK or xx_TW,
                    // for *any* "xx" (because device region could be en_HK or en_TW):
                    deviceLocale = [NSString stringWithFormat:@"%@_%@", deviceLocale, deviceRegion];
                }
            }
        }
    }

    return deviceLocale;
}

+ (NSString *)appropriateIdentifier {
    // see if we already have one
    NSString *appropriateId = [[NSString alloc] initWithData:[PPOTSimpleKeychain dataForKey:kKeychainDeviceIdentifier]
                                                    encoding:NSUTF8StringEncoding];
    // if not generate a new one and save
    if (!appropriateId.length) {
        appropriateId = [[NSUUID UUID] UUIDString];
        [PPOTSimpleKeychain setData:[appropriateId dataUsingEncoding:NSUTF8StringEncoding] forKey:kKeychainDeviceIdentifier];
    }
    return appropriateId;
}

+ (void)clearIdentifier {
    [PPOTSimpleKeychain setData:nil forKey:kKeychainDeviceIdentifier];
}

@end
