//
//  PPAppSwitchResponse.m
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PPOTAppSwitchResponse.h"
#import "PPOTEncryptionHelper.h"
#import "PPOTString.h"

@interface PPOTAppSwitchResponseTest : XCTestCase

@end

@implementation PPOTAppSwitchResponseTest

- (void)test1InvalidHermesResponse {
    PPOTAppSwitchResponse *response = [[PPOTAppSwitchResponse alloc] initWithHermesURL:nil environment:nil];
    XCTAssertNil(response);


    response = [[PPOTAppSwitchResponse alloc] initWithHermesURL:[NSURL URLWithString:@"http"] environment:nil];
    XCTAssertFalse(response.validResponse);

    response = [[PPOTAppSwitchResponse alloc] initWithHermesURL:[NSURL URLWithString:@"http://success"] environment:nil];
    XCTAssertTrue(response.validResponse);
    response = [[PPOTAppSwitchResponse alloc] initWithHermesURL:[NSURL URLWithString:@"http://cancel"] environment:nil];
    XCTAssertTrue(response.validResponse);
}

- (void)testInvalidEncodedURLResponse {
    PPOTAppSwitchResponse *response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:nil encryptionKey:nil];
    XCTAssertNil(response);
    NSURL *encodedURL = [NSURL URLWithString:@""];
    response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:encodedURL encryptionKey:nil];
    XCTAssertFalse(response.validResponse);
    encodedURL = [NSURL URLWithString:@"http://success"];
    response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:encodedURL encryptionKey:nil];
    XCTAssertFalse(response.validResponse);
    encodedURL = [NSURL URLWithString:@"http://cancel"];
    response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:encodedURL encryptionKey:nil];
    // cancel is a cancel
    XCTAssertTrue(response.validResponse && response.action == PPAppSwitchResponseActionCancel);

    encodedURL = [NSURL URLWithString:@"http://success?payload=84032840274927rowueoruwohrwlrhwourowr&payloadEnc=8043729742964uoeruwohrkwjr20r82048"];
    response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:encodedURL encryptionKey:nil];
    XCTAssertFalse(response.validResponse);
    // any cancel we don't care about result
    encodedURL = [NSURL URLWithString:@"http://cancel?payload=84032840274927rowueoruwohrwlrhwourowr&payloadEnc=8043729742964uoeruwohrkwjr20r82048"];
    response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:encodedURL encryptionKey:nil];
    XCTAssertTrue(response.validResponse);
}

- (void)testInvalidEncryptedURLResponse {
    NSURL *encodedURL = [NSURL URLWithString:@"http://success?payload=eyJ0ZXN0IjoidGVzdCJ9&payloadEnc=eyJ0ZXN0IjoidGVzdCJ9"];
    PPOTAppSwitchResponse *response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:encodedURL encryptionKey:@"test"];
    XCTAssertFalse(response.validResponse);
    NSData *key = [PPOTEncryptionHelper generate256BitKey];
    NSString *hexKey = [PPOTString hexStringFromData:key];
    response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:encodedURL encryptionKey:hexKey];
    XCTAssertFalse(response.validResponse);

    encodedURL = [NSURL URLWithString:@"http://success?payload=eyJ0ZXN0IjoidGVzdCJ9==&payloadEnc=eyJ0ZXN0IjoidGVzdCJ9+/80\n"];
    response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:encodedURL encryptionKey:hexKey];
    XCTAssertFalse(response.validResponse);
}

- (void)testErrorWithDictionaryAlreadyInResponse {
    NSURL *encodedURL = [NSURL URLWithString:@"http://shouldBeError?payload=eyJ2ZXJzaW9uIjozLCJtc2dfR1VJRCI6bnVsbCwicmVzcG9uc2VfdHlwZSI6bnVsbCwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXJyb3IiOnsiZGVidWdfaWQiOm51bGwsIm1lc3NhZ2UiOiJFbmNyeXB0ZWQgcGF5bG9hZCBoYXMgZXhwaXJlZCJ9LCJsYW5ndWFnZSI6bnVsbH0"];
    PPOTAppSwitchResponse *response = [[PPOTAppSwitchResponse alloc] initWithEncodedURL:encodedURL encryptionKey:nil];
    XCTAssertFalse(response.validResponse);
    XCTAssertEqual(response.responseType, PPAppSwitchResponseActionUnknown);
    XCTAssertEqual(response.version, 3);
    XCTAssertEqual(response.action, PPAppSwitchResponseActionUnknown);
    NSLog(@"%@", response.error);
    NSDictionary* expectedError = @{ @"message": @"Encrypted payload has expired", @"debug_id": [NSNull null] };
    XCTAssertEqualObjects(response.error, expectedError);
    XCTAssertNil(response.msgID);
    XCTAssertEqualObjects(response.environment, @"mock");
}

@end
