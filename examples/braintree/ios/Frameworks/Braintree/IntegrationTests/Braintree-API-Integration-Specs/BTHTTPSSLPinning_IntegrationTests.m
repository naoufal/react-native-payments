#import "BTHTTP.h"
#import <XCTest/XCTest.h>

@interface BTHTTPSSLPinning_IntegrationTests : XCTestCase
@end

@implementation BTHTTPSSLPinning_IntegrationTests

// Will work when we comply with ATS
- (void)testBTHTTP_whenUsingProductionEnvironmentWithTrustedSSLCertificates_allowsNetworkCommunication {
    NSURL *url = [NSURL URLWithString:@"https://api.braintreegateway.com"];
    BTHTTP *http = [[BTHTTP alloc] initWithBaseURL:url tokenizationKey:@"development_testing_integration_merchant_id"];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [http GET:@"/heartbeat.json" completion:^(BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error) {
        XCTAssertEqualObjects([body[@"heartbeat"] asString], @"d2765eaa0dad9b300b971f074-production");
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testBTHTTP_whenUsingSandboxEnvironmentWithTrustedSSLCertificates_allowsNetworkCommunication {
    NSURL *url = [NSURL URLWithString:@"https://api.sandbox.braintreegateway.com"];
    BTHTTP *http = [[BTHTTP alloc] initWithBaseURL:url tokenizationKey:@"development_testing_integration_merchant_id"];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [http GET:@"/heartbeat.json" completion:^(BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error) {
        XCTAssertEqualObjects([body[@"heartbeat"] asString], @"d2765eaa0dad9b300b971f074-sandbox");
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testBTHTTP_whenUsingAServerWithValidCertificateChainWithARootCAThatWeDoNotExplicitlyTrust_doesNotAllowNetworkCommunication {
    NSURL *url = [NSURL URLWithString:@"https://www.digicert.com"];
    BTHTTP *http = [[BTHTTP alloc] initWithBaseURL:url tokenizationKey:@"development_testing_integration_merchant_id"];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [http GET:@"/heartbeat.json" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNil(body);
        XCTAssertNil(response);
        XCTAssertEqualObjects(error.domain, NSURLErrorDomain);
        XCTAssertEqual(error.code, NSURLErrorServerCertificateUntrusted);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark - SSL Pinning

#ifdef RUN_SSL_PINNING_SPECS

- (void)testBTHTTP_whenUsingTrustedPinnedRootCertificates_allowsNetworkCommunication {
    NSURL *url = [NSURL URLWithString:@"https://localhost:9443"];
    BTHTTP *http = [[BTHTTP alloc] initWithBaseURL:url tokenizationKey:@"development_testing_integration_merchant_id"];
    http.pinnedCertificates = @[[NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"good_root_cert" ofType:@"der"]]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [http GET:@"/" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testBTHTTP_whenUsingUntrustedUnpinnedRootCertificatesFromLegitimateHosts_doesNotallowNetworkCommunication {
    NSURL *url = [NSURL URLWithString:@"https://localhost:9444"];
    BTHTTP *http = [[BTHTTP alloc] initWithBaseURL:url tokenizationKey:@"development_testing_integration_merchant_id"];
    http.pinnedCertificates = @[[NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"good_root_cert" ofType:@"der"]]];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [http GET:@"heartbeat" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNil(body);
        XCTAssertNil(response);
        XCTAssertEqualObjects(error.domain, NSURLErrorDomain);
        XCTAssertEqual(error.code, NSURLErrorServerCertificateUntrusted);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testBTHTTP_whenUsingNonSSLConnection_allowsNetworkCommunication {
    NSURL *url = [NSURL URLWithString:@"http://localhost:9445/"];
    BTHTTP *http = [[BTHTTP alloc] initWithBaseURL:url tokenizationKey:@"development_testing_integration_merchant_id"];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [http GET:@"heartbeat" completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#endif

@end
