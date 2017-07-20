//
//  PPOTCore.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTCore.h"
#import "PPOTCore_Internal.h"
#import "PPOTResult_Internal.h"
#import "PPOTRequest_Internal.h"
#import "PPOTConfiguration.h"
#import "PPOTDevice.h"
#import "PPOTMacros.h"
#import "PPOTPersistentRequestData.h"
#import "PPDataCollector.h"
#import "PPOTVersion.h"

// PayPalTouch v1 version
#import "PPOTAppSwitchUtil.h"

#define kPPOTSafariViewService            CARDIO_STR(@"com.apple.safariviewservice")
#define kPPOTSafariSourceApplication      CARDIO_STR(@"com.apple.mobilesafari")

@implementation PPOTCore

+ (void)initialize {
    if (self == [PPOTCore class]) {
        [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods
    }
}

+ (BOOL)doesApplicationSupportOneTouchCallbackURLScheme:(NSString *)callbackURLScheme {
    [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods

    BOOL doesSupport = NO;
    // checks the callbackURLScheme is present and app responds to it.
    doesSupport = [PPOTAppSwitchUtil isCallbackURLSchemeValid:callbackURLScheme];
    return doesSupport;
}

+ (BOOL)isWalletAppInstalled {
    [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods

    return NO;
}

+ (BOOL)canParseURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods

    BOOL canHandle = NO;
    canHandle = ([PPOTCore isSourceApplicationValid:sourceApplication]
                 && [PPOTCore isValidURLAction:url]);
    return canHandle;
}

+ (void)parseResponseURL:(NSURL *)url completionBlock:(PPOTCompletionBlock)completionBlock {
    [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods

    PPAssert(completionBlock, @"parseOneTouchResponseURL:completionBlock: completionBlock is required");

    [PPOTResult parseURL:url completionBlock:completionBlock];
}

+ (void)redirectURLsForCallbackURLScheme:(NSString *)callbackURLScheme withReturnURL:(NSString * __autoreleasing *)returnURL withCancelURL:(NSString * __autoreleasing *)cancelURL {
    [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods

    [PPOTAppSwitchUtil redirectURLsForCallbackURLScheme:callbackURLScheme withReturnURL:returnURL withCancelURL:cancelURL];
}

+ (BOOL)isSourceApplicationValid:(NSString *)sourceApplication {
    if (!sourceApplication.length) {
        return NO;
    }

    PPOTPersistentRequestData *persistentRequestData = [PPOTPersistentRequestData fetch];
    PPOTConfigurationRecipe *configurationRecipe = persistentRequestData.configurationRecipe;
    if (!configurationRecipe) {
        return NO;
    }

    sourceApplication = [sourceApplication lowercaseString];

    for (NSString *bundleID in configurationRecipe.targetAppBundleIDs) {
        NSUInteger asteriskLocation = [bundleID rangeOfString:@"*"].location;
        NSString *bundleIDMask = asteriskLocation == NSNotFound ? bundleID : [bundleID substringToIndex:asteriskLocation];
        if ([sourceApplication hasPrefix:bundleIDMask]) {
            return YES;
        }
    }

    if ([sourceApplication isEqualToString:kPPOTSafariSourceApplication] || [sourceApplication isEqualToString:kPPOTSafariViewService] ) {
        return YES;
    }

    return NO;
}

+ (BOOL)isValidURLAction:(NSURL *)urlAction {
    if (![PPOTAppSwitchUtil isValidURLAction:urlAction]) {
        return NO;
    }

    PPOTPersistentRequestData *persistentRequestData = [PPOTPersistentRequestData fetch];
    PPOTConfigurationRecipe *configurationRecipe = persistentRequestData.configurationRecipe;
    NSDictionary *queryDictionary = [PPOTAppSwitchUtil parseQueryString:[urlAction query]];

    if (!persistentRequestData || !configurationRecipe || !queryDictionary) {
        return NO;
    }

    if ([configurationRecipe.protocolVersion integerValue] == 0) {
        NSString *requestHermesToken = persistentRequestData.requestData[kPPOTRequestDataDataDictionaryHermesTokenKey];
//        NSString *responseHermesToken = queryDictionary[kPPOTAppSwitchHermesBATokenKey];
//        if (responseHermesToken == nil) {
//            responseHermesToken = queryDictionary[kPPOTAppSwitchHermesTokenKey];
//        }
        if (![requestHermesToken length]) {
            return NO;
        }
    } else {
        if (![queryDictionary[kPPOTAppSwitchPayloadKey] length]) {
            return NO;
        }

        // For now, we only check the value of x-source in the case of Wallet-switch.
        // Ultimately, we might want to agree on what x-source should be for a browser-switch (Hermes).
        if (configurationRecipe.target == PPOTRequestTargetOnDeviceApplication &&
            ![self isSourceApplicationValid:queryDictionary[kPPOTAppSwitchXSourceKey]]) {
            return NO;
        }
    }

    return YES;
}

+ (NSString *)libraryVersion {
    [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods

    return PayPalOTVersion();
}

@end
