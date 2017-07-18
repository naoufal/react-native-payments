#import "BraintreeDataCollector.h"
#import "KDataCollector.h"
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

@interface BraintreeDataCollector_IntegrationTests : XCTestCase
@property (nonatomic, strong) BTDataCollector *dataCollector;
@end

@implementation BraintreeDataCollector_IntegrationTests

- (void)setUp {
    [super setUp];
    BTAPIClient *client = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    self.dataCollector = [[BTDataCollector alloc] initWithAPIClient:client];
}

- (void)tearDown {
    [super tearDown];
    self.dataCollector = nil;
}

#pragma mark - collectFraudData:

- (void)testCollectFraudData_returnsFraudData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    
    [self.dataCollector collectFraudData:^(NSString * _Nonnull deviceData) {
        XCTAssertTrue([deviceData containsString:@"correlation_id"]);
        XCTAssertTrue([deviceData containsString:@"device_session_id"]);
        XCTAssertTrue([deviceData containsString:@"fraud_merchant_id"]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

// Test is failing because sandbox test merchant is configured with a Kount merchant ID that causes Kount to error.
- (void)pendCollectFraudDataWithCallback_returnsFraudData {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    self.dataCollector = [[BTDataCollector alloc] initWithAPIClient:apiClient];
    id delegate = OCMProtocolMock(@protocol(BTDataCollectorDelegate));
    self.dataCollector.delegate = delegate;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Delegate received completion callback"];
    OCMStub([delegate dataCollectorDidComplete:self.dataCollector]).andDo(^(__unused NSInvocation *invocation) {
        [expectation fulfill];
    });

    XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"Callback invoked"];
    [self.dataCollector collectFraudData:^(NSString * _Nonnull deviceData) {
        XCTAssertTrue([deviceData containsString:@"correlation_id"]);
        [callbackExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

// Test is failing because sandbox test merchant is configured with a Kount merchant ID that causes Kount to error.
- (void)pendCollectCardFraudDataWithCallback_returnsFraudDataWithNoPayPalFraudData {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    self.dataCollector = [[BTDataCollector alloc] initWithAPIClient:apiClient];

    id delegate = OCMProtocolMock(@protocol(BTDataCollectorDelegate));
    self.dataCollector.delegate = delegate;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Delegate received completion callback"];
    OCMStub([delegate dataCollectorDidComplete:self.dataCollector]).andDo(^(__unused NSInvocation *invocation) {
        [expectation fulfill];
    });

    XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"Callback invoked"];
    [self.dataCollector collectCardFraudData:^(NSString * _Nonnull deviceData) {
        XCTAssertNotNil(deviceData);
        XCTAssertFalse([deviceData containsString:@"correlation_id"]);
        [callbackExpectation fulfill];
    }];
    

    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testCollectCardFraudData_returnsFraudDataWithNoPayPalFraudData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.dataCollector collectCardFraudData:^(NSString * _Nonnull deviceData) {
        XCTAssertNotNil(deviceData);
        XCTAssertFalse([deviceData containsString:@"correlation_id"]);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

// Test is failing because Kount is no longer async and doesn't return errors
- (void)pendCollectCardFraudData_whenMerchantIDIsInvalid_invokesErrorCallback {
    [self.dataCollector setFraudMerchantId:@"-1"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Error callback invoked"];
    
    [self.dataCollector collectCardFraudData:^(NSString * _Nonnull deviceData) {
        NSLog(@"%@", deviceData);
        //XCTAssertEqualObjects(error.localizedDescription, @"Merchant ID formatted incorrectly.");
        //XCTAssertEqual(error.code, (NSInteger)KDataCollectorErrorCodeBadParameter);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testCollectPayPalClientMetadataId_returnsClientMetadataId {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.dataCollector collectFraudData:^(NSString * _Nonnull deviceData) {
        XCTAssertTrue([deviceData containsString:@"correlation_id"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
