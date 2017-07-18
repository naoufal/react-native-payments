//
//  PPOTTimeTest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPOTTime.h"

@interface PPOTTimeTest : XCTestCase

@end

@implementation PPOTTimeTest

- (void)testRFC3339DateConversion {
    NSDate *date = [NSDate date];
    NSString *dateAsString = [[PPOTTime rfc3339DateFormatter] stringFromDate:date];
    NSDate *dateFromRFC3339String = [PPOTTime dateFromRFC3339LikeString:dateAsString];
    // Within 1 millisecond
    XCTAssertEqualWithAccuracy([date timeIntervalSince1970], [dateFromRFC3339String timeIntervalSince1970], 1);
}

- (void)testRFC3339DateWithMillisecondConversion {
    NSDate *date = [NSDate date];
    NSString *dateAsString = [[PPOTTime rfc3339DateFormatter] stringFromDate:date];
    NSString *dateAsStringWithMilliseconds = [NSString stringWithFormat:@"%@.123Z",
                                              [dateAsString substringWithRange:NSMakeRange(0, [dateAsString length] - 1)]];
    NSDate *dateFromRFC3339LikeString = [PPOTTime dateFromRFC3339LikeString:dateAsStringWithMilliseconds];
    // Within 1 millisecond
    XCTAssertEqualWithAccuracy([date timeIntervalSince1970], [dateFromRFC3339LikeString timeIntervalSince1970], 1);
}

- (void)testRFC3339DateNil {
    XCTAssertNil([PPOTTime dateFromRFC3339LikeString:nil]);
}

- (void)testRFC3339DateIllegalString {
    XCTAssertNil([PPOTTime dateFromRFC3339LikeString:@"random string"]);
}

@end
