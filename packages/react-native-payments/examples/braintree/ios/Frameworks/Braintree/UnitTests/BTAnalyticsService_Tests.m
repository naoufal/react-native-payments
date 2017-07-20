#import "UnitTests-Swift.h"
#import "BTAnalyticsService.h"
#import "BTKeychain.h"
#import "Braintree-Version.h"
#import "BTFakeHTTP.h"
#import <XCTest/XCTest.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>

@interface BTAnalyticsService_Tests : XCTestCase

@end

@implementation BTAnalyticsService_Tests

#pragma mark - Analytics tests

- (void)testSendAnalyticsEvent_whenRemoteConfigurationHasNoAnalyticsURL_returnsError {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:nil];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Sends analytics event"];
    [analyticsService sendAnalyticsEvent:@"any.analytics.event" completion:^(NSError *error) {
        XCTAssertEqual(error.domain, BTAnalyticsServiceErrorDomain);
        XCTAssertEqual(error.code, (NSInteger)BTAnalyticsServiceErrorTypeMissingAnalyticsURL);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testSendAnalyticsEvent_whenRemoteConfigurationHasAnalyticsURL_setsUpAnalyticsHTTPToUseBaseURL {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:@"test://do-not-send.url"];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Sends analytics event"];
    [analyticsService sendAnalyticsEvent:@"any.analytics.event" completion:^(NSError *error) {
        XCTAssertEqualObjects(analyticsService.http.baseURL.absoluteString, @"test://do-not-send.url");
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testSendAnalyticsEvent_whenNumberOfQueuedEventsMeetsThreshold_sendsAnalyticsEvent {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:@"test://do-not-send.url"];
    BTFakeHTTP *mockAnalyticsHTTP = [BTFakeHTTP fakeHTTP];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];
    analyticsService.flushThreshold = 1;
    analyticsService.http = mockAnalyticsHTTP;

    [analyticsService sendAnalyticsEvent:@"an.analytics.event"];
    // Pause briefly to allow analytics service to dispatch async blocks
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];

    XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestEndpoint, @"/");
    XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestParameters[@"analytics"][0][@"kind"], @"an.analytics.event");
    [self validateMetaParameters:mockAnalyticsHTTP.lastRequestParameters[@"_meta"]];
}

- (void)testSendAnalyticsEvent_whenFlushThresholdIsGreaterThanNumberOfBatchedEvents_doesNotSendAnalyticsEvent {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:@"test://do-not-send.url"];
    BTFakeHTTP *mockAnalyticsHTTP = [BTFakeHTTP fakeHTTP];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];
    analyticsService.flushThreshold = 2;
    analyticsService.http = mockAnalyticsHTTP;
    
    [analyticsService sendAnalyticsEvent:@"an.analytics.event"];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];

    XCTAssertTrue(mockAnalyticsHTTP.POSTRequestCount == 0);
}

- (void)testSendAnalyticsEventCompletion_whenCalled_sendsAllEvents {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:@"test://do-not-send.url"];
    BTFakeHTTP *mockAnalyticsHTTP = [BTFakeHTTP fakeHTTP];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];
    analyticsService.flushThreshold = 5;
    analyticsService.http = mockAnalyticsHTTP;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Sends batched request"];
    [analyticsService sendAnalyticsEvent:@"an.analytics.event"];
    [analyticsService sendAnalyticsEvent:@"another.analytics.event" completion:^(NSError *error) {
        XCTAssertNil(error);
        XCTAssertTrue(mockAnalyticsHTTP.POSTRequestCount == 1);
        XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestEndpoint, @"/");
        XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestParameters[@"analytics"][0][@"kind"], @"an.analytics.event");
        XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestParameters[@"analytics"][1][@"kind"], @"another.analytics.event");
        [self validateMetaParameters:mockAnalyticsHTTP.lastRequestParameters[@"_meta"]];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testFlush_whenCalled_sendsAllQueuedEvents {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:@"test://do-not-send.url"];
    BTFakeHTTP *mockAnalyticsHTTP = [BTFakeHTTP fakeHTTP];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];
    analyticsService.flushThreshold = 5;
    analyticsService.http = mockAnalyticsHTTP;
    
    [analyticsService sendAnalyticsEvent:@"an.analytics.event"];
    [analyticsService sendAnalyticsEvent:@"another.analytics.event"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Sends batched request"];
    [analyticsService flush:^(NSError *error) {
        XCTAssertNil(error);
        XCTAssertTrue(mockAnalyticsHTTP.POSTRequestCount == 1);
        XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestEndpoint, @"/");
        XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestParameters[@"analytics"][0][@"kind"], @"an.analytics.event");
        XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestParameters[@"analytics"][1][@"kind"], @"another.analytics.event");
        [self validateMetaParameters:mockAnalyticsHTTP.lastRequestParameters[@"_meta"]];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testFlush_whenThereAreNoQueuedEvents_doesNotPOST {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:@"test://do-not-send.url"];
    BTFakeHTTP *mockAnalyticsHTTP = [BTFakeHTTP fakeHTTP];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];
    analyticsService.flushThreshold = 5;
    analyticsService.http = mockAnalyticsHTTP;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Sends batched request"];
    [analyticsService flush:^(NSError *error) {
        XCTAssertNil(error);
        XCTAssertTrue(mockAnalyticsHTTP.POSTRequestCount == 0);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testAnalyticsService_whenAPIClientConfigurationFails_returnsError {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:@"test://do-not-send.url"];
    NSError *stubbedError = [NSError errorWithDomain:@"SomeError" code:1 userInfo:nil];
    stubAPIClient.cannedConfigurationResponseError = stubbedError;
    BTFakeHTTP *mockAnalyticsHTTP = [BTFakeHTTP fakeHTTP];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];
    analyticsService.http = mockAnalyticsHTTP;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked with error"];
    [analyticsService sendAnalyticsEvent:@"an.analytics.event" completion:^(NSError *error) {
        XCTAssertEqualObjects(error, stubbedError);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
    
    expectation = [self expectationWithDescription:@"Callback invoked with error"];
    [analyticsService flush:^(NSError *error) {
        XCTAssertEqualObjects(error, stubbedError);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testAnalyticsService_afterConfigurationError_maintainsQueuedEventsUntilConfigurationIsSuccessful {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:@"test://do-not-send.url"];
    NSError *stubbedError = [NSError errorWithDomain:@"SomeError" code:1 userInfo:nil];
    stubAPIClient.cannedConfigurationResponseError = stubbedError;
    BTFakeHTTP *mockAnalyticsHTTP = [BTFakeHTTP fakeHTTP];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];
    analyticsService.http = mockAnalyticsHTTP;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked with error"];
    [analyticsService sendAnalyticsEvent:@"an.analytics.event" completion:^(NSError *error) {
        XCTAssertEqualObjects(error, stubbedError);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
    
    stubAPIClient.cannedConfigurationResponseError = nil;
    
    expectation = [self expectationWithDescription:@"Callback invoked with error"];
    [analyticsService sendAnalyticsEvent:@"an.analytics.event" completion:^(NSError *error) {
        XCTAssertNil(error);
        XCTAssertTrue(mockAnalyticsHTTP.POSTRequestCount == 1);
        XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestEndpoint, @"/");
        XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestParameters[@"analytics"][0][@"kind"], @"an.analytics.event");
        [self validateMetaParameters:mockAnalyticsHTTP.lastRequestParameters[@"_meta"]];
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testAnalyticsService_whenAppIsBackgrounded_sendsQueuedAnalyticsEvents {
    MockAPIClient *stubAPIClient = [self stubbedAPIClientWithAnalyticsURL:@"test://do-not-send.url"];
    BTFakeHTTP *mockAnalyticsHTTP = [BTFakeHTTP fakeHTTP];
    BTAnalyticsService *analyticsService = [[BTAnalyticsService alloc] initWithAPIClient:stubAPIClient];
    analyticsService.flushThreshold = 5;
    analyticsService.http = mockAnalyticsHTTP;
    
    [analyticsService sendAnalyticsEvent:@"an.analytics.event"];
    [analyticsService sendAnalyticsEvent:@"another.analytics.event"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillResignActiveNotification object:nil];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    
    XCTAssertTrue(mockAnalyticsHTTP.POSTRequestCount == 1);
    XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestEndpoint, @"/");
    XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestParameters[@"analytics"][0][@"kind"], @"an.analytics.event");
    XCTAssertEqualObjects(mockAnalyticsHTTP.lastRequestParameters[@"analytics"][1][@"kind"], @"another.analytics.event");
    [self validateMetaParameters:mockAnalyticsHTTP.lastRequestParameters[@"_meta"]];
}

#pragma mark - Helpers

- (MockAPIClient *)stubbedAPIClientWithAnalyticsURL:(NSString *)analyticsURL {
    MockAPIClient *stubAPIClient = [[MockAPIClient alloc] initWithAuthorization:@"development_tokenization_key"];
    if (analyticsURL) {
         stubAPIClient.cannedConfigurationResponseBody = [[BTJSON alloc] initWithValue:@{ @"analytics" : @{ @"url" : analyticsURL } }];
    } else {
        stubAPIClient.cannedConfigurationResponseBody = [[BTJSON alloc] initWithValue:@{}];
    }
    return stubAPIClient;
}

- (void)validateMetaParameters:(NSDictionary *)metaParameters {
    NSString *unitTestDeploymentTargetVersion = [@(__IPHONE_OS_VERSION_MIN_REQUIRED) stringValue];
    NSString *unitTestBaseSDKVersion = [@(__IPHONE_OS_VERSION_MAX_ALLOWED) stringValue];

    XCTAssertEqualObjects(metaParameters[@"deviceManufacturer"], @"Apple");
    XCTAssertEqualObjects(metaParameters[@"deviceModel"], [self deviceModel]);
    XCTAssertEqualObjects(metaParameters[@"deviceAppGeneratedPersistentUuid"], [self deviceAppGeneratedPersistentUuid]);
    XCTAssertEqualObjects(metaParameters[@"deviceScreenOrientation"], @"Portrait");
    XCTAssertEqualObjects(metaParameters[@"integration"], @"custom");
    XCTAssertEqualObjects(metaParameters[@"iosBaseSDK"], unitTestBaseSDKVersion);
    XCTAssertEqualObjects(metaParameters[@"iosDeploymentTarget"], unitTestDeploymentTargetVersion);
    XCTAssertEqualObjects(metaParameters[@"iosDeviceName"], [[UIDevice currentDevice] name]);
    XCTAssertTrue((BOOL)metaParameters[@"isSimulator"] == TARGET_IPHONE_SIMULATOR);
    XCTAssertEqualObjects(metaParameters[@"merchantAppId"], @"com.braintreepayments.Demo");
    XCTAssertEqualObjects(metaParameters[@"merchantAppName"], @"Braintree iOS SDK Demo");
    XCTAssertEqualObjects(metaParameters[@"sdkVersion"], BRAINTREE_VERSION);
    XCTAssertEqualObjects(metaParameters[@"platform"], @"iOS");
    XCTAssertEqualObjects(metaParameters[@"platformVersion"], [[UIDevice currentDevice] systemVersion]);
    XCTAssertNotNil(metaParameters[@"sessionId"]);
    XCTAssertEqualObjects(metaParameters[@"source"], @"unknown");
    XCTAssertTrue([metaParameters[@"venmoInstalled"] isKindOfClass:[NSNumber class]]);
}

// Ripped from BTAnalyticsMetadata
- (NSString *)deviceModel {
    struct utsname systemInfo;

    uname(&systemInfo);

    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    return code;
}

// Ripped from BTAnalyticsMetadata
- (NSString *)deviceAppGeneratedPersistentUuid {
    @try {
        static NSString *deviceAppGeneratedPersistentUuidKeychainKey = @"deviceAppGeneratedPersistentUuid";
        NSString *savedIdentifier = [BTKeychain stringForKey:deviceAppGeneratedPersistentUuidKeychainKey];
        if (savedIdentifier.length == 0) {
            savedIdentifier = [[NSUUID UUID] UUIDString];
            BOOL setDidSucceed = [BTKeychain setString:savedIdentifier
                                                forKey:deviceAppGeneratedPersistentUuidKeychainKey];
            if (!setDidSucceed) {
                return nil;
            }
        }
        return savedIdentifier;
    } @catch (NSException *exception) {
        return nil;
    }
}

@end
