//
//  PPFPTIData.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPFPTIData.h"

@interface PPFPTIData ()

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy) NSString *deviceID;
@property (nonatomic, copy) NSString *sessionID;
@property (nonatomic, copy) NSString *userAgent;
@property (nonatomic, copy) NSURL *trackerURL;

@end

@implementation PPFPTIData

- (instancetype)initWithParams:(NSDictionary *)params
                      deviceID:(NSString *)deviceID
                     sessionID:(NSString *)sessionID
                     userAgent:(NSString *)userAgent
                    trackerURL:(NSURL *)trackerURL {
    self = [super init];
    if (self) {
        self.params = [params mutableCopy];
        self.deviceID = deviceID;
        self.sessionID = sessionID;
        self.userAgent = userAgent;
        self.trackerURL = trackerURL;
    }
    return self;
}

/*
 Sample request
 {
    "events": {
        "actor": {
            "tracking_visitor_id":"912bddaa1390abe0eed4d1b541ff46e198",
            "tracking_visit_id":"982bddcd1390abe0d4d1b541ff46e12198"
        },
        "channel":"mobile",
        "tracking_event":"1363303116",
        "event_params": {
            "sv":"mobile",
            "expn":"channel",
            "t":"1161775163140",
            "g":"-420",
            "page":"main"
        }
    }
 }
 */
- (NSDictionary *)dataAsDictionary {
    NSTimeInterval impressionTimeInterval = [[NSDate date] timeIntervalSince1970];

    // Note: If this method is called multiple times, the time may be different
    NSString *trackingEventString = [PPFPTIData clientTimestampSinceEpochInMilliseconds:impressionTimeInterval];

    self.params[@"g"] = [PPFPTIData gmtOffsetInMinutes];
    self.params[@"t"] = [PPFPTIData clientTimestampInLocalTimeZoneSinceEpochInMilliseconds:impressionTimeInterval];
    self.params[@"sv"] = @"mobile";

    NSDictionary *data = @{
                           @"events": @{
                                   @"actor": @{
                                           @"tracking_visitor_id": self.deviceID,
                                           @"tracking_visit_id": self.sessionID
                                           },
                                   @"channel" : @"mobile",
                                   @"tracking_event": trackingEventString,
                                   @"event_params": self.params
                                   }
                           };
    return data;
}

+ (NSString *)clientTimestampSinceEpochInMilliseconds:(NSTimeInterval)timeInterval {
    return [NSString stringWithFormat:@"%lld", (long long)(timeInterval * 1000)];
}

+ (NSString *)clientTimestampInLocalTimeZoneSinceEpochInMilliseconds:(NSTimeInterval)timeInterval {
    float timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    long long timeOffsetInMSInLocalTZ = (long long)((timeInterval - timeZoneOffset)*1000);
    return [NSString stringWithFormat:@"%lld", timeOffsetInMSInLocalTZ];
}

+ (NSString *)gmtOffsetInMinutes {
    float timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    return [NSString stringWithFormat:@"%d", (int)(timeZoneOffset/60.0)];
}

@end
