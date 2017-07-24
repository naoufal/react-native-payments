//
//  PPOTAppSwitchUtil.m
//  PayPalOneTouch
//
//  Copyright © 2014 PayPal, Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "PPOTAppSwitchUtil.h"
#import "PPOTConfiguration.h"
#import "PPOTMacros.h"
#import "PPOTAnalyticsTracker.h"
#import "PPOTVersion.h"
#import "PPOTPersistentRequestData.h"
#import "PPOTString.h"
#import "PPOTJSONHelper.h"
#import "PPOTAnalyticsDefines.h"

#define STR_TO_URL_SCHEME(str) [NSURL URLWithString:[NSString stringWithFormat:@"%@://", str]]

@implementation PPOTAppSwitchUtil

+ (NSString *)bundleId {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)bundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

+ (BOOL)isCallbackURLSchemeValid:(NSString *)callbackURLScheme {
    NSString *bundleID = [[self bundleId] lowercaseString];

    // There are issues returning to the app if the return URL begins with a `-`
    // Allow callback URLs that remove the leading `-`
    // Ex: An app with Bundle ID `-com.example.myapp` can use the callback URL `com.example.myapp.payments`
    if (bundleID.length <= 1) {
        return NO;
    } else if ([[bundleID substringToIndex:1] isEqualToString:@"-"] && ![[callbackURLScheme lowercaseString] hasPrefix:bundleID]) {
        bundleID = [bundleID substringFromIndex:1];
    }
    
    if (bundleID && ![[callbackURLScheme lowercaseString] hasPrefix:bundleID]) {
        PPSDKLog(@"callback URL scheme must start with %@ ", bundleID);
        return NO;
    }

    // check the actual plist that the app is fully configured rather than just making canOpenURL call
    NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    for (NSDictionary *item in urlTypes) {
        NSArray *bundleURLSchemes = item[@"CFBundleURLSchemes"];
        if (NSNotFound != [bundleURLSchemes indexOfObject:callbackURLScheme]) {
            return YES;
        }
    }
    PPSDKLog(@"callback URL scheme %@ is not found in .plist", callbackURLScheme);
    return NO;
}

+ (NSString *)protocolFromTargetAppURLScheme:(NSString *)targetAppURLScheme {
    NSArray *components = [targetAppURLScheme componentsSeparatedByString:@"."];
    return components[[components count] - 1];
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];

    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if (elements.count > 1) {
            NSString *key = [[elements objectAtIndex:0] stringByRemovingPercentEncoding];
            NSString *val = [[elements objectAtIndex:1] stringByRemovingPercentEncoding];
            if (key.length && val.length) {
                dict[key] = val;
            }
        }
    }
    return dict;
}

+ (NSURL *)URLAction:(NSString *)action
  targetAppURLScheme:(NSString *)targetAppURLScheme
   callbackURLScheme:(NSString *)callbackURLScheme
             payload:(NSDictionary *)payload {
    NSString *successURL;
    NSString *cancelURL;
    [self redirectURLsForCallbackURLScheme:callbackURLScheme withReturnURL:&successURL withCancelURL:&cancelURL];

    NSString *encodedPayload = [PPOTString stringByURLEncodingAllCharactersInString:[PPOTJSONHelper base64EncodedJSONStringWithDictionary:payload]];
    NSString* urlString = [NSString stringWithFormat:@"%@://%@?%@=%@&%@=%@&%@=%@&%@=%@",
                           targetAppURLScheme, action, kPPOTAppSwitchPayloadKey, encodedPayload,
                           kPPOTAppSwitchXSourceKey, [self bundleId],
                           kPPOTAppSwitchXSuccessKey, successURL,
                           kPPOTAppSwitchXCancelKey, cancelURL];

    return [NSURL URLWithString:urlString];
}

+ (NSURL *)URLAction:(NSString *)action
   callbackURLScheme:(NSString *)callbackURLScheme
             payload:(NSDictionary *)payload {
    NSString *successURL;
    NSString *cancelURL;
    [self redirectURLsForCallbackURLScheme:callbackURLScheme withReturnURL:&successURL withCancelURL:&cancelURL];

    NSString *encodedPayload = [PPOTString stringByURLEncodingAllCharactersInString:[PPOTJSONHelper base64EncodedJSONStringWithDictionary:payload]];
    NSString* urlString = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@&%@=%@",
                           action, kPPOTAppSwitchPayloadKey, encodedPayload,
                           kPPOTAppSwitchXSourceKey, [self bundleId],
                           kPPOTAppSwitchXSuccessKey, successURL,
                           kPPOTAppSwitchXCancelKey, cancelURL];

    return [NSURL URLWithString:urlString];
}

#pragma mark - build or parse our redirect urls

+ (void)redirectURLsForCallbackURLScheme:(NSString *)callbackURLScheme withReturnURL:(NSString * __autoreleasing *)returnURL withCancelURL:(NSString * __autoreleasing *)cancelURL {
    PPAssert(returnURL, @"redirectURLsForCallbackURLScheme: returnURL is required");
    PPAssert(cancelURL, @"redirectURLsForCallbackURLScheme: cancelURL is required");

    *returnURL = nil;
    *cancelURL = nil;

    if ([PPOTAppSwitchUtil isCallbackURLSchemeValid:callbackURLScheme]) {
        NSString *hostAndPath = [self redirectURLHostAndPath];
        *returnURL = [NSString stringWithFormat:@"%@://%@%@", callbackURLScheme, hostAndPath, kPPOTAppSwitchSuccessAction];
        *cancelURL = [NSString stringWithFormat:@"%@://%@%@", callbackURLScheme, hostAndPath, kPPOTAppSwitchCancelAction];
    }
}

+ (BOOL)isValidURLAction:(NSURL *)urlAction {
    NSString *scheme = urlAction.scheme;
    if (!scheme.length) {
        return NO;
    }

    NSString *hostAndPath = [urlAction.host stringByAppendingString:urlAction.path];
    NSMutableArray *pathComponents = [[hostAndPath componentsSeparatedByString:@"/"] mutableCopy];
    [pathComponents removeLastObject]; // remove the action (`success`, `cancel`, etc)
    hostAndPath = [pathComponents componentsJoinedByString:@"/"];
    if ([hostAndPath length]) {
        hostAndPath = [hostAndPath stringByAppendingString:@"/"];
    }
    if (![hostAndPath isEqualToString:[self redirectURLHostAndPath]]) {
        return NO;
    }

    NSString *action = [self actionFromURLAction:urlAction];
    if (!action.length) {
        return NO;
    }

    NSArray *validActions = @[kPPOTAppSwitchSuccessAction, kPPOTAppSwitchCancelAction, kPPOTAppSwitchAuthenticateAction];
    if (![validActions containsObject:action]) {
        return NO;
    }

    NSString *query = [urlAction query];
    if (!query.length) {
        // should always have at least a payload or else a Hermes token
        return NO;
    }

    return YES;
}

+ (NSString *)actionFromURLAction:(NSURL *)urlAction {
    NSString *action = [urlAction.lastPathComponent componentsSeparatedByString:@"?"][0];
    if (![action length]) {
        action = urlAction.host;
    }
    return action;
}

+ (NSString *)redirectURLHostAndPath {
    // Return either an empty string;
    // or else a non-empty `host` or `host/path`, ending with `/`
    
    return @"onetouch/v1/";
}

@end
