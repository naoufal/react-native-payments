//
//  PPFPTIDataTest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PPFPTIData.h"

@interface PPFPTIDataTest : XCTestCase

@property (nonatomic, copy, readwrite) NSString *deviceID;
@property (nonatomic, copy, readwrite) NSString *sessionID;
@property (nonatomic, copy, readwrite) NSDictionary *eventParams;
@property (nonatomic, copy, readwrite) NSString *userAgent;
@property (nonatomic, strong, readwrite) NSURL *trackerURL;

@end

@implementation PPFPTIDataTest

- (void)setUp {
    [super setUp];
    self.eventParams = @{
                         @"abc" : @"xyz",
                         @"onetwothree": @"789"
                         };
    self.deviceID = @"myDeviceID";
    self.sessionID = @"mySessionID";
    self.userAgent = @"myUserAgent";
    self.trackerURL = [NSURL URLWithString:@"http://example.com/v1/analytics"];
}

- (void)testDataAsDictionary {
    PPFPTIData *data = [[PPFPTIData alloc] initWithParams:self.eventParams
                                                 deviceID:self.deviceID
                                                sessionID:self.sessionID
                                                userAgent:self.userAgent
                                               trackerURL:self.trackerURL];
    XCTAssertEqualObjects(data.userAgent, self.userAgent);
    XCTAssertEqualObjects(data.trackerURL, self.trackerURL);

    NSDictionary *dataDictionary = [data dataAsDictionary];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];

    NSDictionary *eventsDictionary = dataDictionary[@"events"];
    XCTAssertEqualObjects(eventsDictionary[@"actor"][@"tracking_visitor_id"], self.deviceID);
    XCTAssertEqualObjects(eventsDictionary[@"actor"][@"tracking_visit_id"], self.sessionID);
    XCTAssertEqualObjects(eventsDictionary[@"channel"], @"mobile");

    NSString *trackingEventsString = eventsDictionary[@"tracking_event"];
    XCTAssertNotNil(trackingEventsString);
    long long convertedTimeInterval = [trackingEventsString longLongValue];
    // Tests the generated interval is within 1 second of the expected value
    XCTAssertEqualWithAccuracy(convertedTimeInterval, currentTime * 1000, 1000);

    NSDictionary *eventParamsDictionary = eventsDictionary[@"event_params"];
    XCTAssertEqualObjects(eventParamsDictionary[@"abc"], self.eventParams[@"abc"]);
    XCTAssertEqualObjects(eventParamsDictionary[@"onetwothree"], self.eventParams[@"onetwothree"]);

    // These were other added values passed in the past
    XCTAssertNotNil(eventParamsDictionary[@"g"]);
    XCTAssertNotNil(eventParamsDictionary[@"t"]);

    long long gmtOffsetInMilliseconds = [eventParamsDictionary[@"g"] integerValue] * 60 * 1000;
    XCTAssertEqualWithAccuracy(
                               convertedTimeInterval,
                               gmtOffsetInMilliseconds + [eventParamsDictionary[@"t"] longLongValue],
                               1000
                               );
    
    XCTAssertEqualObjects(eventParamsDictionary[@"sv"], @"mobile");
}

@end
