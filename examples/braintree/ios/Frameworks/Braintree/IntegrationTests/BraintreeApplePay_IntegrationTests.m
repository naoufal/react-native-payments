#import <BraintreeApplePay/BraintreeApplePay.h>
#import "BTIntegrationTestsHelper.h"
#import <PassKit/PassKit.h>
#import <XCTest/XCTest.h>

@interface BraintreeApplePay_IntegrationTests : XCTestCase

@end

@implementation BraintreeApplePay_IntegrationTests

- (void)testTokenizeApplePayPayment_whenApplePayEnabledInControlPanel_returnsANonce {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTApplePayClient *client = [[BTApplePayClient alloc] initWithAPIClient:apiClient];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenize Apple Pay payment"];
    [client tokenizeApplePayPayment:[[PKPayment alloc] init]
                         completion:^(BTApplePayCardNonce * _Nullable tokenizedApplePayPayment, NSError * _Nullable error) {
        XCTAssertTrue(tokenizedApplePayPayment.nonce.isANonce);
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testTokenizeApplePayPayment_whenApplePayDisabledInControlPanel_returnsError {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY_APPLE_PAY_DISABLED];
    BTApplePayClient *client = [[BTApplePayClient alloc] initWithAPIClient:apiClient];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenize Apple Pay payment"];
    [client tokenizeApplePayPayment:[[PKPayment alloc] init]
                         completion:^(BTApplePayCardNonce * _Nullable tokenizedApplePayPayment, NSError * _Nullable error) {
        XCTAssertEqualObjects(error.domain, BTApplePayErrorDomain);
        XCTAssertEqual(error.code, BTApplePayErrorTypeUnsupported);
        XCTAssertNil(tokenizedApplePayPayment);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
