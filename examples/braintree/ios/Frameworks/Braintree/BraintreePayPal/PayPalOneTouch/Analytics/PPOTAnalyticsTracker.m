//
//  PPOTAnalyticsTracker.m
//  PayPalOneTouch
//
//  Copyright © 2014 PayPal, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPOTAnalyticsTracker.h"

#import "PPOTCore_Internal.h"
#import "PPOTVersion.h"
#import "PPOTDevice.h"
#import "PPOTMacros.h"
#import "PPOTSimpleKeychain.h"
#import "PPOTString.h"
#import "PPOTURLSession.h"
#import "PPFPTIData.h"
#import "PPFPTITracker.h"
#import "PPOTAnalyticsDefines.h"
#if __has_include("BraintreeCore.h")
#import "BTLogger_Internal.h"
#else
#import <BraintreeCore/BTLogger_Internal.h>
#endif

#define kTimeForSession           (30 * 60) // How long should an Omniture session last.
#define kKeychainIdentifierForUDID @"PayPal_OTC_Analytics_UDID"

#define kFPTIVersKey             @"vers"
#define kFPTIPageKey             @"page"
#define kFPTILginKey             @"lgin"
#define kFPTIRstaKey             @"rsta"
#define kFPTIMosvKey             @"mosv"
#define kFPTIMdvsKey             @"mdvs"
#define kFPTIMapvKey             @"mapv"
#define kFPTIEccdKey             @"eccd"
#define kFPTIErpgKey             @"erpg"
#define kFPTIFltkKey             @"fltk"
#define kFPTITxntKey             @"txnt"
#define kFPTIApinKey             @"apin"
#define kFPTIBchnKey             @"bchn"
#define kFPTISrceKey             @"srce"
#define kFPTIBzsrKey             @"bzsr"
#define kFPTIPgrpKey             @"pgrp"
#define kFPTIVidKey              @"vid"
#define kFPTIDsidKey             @"dsid"
#define kFPTIClidKey             @"clid"


@interface PPOTAnalyticsTracker () <PPFPTINetworkAdapterDelegate>

@property (nonatomic, copy, readwrite) NSString *deviceUDID;
@property (nonatomic, copy, readwrite) NSDictionary *trackerParams;

@property (nonatomic, assign, readwrite) BOOL sessionImpressionSent;
@property (nonatomic, copy, readwrite) NSString *sessionID;
@property (nonatomic, copy, readwrite) NSDate *lastImpressionDate;

@property (nonatomic, strong, readwrite) NSMutableArray *apiEndpoints;
@property (nonatomic, strong, readwrite) NSMutableArray *apiRoundtripTimes;

@property (nonatomic, strong, readwrite) PPFPTITracker *fptiTracker;

@property (nonatomic, strong, readwrite) PPOTURLSession *urlSession;

@end

@implementation PPOTAnalyticsTracker

+ (nonnull PPOTAnalyticsTracker *)sharedManager {
    static PPOTAnalyticsTracker* sharedManager = nil;

    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedManager = [[PPOTAnalyticsTracker alloc] init];

        sharedManager.deviceUDID = [[NSString alloc] initWithData:[PPOTSimpleKeychain dataForKey:kKeychainIdentifierForUDID]
                                                         encoding:NSUTF8StringEncoding];
        if ([sharedManager.deviceUDID length] == 0) {
            sharedManager.deviceUDID = [PPOTString generateUniquishIdentifier];
            [PPOTSimpleKeychain setData:[sharedManager.deviceUDID dataUsingEncoding:NSUTF8StringEncoding]
                                 forKey:kKeychainIdentifierForUDID];
        }

        // trackingVars are the standard params to add to every request
        NSMutableDictionary *trackingVars = [[NSMutableDictionary alloc] init];
        trackingVars[kFPTIMapvKey] = PayPalOTVersion(); // "App" Version number
        trackingVars[kFPTIRstaKey] = [[self class] deviceLocale]; // Locale (consumer app bases this on payerCountry)
        trackingVars[kFPTIMosvKey] = [NSString stringWithFormat:@"iOS %@", [UIDevice currentDevice].systemVersion]; // Mobile OS + version
        trackingVars[kFPTIMdvsKey] = [PPOTDevice deviceName]; // Mobile Device Name, i.e. iPhone 4S

        sharedManager.trackerParams = trackingVars;

        // Initialize FPTI:
        sharedManager.fptiTracker = [[PPFPTITracker alloc] initWithDeviceUDID:sharedManager.deviceUDID
                                                                    sessionID:sharedManager.sessionID
                                                       networkAdapterDelegate:sharedManager];
    });

    return sharedManager;
}

- (nonnull instancetype)init {
    if (self = [super init]) {
        _apiRoundtripTimes = [NSMutableArray arrayWithCapacity:4];
        _apiEndpoints = [NSMutableArray arrayWithCapacity:4];
        _sessionImpressionSent = NO;
    }
    return self;
}

- (void)dealloc {
    [_urlSession finishTasksAndInvalidate];
}

#pragma mark - Smart getter for sessionID

- (nonnull NSString *)sessionID {
    // For Omniture, the session should last 30 minutes
    if (_lastImpressionDate != nil && [[NSDate date] timeIntervalSinceDate:_lastImpressionDate] >= kTimeForSession) {
        _sessionID = nil;
        self.sessionImpressionSent = NO;
    }

    if (_sessionID == nil) {
        _sessionID = [PPOTAnalyticsTracker newOmnitureSessionID];
    }

    return _sessionID;
}

/**
 Generates a session ID

 @return a session ID
 */
+ (nonnull NSString *)newOmnitureSessionID {
    // The javascript is sed=Math&&Math.random?Math.floor(Math.random()*10000000000000):tm.getTime(),sess='s'+Math.floor(tm.getTime()/10800000)%10+sed
    // JavaScript Math.random gives a value between 0 and 1
    srandom((unsigned)[[NSDate date] timeIntervalSince1970]); // Seed the random number generator
    NSUInteger rnumber = (NSUInteger) (10000000000000 * ((float) random() / (float) RAND_MAX));

    // Javascript getTime is # of milliseconds from 1/1/1970
    return [NSString stringWithFormat:@"%lu", (unsigned long)(rnumber + (NSUInteger)floor((([NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970) / (float) 10800)) % 10)];
}

#pragma mark -

- (void)trackPage:(nonnull NSString *)pagename
      environment:(nonnull NSString *)environment
         clientID:(nullable NSString *)clientID
            error:(nullable NSError *)error
      hermesToken:(nullable NSString *)hermesToken {
    // Use PPAsserts to catch bad parameters in Debug version:
    PPAssert([pagename length], @"pagename must be non-empty");
    PPAssert(environment, @"environment can't be nil (can be empty string, though)");
    PPAssert(clientID, @"clientID can't be nil (can be empty string, though)");

    // Sanity-check parameters to prevent crashes in Release version:
    if (![pagename length]) {
        return;
    }
    if (!environment) {
        environment = @"";
    }
    if (!clientID) {
        clientID = @"";
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    NSString *version = [kAnalyticsVersion stringByReplacingOccurrencesOfString:@"MODE" withString:environment];
    NSString *nameStr = [NSString stringWithFormat:@"%@:%@", pagename, version];
    if (error != nil) {
        nameStr = [nameStr stringByAppendingString:@"|error"];
    }

    params[kFPTIVersKey] = version;
    params[kFPTIPageKey] = nameStr;
    params[kFPTILginKey] = @"out";
    params[kFPTIPgrpKey] = (error == nil) ? pagename : [pagename stringByAppendingString:@"|error"];
    params[kFPTIBchnKey] = @"otc";
    params[kFPTISrceKey] = @"otc";
    params[kFPTIBzsrKey] = @"mobile";
    params[kFPTIVidKey] = self.sessionID;
    params[kFPTIDsidKey] = self.deviceUDID;
    params[kFPTIClidKey] = clientID;
    params[@"e"] = @"im";
    params[@"apid"] = [self appBundleInformation];

    if ([hermesToken length]) {
        params[kFPTIFltkKey] = hermesToken;
    }

    [self addTrackerParamsTo:params];
    [self addAPIEndpointParamsTo:params];
    [self addErrorParamsTo:params withError:error];

    // Send to FPTI. In this case, the FPTITracker prepares/formats the data which then is sent back to this instance's
    // PPFPTINetworkAdapterDelegate method.
    [self.fptiTracker submitEventWithParams:params];
}

#pragma mark - Helper methods for tracker data

/**
 Adds tracker level parameters to the params request. Tracker level params are constant parameters (say a device name)
 which do not need to be re-calculated.

 @param params dictionary to add data to
 */
- (void)addTrackerParamsTo:(nonnull NSMutableDictionary *)params {
    // If there is a standard set of properties/parameters to send on each call, add it now.
    if (self.trackerParams != nil && [self.trackerParams count]) {
        if (_sessionImpressionSent) {
            // Always send the rsta value
            params[@"rsta"] = self.trackerParams[@"rsta"];
        }
        else {
            [params addEntriesFromDictionary:self.trackerParams];
        }
    }
}

/**
 Return the bundle information for analytics

 @return bundle information as a string
 */
- (nonnull NSString *)appBundleInformation {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",
            infoDictionary[@"CFBundleExecutable"],
            infoDictionary[@"CFBundleIdentifier"],
            infoDictionary[@"CFBundleName"],
            infoDictionary[@"CFBundleShortVersionString"],
            infoDictionary[@"CFBundleVersion"],
            infoDictionary[@"CFBundleDisplayName"]];
}

/**
 Adds the API endpoint params

 @param params dictionary to add data to
 */
- (void)addAPIEndpointParamsTo:(nonnull NSMutableDictionary *)params {
    if ([self.apiRoundtripTimes count]) {
        NSMutableString *timesString = [NSMutableString string];
        NSMutableString *endpointsString = [NSMutableString string];

        for (NSUInteger index = 0; index < [self.apiRoundtripTimes count]; index++) {
            if ([timesString length]) {
                [timesString appendString:@"|"];
                [endpointsString appendString:@"|"];
            }
            [timesString appendFormat:@"%ld", (long)[self.apiRoundtripTimes[index] integerValue]];
            [endpointsString appendString:self.apiEndpoints[index]];
        }

        params[kFPTITxntKey] = timesString;
        params[kFPTIApinKey] = endpointsString;

        [self.apiRoundtripTimes removeAllObjects];
        [self.apiEndpoints removeAllObjects];
    }
}

/**
 Adds the error param information (if there is an error

 @param params dictionary to add data to
 @param error the error
 */
- (void)addErrorParamsTo:(nonnull NSMutableDictionary *)params withError:(nullable NSError *)error {
    if (error != nil) {
        if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
            // if Canceled, don't report as an error
        }
        else {
            params[kFPTIEccdKey] = [NSString stringWithFormat:@"%ld", (long)error.code];
            params[kFPTIErpgKey] = ([error.localizedDescription length] > 0) ? error.localizedDescription : @"Unknown error";
        }
    }
}


#pragma mark - PPFPTINetworkAdapterDelegate

- (void)sendRequestWithData:(nonnull __attribute__((unused)) PPFPTIData*)fptiData {
    NSDictionary *fptiDataDictionary = [fptiData dataAsDictionary];
    NSDictionary *params = fptiDataDictionary[@"events"][@"event_params"];
    NSString *nameStr = params[@"page"];

    NSArray *pageComponents = [nameStr componentsSeparatedByString:@":"];
    NSString *environment = pageComponents[[pageComponents count] - 2];

    if ([environment isEqualToString:@"mock"]) {
        return;
    }

    NSURL* url = [fptiData trackerURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPShouldUsePipelining = YES;
    [request setHTTPMethod:@"POST"];
    [request setValue:[fptiData userAgent] forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSError *error;
    NSData *fptiJSONData = [NSJSONSerialization dataWithJSONObject:fptiDataDictionary options:0 error:&error];
    if (fptiJSONData == nil && error != NULL) {
        // ignore the error
    } else {
        [request setHTTPBody:fptiJSONData];
        [self.urlSession sendRequest:request completionBlock:nil];
    }
}

#pragma mark -

+ (NSString *)deviceLocale {
    // unlike NSLocaleIdentifier, this will always be either just language (@"en") or else language_COUNTRY (@"en_US")
    NSString *language = [[self class] deviceLanguage];
    NSString *country = [[self class] deviceCountryCode];
    if ([country length]) {
        return [NSString stringWithFormat:@"%@_%@", language, country];
    }
    else {
        return language;
    }
}

+ (NSString *)deviceLanguage {
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

+ (NSString *)deviceCountryCode {
    //gives the country code from the device
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    if (!countryCode) {
        // NSLocaleCountryCode can return nil if device's Region is set to English, Esperanto, etc.
        countryCode = @"";
    }
    return countryCode;
}

@end
