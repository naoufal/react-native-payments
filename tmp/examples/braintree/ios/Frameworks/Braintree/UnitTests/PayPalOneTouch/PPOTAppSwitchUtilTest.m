//
//  PayPalTouchCoreTests.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PPOTAppSwitchUtil.h"
#import "PPOTJSONHelper.h"

@interface PPOTAppSwitchUtilTest : XCTestCase

@end

@implementation PPOTAppSwitchUtilTest

- (void)testAppSwitchNotPossible {
    BOOL possible = [PPOTAppSwitchUtil isCallbackURLSchemeValid:@"com.scheme.bla"];
    XCTAssertFalse(possible, @"app switch should not be possible when unit tests running");
}

- (void)testParseQueryTest {
    NSString *quearyToTest = nil;
    NSDictionary *parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertFalse(parseQueryStringDict.count, @"count should be 0");

    quearyToTest = @"";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertFalse(parseQueryStringDict.count, @"count should be 0");

    quearyToTest = @"&";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertFalse(parseQueryStringDict.count, @"count should be 0");

    quearyToTest = @"?";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertFalse(parseQueryStringDict.count, @"count should be 0");

    quearyToTest = @"hello&";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertFalse(parseQueryStringDict.count, @"count should be 0");

    quearyToTest = @"hello&hello";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertFalse(parseQueryStringDict.count, @"count should be 0");

    quearyToTest = @"&hello";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertFalse(parseQueryStringDict.count, @"count should be 0");

    quearyToTest = @"&=hello";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertFalse(parseQueryStringDict.count, @"count should be 0");

    quearyToTest = @"hello=hello";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertTrue(parseQueryStringDict.count == 1, @"count should be 0");

    quearyToTest = @"&hello=hello";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertTrue(parseQueryStringDict.count == 1, @"count should be 0");

    quearyToTest = @"&hello=hello";
    parseQueryStringDict = [PPOTAppSwitchUtil parseQueryString:quearyToTest];
    XCTAssertTrue(parseQueryStringDict.count == 1, @"count should be 0");
}

- (void)testJsonEncodingDecoding {
    NSDictionary *dict1 = @{@"key1": @1, @"key2": @"some.strings", @"key2": @{@"dict1": @"value"}, @"key3": @[@"el1", @"el2"]};

    NSString *encoded = [PPOTJSONHelper base64EncodedJSONStringWithDictionary:dict1];

    NSDictionary *dict2 = [PPOTJSONHelper dictionaryWithBase64EncodedJSONString:encoded];

    XCTAssertEqualObjects(dict1, dict2, @"dictionaries must be the same");
}

// TODO: Test fails with PayPal OneTouchCoreSDK: callback URL scheme must start with com.braintreepayments.demo
- (void)pendURLAction {
    NSString *urlTest = @"com.test.mytest://test?payload=e30%3D&x-source=(null)&x-success=com.test.callback://success&x-cancel=com.test.callback://cancel";
    NSURL *urlAction = [PPOTAppSwitchUtil URLAction:@"test" targetAppURLScheme:@"com.test.mytest" callbackURLScheme:@"com.test.callback" payload:@{}];
    XCTAssertNotNil(urlAction, @"action should not be nil");
    XCTAssertEqualObjects([urlAction absoluteString], urlTest, @"links should be the same");
}

- (void)testInvalidURL {
    XCTAssertFalse([PPOTAppSwitchUtil isValidURLAction:nil], @"should fail");

    NSString *urlTest = @"com.test.mytest://test?payload=e30%3D&x-source=(null)&x-success=com.test.callback://success&x-cancel=com.test.callback://cancel";
    NSURL *url = [NSURL URLWithString:urlTest];
    XCTAssertFalse([PPOTAppSwitchUtil isValidURLAction:url], @"should fail");
}

@end
