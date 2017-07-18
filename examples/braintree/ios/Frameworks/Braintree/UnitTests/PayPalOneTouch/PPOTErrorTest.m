//
//  PPOTErrorTest.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPOTError.h"

@interface PPOTErrorTest : XCTestCase

@end

@implementation PPOTErrorTest

- (void)testPPErrorWithErrorCode {
    NSError *error = [PPOTError errorWithErrorCode:PPOTErrorCodeNoTargetAppFound];
    XCTAssertEqualObjects(error.domain, kPayPalOneTouchErrorDomain);
    XCTAssertEqual(error.code, PPOTErrorCodeNoTargetAppFound);
    XCTAssertEqualObjects(error.userInfo, [NSDictionary dictionary]);

}

- (void)testPPErrorWithErrorCodeAndUserInfo {
    NSDictionary *dict = @{ @"k" : @"v"};
    NSError *error = [PPOTError errorWithErrorCode:PPOTErrorCodeNoTargetAppFound
                                          userInfo:dict];
    XCTAssertEqualObjects(error.domain, kPayPalOneTouchErrorDomain);
    XCTAssertEqual(error.code, PPOTErrorCodeNoTargetAppFound);
    XCTAssertEqualObjects(error.userInfo, dict);
}

@end
