//
//  PPOTRequest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTRequest_Internal.h"
#import "PPOTAnalyticsDefines.h"
#import "PPOTAppSwitchUtil.h"
#import "PPOTConfiguration.h"
#import "PPOTDevice.h"
#import "PPOTMacros.h"
#import "PPOTOAuth2SwitchRequest.h"
#import "PPOTAnalyticsTracker.h"
#import "PPOTPersistentRequestData.h"
#import "PPOTError.h"

#import <UIKit/UIKit.h>

NSString *const PayPalEnvironmentProduction = PPRequestEnvironmentProduction;
NSString *const PayPalEnvironmentSandbox = PPRequestEnvironmentSandbox;
NSString *const PayPalEnvironmentMock = PPRequestEnvironmentNoNetwork;

#define kPPOTAppSwitchSchemeToCheck      CARDIO_STR(@"http")

@implementation PPOTRequest

#pragma mark - initialization

+ (void)initialize {
    if (self == [PPOTRequest class]) {
        [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods
    }
}

- (instancetype)initWithClientID:(NSString *)clientID
                     environment:(NSString *)environment
               callbackURLScheme:(NSString *)callbackURLScheme {
    if (!clientID.length) {
        PPSDKLog(@"clientID is required.");
        return nil;
    }

    if (!environment.length) {
        PPSDKLog(@"environment is required.");
        return nil;
    }

    if (![PPOTAppSwitchUtil isCallbackURLSchemeValid:callbackURLScheme]) {
        PPSDKLog(@"callbackURLScheme is not configured or nil.");
        return nil;
    }

    self = [super init];
    if (self) {
        _clientID = clientID;
        _environment = environment;
        _callbackURLScheme = callbackURLScheme;

        [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods
    }

    return self;

}

#pragma mark - public methods

- (void)getTargetApp:(PPOTRequestPreflightCompletionBlock)completionBlock {
    PPAssert(completionBlock, @"getTargetApp: completionBlock is required");

    [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods

    [self determineConfigurationRecipe:^{
        NSString *analyticsPage = nil;
        switch (self.configurationRecipe.target) {
            case PPOTRequestTargetBrowser:
                analyticsPage = kAnalyticsAppSwitchPreflightBrowser;
                break;
            case PPOTRequestTargetOnDeviceApplication:
                analyticsPage = kAnalyticsAppSwitchPreflightWallet;
                break;
            case PPOTRequestTargetNone:
            default:
                analyticsPage = kAnalyticsAppSwitchPreflightNone;
                break;
        }

        NSString *protocol = [NSString stringWithFormat:@"v%ld", self.configurationRecipe.protocolVersion.longValue];
        analyticsPage = [analyticsPage stringByAppendingString:protocol];

        [[PPOTAnalyticsTracker sharedManager] trackPage:analyticsPage
                                            environment:self.environment
                                               clientID:self.clientID
                                                  error:nil
                                            hermesToken:nil];

        completionBlock(self.configurationRecipe.target);
    }];
}

- (void)performWithAdapterBlock:(PPOTRequestAdapterBlock)adapterBlock {
    PPAssert(adapterBlock, @"performWithAdapterBlock: adapterBlock is required");

    [PPOTConfiguration updateCacheAsNecessary]; // called by all public methods

    [self determineConfigurationRecipe:^{
        BOOL success = YES;
        PPOTRequestTarget target = PPOTRequestTargetNone;
        NSError *error = nil;
        NSString *requestClientMetadataId = nil;
        NSURL *appSwitchURL = nil;
        if (self.configurationRecipe) {
            PPOTSwitchRequest *appSwitchRequest = [self getAppSwitchRequestForConfigurationRecipe:self.configurationRecipe];
            if (appSwitchRequest) {
                appSwitchURL = [appSwitchRequest encodedURL];
                requestClientMetadataId = appSwitchRequest.clientMetadataID;
                PPLog(@"URL to open %@", appSwitchURL);

                NSString *analyticsPage = nil;
                if ([[appSwitchURL.absoluteString lowercaseString] hasPrefix:kPPOTAppSwitchSchemeToCheck]) {
                    target = PPOTRequestTargetBrowser;
                    analyticsPage = kAnalyticsAppSwitchToBrowser;
                }
                else {
                    target = PPOTRequestTargetOnDeviceApplication;
                    analyticsPage = kAnalyticsAppSwitchToWallet;
                }

                NSString *protocol = [NSString stringWithFormat:@"v%ld", self.configurationRecipe.protocolVersion.longValue];
                analyticsPage = [analyticsPage stringByAppendingString:protocol];

                [PPOTPersistentRequestData storeWithConfigurationRecipe:self.configurationRecipe withRequest:appSwitchRequest];


                NSString *hermesToken = nil;
                if ([self respondsToSelector:@selector(approvalURL)]) {
                    NSDictionary *queryDictionary = [PPOTAppSwitchUtil parseQueryString:[[self performSelector:@selector(approvalURL)] query]];
                    hermesToken = queryDictionary[kPPOTAppSwitchHermesTokenKey];
                }

                [[PPOTAnalyticsTracker sharedManager] trackPage:analyticsPage
                                                    environment:self.environment
                                                       clientID:self.clientID
                                                          error:error
                                                    hermesToken:hermesToken];
            } else {
                success = NO;
                error = [PPOTError errorWithErrorCode:PPOTErrorCodeNoTargetAppFound];
            }
        } else {
            PPSDKLog(@"No appropriate configuration recipe found");
            success = NO;
            error = [PPOTError errorWithErrorCode:PPOTErrorCodeNoTargetAppFound];
        }
        adapterBlock(success, appSwitchURL, target, requestClientMetadataId, error);
    }];
}

#pragma mark - add subclass-specific info to appSwitchRequest

- (PPOTSwitchRequest *)getAppSwitchRequestForConfigurationRecipe:(__attribute__((unused)) PPOTConfigurationRecipe *)configurationRecipe {
    PPAssert(NO, @"getAppSwitchRequestForConfigurationRecipe: subclass of PPOTRequest must override");
    return nil;
}

#pragma mark - configuration methods

- (void)determineConfigurationRecipe:(void (^)())completionBlock {
    PPAssert(completionBlock, @"establishConfigurationRecipe: completionBlock is required");

    if (self.configurationRecipe) {
        completionBlock();
        return;
    }

#if DEBUG
    [PPOTConfiguration useHardcodedConfiguration:self.useHardcodedConfiguration];
#endif

    [self getAppropriateConfigurationRecipe:^(PPOTConfigurationRecipe *configurationRecipe) {
        self.configurationRecipe = configurationRecipe;
        completionBlock();
    }];
}

- (void)getAppropriateConfigurationRecipe:(__attribute__((unused)) void (^)(PPOTConfigurationRecipe *configurationRecipe))completionBlock {
    PPAssert(NO, @"subclass must override");
}

- (BOOL)isConfigurationRecipeTargetSupported:(PPOTConfigurationRecipe *)configurationRecipe {
    // Confirm that the recipe's target is available (Browser is always installed; Wallet may or may not be installed),
    // and also that the recipe's target is not rejected by `self.forcedTarget`.

    switch (configurationRecipe.target) {
        case PPOTRequestTargetOnDeviceApplication: {
            return NO;
        }
        case PPOTRequestTargetBrowser: {
            if (self.forcedTarget.integerValue == PPOTRequestTargetOnDeviceApplication) {
                return NO;
            }
            return YES;
        }
        default: {
            return NO;
        }
    }
}

- (BOOL)isConfigurationRecipeLocaleSupported:(PPOTConfigurationRecipe *)configurationRecipe {
    if (![configurationRecipe.supportedLocales count]) {
        return YES;
    }

    return [configurationRecipe.supportedLocales containsObject:[[PPOTDevice complicatedDeviceLocale] uppercaseString]];
}

#pragma mark - utility method

#define kPPOTAppSwitchHermesTokenKey                   @"token"
#define kPPOTAppSwitchBillingAgreementTokenKey         @"ba_token"

+ (NSString *)tokenFromApprovalURL:(NSURL *)approvalURL {
    NSDictionary *queryDictionary = [PPOTRequest parseQueryString:[approvalURL query]];
    return queryDictionary[kPPOTAppSwitchHermesTokenKey] ?: queryDictionary[kPPOTAppSwitchBillingAgreementTokenKey];
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

@end
