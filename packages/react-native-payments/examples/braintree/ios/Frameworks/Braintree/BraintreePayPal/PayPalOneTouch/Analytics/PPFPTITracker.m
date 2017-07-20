//
//  PPFPTITracker.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPFPTITracker.h"

#import "PPFPTIData.h"
#import "PPOTDevice.h"
#import "PPOTVersion.h"

static NSString* const kTrackerURLAsNSString = @"https://api-m.paypal.com/v1/tracking/events";

@interface PPFPTITracker ()

@property (nonatomic, copy, readwrite) NSString *deviceUDID;
@property (nonatomic, copy, readwrite) NSString *sessionID;
@property (nonatomic, copy, readwrite) NSURL *trackerURL;

@property (nonatomic, copy, readwrite) NSString *userAgent;

@end

@implementation PPFPTITracker

- (instancetype)initWithDeviceUDID:(NSString *)deviceUDID
                         sessionID:(NSString *)sessionID
            networkAdapterDelegate:(id<PPFPTINetworkAdapterDelegate>)networkAdapterDelegate {
    if (self = [super init]) {
        self.deviceUDID = deviceUDID;
        self.sessionID = sessionID;
        self.trackerURL = [NSURL URLWithString:kTrackerURLAsNSString];
        self.userAgent = [self computeUserAgent];
        self.networkAdapterDelegate = networkAdapterDelegate;
    }
    return self;
}

- (void)submitEventWithParams:(NSDictionary *)params {
    PPFPTIData *data = [[PPFPTIData alloc] initWithParams:params
                                                 deviceID:self.deviceUDID
                                                sessionID:self.sessionID
                                                userAgent:self.userAgent
                                               trackerURL:self.trackerURL];
    if (self.networkAdapterDelegate) {
        [self.networkAdapterDelegate sendRequestWithData:data];
    }
}

- (NSString *)computeUserAgent {
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *language = [currentLocale objectForKey:NSLocaleLanguageCode];

#ifdef DEBUG
    NSString *releaseMode = @"DEBUG";
#else
    NSString *releaseMode = @"RELEASE";
#endif

    // PayPalSDK/OneTouchCore-iOS 3.2.2-11-g8b1c0e3 (iPhone; CPU iPhone OS 8_4_1; en-US; iPhone (iPhone5,1); iPhone5,1; DEBUG)
    return [NSString stringWithFormat:@"PayPalSDK/OneTouchCore-iOS %@ (%@; CPU %@ %@; %@-%@; %@; %@; %@)",
            PayPalOTVersion(),
            [UIDevice currentDevice].model,
            [UIDevice currentDevice].systemName,
            [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"],
            language,
            countryCode,
            [PPOTDevice deviceName],
            [PPOTDevice hardwarePlatform],
            releaseMode
            ];
}

@end
