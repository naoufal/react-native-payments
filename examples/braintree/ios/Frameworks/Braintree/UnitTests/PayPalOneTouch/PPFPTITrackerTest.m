//
//  PPFPTITrackerTest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PPFPTITracker.h"
#import "PPFPTIData.h"
#import "PPOTVersion.h"

@interface PPFPTITrackerTest : XCTestCase <PPFPTINetworkAdapterDelegate>

@property (nonatomic, copy, readwrite) NSString *deviceID;
@property (nonatomic, copy, readwrite) NSString *sessionID;
@property (nonatomic, strong, readwrite) XCTestExpectation *expectation;

@end


@implementation PPFPTITrackerTest

- (void)setUp {
    [super setUp];
    self.deviceID = @"myDeviceID";
    self.sessionID = @"mySessionID";
    self.expectation = nil;
}

- (void)tearDown {
    self.expectation = nil;
    [super tearDown];
}

- (void)testDelegateNotSetDoesNotCrash {
    PPFPTITracker *tracker = [[PPFPTITracker alloc] initWithDeviceUDID:self.deviceID
                                                             sessionID:self.sessionID
                                                networkAdapterDelegate:nil];
    [tracker submitEventWithParams:[NSDictionary dictionary]];
}

- (void)testDelegatePassedInformation {
    PPFPTITracker *tracker = [[PPFPTITracker alloc] initWithDeviceUDID:self.deviceID
                                                             sessionID:self.sessionID
                                                networkAdapterDelegate:self];
    self.expectation = [self expectationWithDescription:@"Expect sendRequestWithData to be called"];

    [tracker submitEventWithParams:[NSDictionary dictionary]];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark PPFPTINetworkAdapterDelegate methods

- (void)sendRequestWithData:(nonnull PPFPTIData*)fptiData {
    NSString *userAgentPrefix = [NSString stringWithFormat:@"PayPalSDK/OneTouchCore-iOS %@", PayPalOTVersion()];
    XCTAssertTrue([fptiData.userAgent hasPrefix:userAgentPrefix], @"Expect PayPal to be in the prefix to help FPTI");
    XCTAssertEqualObjects(fptiData.trackerURL, [NSURL URLWithString:@"https://api-m.paypal.com/v1/tracking/events"]);

    NSDictionary *dataDictionary = [fptiData dataAsDictionary];

    NSDictionary *eventsDictionary = dataDictionary[@"events"];
    XCTAssertEqualObjects(eventsDictionary[@"actor"][@"tracking_visitor_id"], self.deviceID);
    XCTAssertEqualObjects(eventsDictionary[@"actor"][@"tracking_visit_id"], self.sessionID);
    
    [self.expectation fulfill];
}

@end
