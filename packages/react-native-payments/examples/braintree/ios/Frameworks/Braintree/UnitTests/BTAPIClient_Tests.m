#import <XCTest/XCTest.h>
#import <BraintreeApplePay/BTConfiguration+ApplePay.h>
#import <BraintreePayPal/BTConfiguration+PayPal.h>
#import <BraintreeVenmo/BTConfiguration+Venmo.h>
#import <BraintreeUnionPay/BTConfiguration+UnionPay.h>
#import "BTAnalyticsService.h"
#import "BTAPIClient_Internal.h"
#import "BTFakeHTTP.h"
#import "BTHTTP.h"
#import "BTHTTPTestProtocol.h"
#import "BTSpecHelper.h"

@interface StubBTClientMetadata : BTClientMetadata
@property (nonatomic, assign) BTClientMetadataIntegrationType integration;
@property (nonatomic, assign) BTClientMetadataSourceType source;
@property (nonatomic, copy) NSString *sessionId;
@end

@implementation StubBTClientMetadata
@synthesize integration = _integration;
@synthesize source = _source;
@synthesize sessionId = _sessionId;
@end

@interface BTFakeAnalyticsService : BTAnalyticsService
@property (nonatomic, copy) NSString *lastEvent;
@end

@implementation BTFakeAnalyticsService

- (void)sendAnalyticsEvent:(NSString *)eventKind {
    self.lastEvent = eventKind;
}

- (void)sendAnalyticsEvent:(NSString *)eventKind completion:(__unused void (^)(NSError *))completionBlock {
    self.lastEvent = eventKind;
}

@end

@interface BTAPIClient_Tests : XCTestCase
@end

@implementation BTAPIClient_Tests

#pragma mark - Initialization

- (void)testInitialization_withValidTokenizationKey_setsTokenizationKey {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];
    XCTAssertEqualObjects(apiClient.tokenizationKey, @"development_tokenization_key");
}

- (void)testInitialization_withInvalidTokenizationKey_returnsNil {
    XCTAssertNil([[BTAPIClient alloc] initWithAuthorization:@"not_a_valid_tokenization_key" sendAnalyticsEvent:NO]);
}

- (void)testInitialization_withValidClientToken_setsClientToken {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:BTValidTestClientToken sendAnalyticsEvent:NO];
    XCTAssertEqualObjects(apiClient.clientToken.originalValue, BTValidTestClientToken);
}

- (void)testInitialization_withInvalidClientToken_returnsNil {
    XCTAssertNil([[BTAPIClient alloc] initWithAuthorization:@"invalidclienttoken" sendAnalyticsEvent:NO]);
}

#pragma mark - Environment Base URL

- (void)testBaseURL_isDeterminedByTokenizationKey {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];
    XCTAssertEqualObjects(apiClient.configurationHTTP.baseURL.absoluteString, @"http://localhost:3000/merchants/key/client_api");

    apiClient = [[BTAPIClient alloc] initWithAuthorization:@"sandbox_tokenization_key" sendAnalyticsEvent:NO];
    XCTAssertEqualObjects(apiClient.configurationHTTP.baseURL.absoluteString, @"https://sandbox.braintreegateway.com/merchants/key/client_api");

    apiClient = [[BTAPIClient alloc] initWithAuthorization:@"production_tokenization_key" sendAnalyticsEvent:NO];
    XCTAssertEqualObjects(apiClient.configurationHTTP.baseURL.absoluteString, @"https://api.braintreegateway.com:443/merchants/key/client_api");
}

#pragma mark - Configuration

- (void)testAPIClient_canGetRemoteConfiguration {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];

    BTAPIClient *apiClient = [self clientThatReturnsConfiguration:@{ @"test": @YES }];
    BTFakeHTTP *mockConfigurationHTTP = (BTFakeHTTP *)apiClient.configurationHTTP;

    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        XCTAssertNotNil(configuration);
        XCTAssertNil(error);

        XCTAssertEqual(mockConfigurationHTTP.GETRequestCount, (NSUInteger)1);
        XCTAssertTrue([configuration.json[@"test"] isTrue]);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testConfiguration_whenServerRespondsWithNon200StatusCode_returnsAPIClientError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];

    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];

    BTFakeHTTP *fake = [BTFakeHTTP fakeHTTP];
    [fake stubRequest:@"GET" toEndpoint:@"/client_api/v1/configuration" respondWith:@{ @"error_message": @"Something bad happened" } statusCode:503];
    apiClient.configurationHTTP = fake;

    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        // Note: GETRequestCount will be 1 or 2 depending on whether the analytics event for the API client initialization
        // has failed yet
        XCTAssertNil(configuration);
        XCTAssertEqualObjects(error.domain, BTAPIClientErrorDomain);
        XCTAssertEqual(error.code, BTAPIClientErrorTypeConfigurationUnavailable);
        XCTAssertEqualObjects(error.localizedFailureReason, @"Unable to fetch remote configuration from Braintree API at this time.");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testConfiguration_whenNetworkHasError_returnsNetworkErrorInCallback {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];

    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];

    BTFakeHTTP *fake = [BTFakeHTTP fakeHTTP];
    NSError *anError = [NSError errorWithDomain:NSURLErrorDomain
                                           code:NSURLErrorCannotConnectToHost
                                       userInfo:nil];
    [fake stubRequest:@"GET" toEndpoint:@"/client_api/v1/configuration" respondWithError:anError];
    apiClient.configurationHTTP = fake;

    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        // BTAPIClient fetches the config when initialized so there can potentially be 2 requests here
        XCTAssertLessThanOrEqual(fake.GETRequestCount, (NSUInteger)2);
        XCTAssertNil(configuration);
        XCTAssertEqual(error, anError);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testConfigurationHTTP_byDefault_usesAnInMemoryCache {
    // We don't want configuration to cache configuration responses past the lifetime of the app
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];
    NSURLCache *cache = apiClient.configurationHTTP.session.configuration.URLCache;
    
    XCTAssertTrue(cache.diskCapacity == 0);
    XCTAssertTrue(cache.memoryCapacity > 0);
}

#pragma mark - Dispatch Queue

- (void)testCallbacks_useMainDispatchQueue {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];
    BTFakeHTTP *fake = [[BTFakeHTTP alloc] initWithBaseURL:apiClient.http.baseURL authorizationFingerprint:@""];
    // Override apiClient.http so that requests don't fail
    apiClient.configurationHTTP = fake;
    apiClient.http = fake;

    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Fetch configuration"];
    [apiClient fetchOrReturnRemoteConfiguration:^(__unused BTConfiguration *configuration, __unused NSError *error) {
        XCTAssert([NSThread isMainThread]);
        [expectation1 fulfill];
    }];
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"GET request"];
    [apiClient GET:@"" parameters:@{} completion:^(__unused BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(response);
        XCTAssertNil(error);

        XCTAssert([NSThread isMainThread]);
        [expectation2 fulfill];
    }];
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"POST request"];
    [apiClient POST:@"" parameters:@{} completion:^(__unused BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(response);
        XCTAssertNil(error);

        XCTAssert([NSThread isMainThread]);
        [expectation3 fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark - Payment option categories

- (void)testIsVenmoEnabledIsFalse_withoutAccessToken {
    BTAPIClient *apiClient = [self clientThatReturnsConfiguration:@{ @"payWithVenmo": @{}}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];
    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        XCTAssertNil(error);
        
        XCTAssertFalse(configuration.isVenmoEnabled);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testIsVenmoEnabledIsTrue_withoutAccessToken {
    BTAPIClient *apiClient = [self clientThatReturnsConfiguration:@{ @"payWithVenmo": @{}}];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];
    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        XCTAssertNil(error);
        
        XCTAssertFalse(configuration.isVenmoEnabled);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testIsPayPalEnabled_whenEnabled_returnsTrue {
    BTAPIClient *apiClient = [self clientThatReturnsConfiguration:@{ @"paypalEnabled": @(YES) }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];
    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        XCTAssertNil(error);

        XCTAssertTrue(configuration.isPayPalEnabled);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testIsPayPalEnabled_whenDisabled_returnsFalse {
    BTAPIClient *apiClient = [self clientThatReturnsConfiguration:@{ @"paypalEnabled": @(NO) }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];
    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        XCTAssertNil(error);

        XCTAssertFalse(configuration.isPayPalEnabled);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testIsApplePayEnabled_whenEnabled_returnsTrue {
    BTAPIClient *apiClient = [self clientThatReturnsConfiguration:@{ @"applePay": @{ @"status": @"production" } }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];
    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        XCTAssertNil(error);

        XCTAssertTrue(configuration.isApplePayEnabled);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testIsApplePayEnabled_whenDisabled_returnsFalse {
    BTAPIClient *apiClient = [self clientThatReturnsConfiguration:@{ @"applePay": @{ @"status": @"off" } }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];
    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        XCTAssertNil(error);

        XCTAssertFalse(configuration.isApplePayEnabled);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testIsUnionPayEnabled_whenGatewayReturnsFalse_isFalse {
    BTAPIClient *apiClient = [self clientThatReturnsConfiguration:@{ @"unionPayEnabled": @(NO) }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];
    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        XCTAssertNil(error);

        XCTAssertFalse(configuration.isUnionPayEnabled);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testIsUnionPayEnabled_whenGatewayReturnsTrue_isTrue {
    BTAPIClient *apiClient = [self clientThatReturnsConfiguration:@{ @"unionPay": @{@"enabled": @(YES) } }];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetch configuration"];
    [apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration *configuration, NSError *error) {
        XCTAssertNil(error);

        XCTAssertTrue(configuration.isUnionPayEnabled);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];
}

//#pragma mark - Analytics tests

- (void)testAnalyticsService_isCreatedDuringInitialization {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];
    XCTAssertTrue([apiClient.analyticsService isKindOfClass:[BTAnalyticsService class]]);
}

- (void)testSendAnalyticsEvent_whenCalled_callsAnalyticsService {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];
    BTFakeAnalyticsService *mockAnalyticsService = [[BTFakeAnalyticsService alloc] init];
    apiClient.analyticsService = mockAnalyticsService;

    [apiClient sendAnalyticsEvent:@"blahblah"];

    XCTAssertEqualObjects(mockAnalyticsService.lastEvent, @"blahblah");
}

- (void)testPOST_usesMetadataSourceAndIntegration {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];
    apiClient = [apiClient copyWithSource:BTClientMetadataSourcePayPalApp integration:BTClientMetadataIntegrationDropIn];
    BTFakeHTTP *mockHTTP = [BTFakeHTTP fakeHTTP];
    apiClient.http = mockHTTP;
    [mockHTTP stubRequest:@"GET"
               toEndpoint:@"/client_api/v1/configuration"
              respondWith:@{
                            @"analytics" : @{
                                    @"url" : @"test://do-not-send.url"
                                    } }
               statusCode:200];
    BTClientMetadata *metadata = apiClient.metadata;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Sends analytics event"];
    [apiClient POST:@"/" parameters:@{} completion:^(BTJSON *body, NSHTTPURLResponse *response, NSError *error) {
        XCTAssertNotNil(body);
        XCTAssertNotNil(response);
        XCTAssertNil(error);

        XCTAssertEqualObjects(mockHTTP.lastRequestEndpoint, @"/");
        XCTAssertEqual(apiClient.metadata.source, BTClientMetadataSourcePayPalApp);
        XCTAssertEqual(apiClient.metadata.integration, BTClientMetadataIntegrationDropIn);
        XCTAssertEqualObjects(mockHTTP.lastRequestParameters[@"_meta"][@"integration"], metadata.integrationString);
        XCTAssertEqualObjects(mockHTTP.lastRequestParameters[@"_meta"][@"source"], metadata.sourceString);
        XCTAssertEqualObjects(mockHTTP.lastRequestParameters[@"_meta"][@"sessionId"], metadata.sessionId);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

#pragma mark - Helpers

- (BTAPIClient *)clientThatReturnsConfiguration:(NSDictionary *)configurationDictionary {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:@"development_tokenization_key" sendAnalyticsEvent:NO];
    BTFakeHTTP *fake = [BTFakeHTTP fakeHTTP];
    fake.cannedConfiguration = [[BTJSON alloc] initWithValue:configurationDictionary];
    fake.cannedStatusCode = 200;
    apiClient.configurationHTTP = fake;

    return apiClient;
}

@end
