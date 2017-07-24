#import "BTClientToken.h"
#import "BTTestClientTokenFactory.h"
#import <Expecta/Expecta.h>
#import <XCTest/XCTest.h>

@interface BTClientToken_Tests : XCTestCase
@end

@implementation BTClientToken_Tests

- (void)testInitialization_whenVersionIsUnsupported_returnsError {
    NSError *error;
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:[BTTestClientTokenFactory tokenWithVersion:2 overrides:@{ @"version": @0 }] error:&error];
    XCTAssertNil(clientToken);
    XCTAssertEqualObjects(error.domain, BTClientTokenErrorDomain);
    XCTAssertEqual(error.code, BTClientTokenErrorUnsupportedVersion);
}

- (void)testInitialization_withV1RawJSONClientTokens_isSuccessful {
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:[BTTestClientTokenFactory tokenWithVersion:1 overrides:@{ BTClientTokenKeyConfigURL: @"https://api.example.com:443/merchants/a_merchant_id/client_api/v1/configuration"}] error:NULL];
    XCTAssertEqualObjects(clientToken.authorizationFingerprint, @"an_authorization_fingerprint");
    XCTAssertEqualObjects(clientToken.configURL, [NSURL URLWithString:@"https://api.example.com:443/merchants/a_merchant_id/client_api/v1/configuration"]);
}

- (void)testInitialization_withV2Base64EncodedClientTokens_isSuccessful {
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:[BTTestClientTokenFactory tokenWithVersion:2 overrides:@{ BTClientTokenKeyConfigURL: @"https://api.example.com:443/merchants/a_merchant_id/client_api/v1/configuration" }] error:NULL];
    XCTAssertEqualObjects(clientToken.authorizationFingerprint, @"an_authorization_fingerprint");
    XCTAssertEqualObjects(clientToken.configURL, [NSURL URLWithString:@"https://api.example.com:443/merchants/a_merchant_id/client_api/v1/configuration"]);
}

- (void)testInitialization_withInvalidJSON_returnsError {
    NSError *error;
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:@"definitely_not_a_client_token" error:&error];

    XCTAssertNil(clientToken);
    XCTAssertEqualObjects(error.domain, BTClientTokenErrorDomain);
    XCTAssertEqual(error.code, BTClientTokenErrorInvalid);
    XCTAssertEqualObjects([error.userInfo[NSUnderlyingErrorKey] domain], NSCocoaErrorDomain);
}

#pragma mark - Edge cases

- (void)testInitialization_whenConfigURLIsBlank_returnsError {
    NSString *clientTokenRawJSON = [BTTestClientTokenFactory tokenWithVersion:2 overrides:@{ BTClientTokenKeyConfigURL: @"" }];
    NSError *error;
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:clientTokenRawJSON error:&error];

    XCTAssertNil(clientToken);
    XCTAssertEqualObjects(error.domain, BTClientTokenErrorDomain);
    XCTAssertEqual(error.code, BTClientTokenErrorInvalid);
    expect([error localizedDescription]).to.contain(@"config url");
}

- (void)testInitialization_whenAuthorizationFingerprintIsOmitted_returnsError {
    NSString *clientTokenRawJSON = [BTTestClientTokenFactory tokenWithVersion:2 overrides:@{ BTClientTokenKeyAuthorizationFingerprint: NSNull.null }];
    NSError *error;

    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:clientTokenRawJSON error:&error];

    XCTAssertNil(clientToken);
    XCTAssertEqualObjects(error.domain, BTClientTokenErrorDomain);
    XCTAssertEqual(error.code, BTClientTokenErrorInvalid);
    expect([error localizedDescription]).to.contain(@"Invalid client token.");
    expect([error localizedFailureReason]).to.contain(@"Authorization fingerprint");
}

- (void)testInitialization_whenAuthorizationFingerprintIsBlank_returnsError {
    NSString *clientTokenRawJSON = [BTTestClientTokenFactory tokenWithVersion:2 overrides:@{ BTClientTokenKeyAuthorizationFingerprint: @"" }];
    NSError *error;

    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:clientTokenRawJSON error:&error];

    XCTAssertNil(clientToken);
    XCTAssertEqualObjects(error.domain, BTClientTokenErrorDomain);
    XCTAssertEqual(error.code, BTClientTokenErrorInvalid);
    expect([error localizedDescription]).to.contain(@"Invalid client token.");
    expect([error localizedFailureReason]).to.contain(@"Authorization fingerprint");
}

#pragma mark - NSCoding

- (void)testNSCoding_afterEncodingAndDecodingClientToken_preservesClientTokenDataIntegrity {
    NSString *clientTokenEncodedJSON = [BTTestClientTokenFactory tokenWithVersion:2 overrides:@{
                                                                                                BTClientTokenKeyConfigURL: @"https://api.example.com/client_api/v1/configuration",
                                                                                                BTClientTokenKeyAuthorizationFingerprint: @"an_authorization_fingerprint|created_at=2014-02-12T18:02:30+0000&customer_id=1234567&public_key=integration_public_key" }];
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:clientTokenEncodedJSON error:NULL];

    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [clientToken encodeWithCoder:coder];
    [coder finishEncoding];

    NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    BTClientToken *returnedClientToken = [[BTClientToken alloc] initWithCoder:decoder];
    [decoder finishDecoding];

    expect(returnedClientToken.configURL).to.equal([NSURL URLWithString:@"https://api.example.com/client_api/v1/configuration"]);
    expect(returnedClientToken.authorizationFingerprint).to.equal(@"an_authorization_fingerprint|created_at=2014-02-12T18:02:30+0000&customer_id=1234567&public_key=integration_public_key");
}

#pragma mark - isEqual

- (void)testIsEqual_whenTokensContainTheSameValues_returnsTrue {
    NSString *clientTokenEncodedJSON = [BTTestClientTokenFactory tokenWithVersion:2 overrides:@{ BTClientTokenKeyAuthorizationFingerprint: @"abcd" }];
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:clientTokenEncodedJSON error:NULL];
    BTClientToken *clientToken2 = [[BTClientToken alloc] initWithClientToken:clientTokenEncodedJSON error:NULL];

    XCTAssertNotNil(clientToken);
    XCTAssertTrue([clientToken isEqual:clientToken2]);
}

- (void)testIsEqual_whenTokensDoNotContainTheSameValues_returnsFalse {
    NSString *clientTokenString1 = [BTTestClientTokenFactory tokenWithVersion:2 overrides:@{ BTClientTokenKeyAuthorizationFingerprint: @"one_auth_fingerprint" }];
    NSString *clientTokenString2 = [BTTestClientTokenFactory tokenWithVersion:2 overrides:@{ BTClientTokenKeyAuthorizationFingerprint: @"different_auth_fingerprint" }];
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:clientTokenString1 error:nil];
    BTClientToken *clientToken2 = [[BTClientToken alloc] initWithClientToken:clientTokenString2 error:nil];

    XCTAssertNotNil(clientToken);
    XCTAssertFalse([clientToken isEqual:clientToken2]);
}

#pragma mark - NSCopying

- (void)testCopy_returnsADifferentInstance {
    NSString *clientTokenRawJSON = [BTTestClientTokenFactory tokenWithVersion:2];
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:clientTokenRawJSON error:NULL];

    XCTAssertTrue([clientToken copy] != clientToken);
}

- (void)testCopy_returnsAnEquivalentInstance {
    NSString *clientTokenRawJSON = [BTTestClientTokenFactory tokenWithVersion:2];
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:clientTokenRawJSON error:NULL];

    XCTAssertEqualObjects([clientToken copy], clientToken);
}

- (void)testCopy_returnsAnInstanceWithEqualValues {
    NSString *clientTokenRawJSON = [BTTestClientTokenFactory tokenWithVersion:2];
    BTClientToken *clientToken = [[BTClientToken alloc] initWithClientToken:clientTokenRawJSON error:NULL];
    BTClientToken *copiedClientToken = [clientToken copy];

    XCTAssertEqualObjects(copiedClientToken.configURL, clientToken.configURL);
    XCTAssertEqualObjects(copiedClientToken.json.asDictionary, clientToken.json.asDictionary);
    XCTAssertEqualObjects(copiedClientToken.authorizationFingerprint, clientToken.authorizationFingerprint);
    XCTAssertEqualObjects(copiedClientToken.originalValue, clientToken.originalValue);
}

@end
