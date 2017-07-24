#import <BraintreeUnionPay/BraintreeUnionPay.h>
#import "BTIntegrationTestsHelper.h"
#import <XCTest/XCTest.h>

@interface BraintreeUnionPay_IntegrationTests : XCTestCase
@property (nonatomic, strong) BTCardClient *cardClient;
@end

@implementation BraintreeUnionPay_IntegrationTests

- (void)setUp {
    [super setUp];

    static NSString *clientToken;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clientToken = [self fetchClientToken];
    });

    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
    self.cardClient = [[BTCardClient alloc] initWithAPIClient:apiClient];
}

- (void)pendFetchCapabilities_returnsCardCapabilities {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.cardClient fetchCapabilities:@"6212345678901232" completion:^(BTCardCapabilities * _Nullable cardCapabilities, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertFalse(cardCapabilities.isDebit);
        XCTAssertTrue(cardCapabilities.isUnionPay);
        XCTAssertTrue(cardCapabilities.isSupported);
        XCTAssertTrue(cardCapabilities.supportsTwoStepAuthAndCapture);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)pendEnrollCard_whenSuccessful_returnsEnrollmentID {
    BTCardRequest *request = [[BTCardRequest alloc] init];
    request.card = [[BTCard alloc] initWithNumber:@"6222821234560017" expirationMonth:@"12" expirationYear:@"2019" cvv:@"123"];
    request.mobileCountryCode = @"62";
    request.mobilePhoneNumber = @"12345678901";

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.cardClient enrollCard:request completion:^(NSString * _Nullable enrollmentID, __unused BOOL smsCodeRequired, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertTrue([enrollmentID isKindOfClass:[NSString class]]);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)pendEnrollCard_whenCardDoesNotRequireEnrollment_returnsError {
    BTCardRequest *request = [[BTCardRequest alloc] init];
    request.card = [[BTCard alloc] initWithNumber:@"6212345678900085" expirationMonth:@"12" expirationYear:@"2019" cvv:@"123"];
    request.mobileCountryCode = @"62";
    request.mobilePhoneNumber = @"12345678901";

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.cardClient enrollCard:request completion:^(NSString * _Nullable enrollmentID, __unused BOOL smsCodeRequired, NSError * _Nullable error) {
        XCTAssertNil(enrollmentID);
        XCTAssertEqualObjects(error.domain, BTCardClientErrorDomain);
        XCTAssertEqual(error.code, BTCardClientErrorTypeCustomerInputInvalid);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)pendTokenizeCard_withEnrolledUnionPayCard_isSuccessful {
    BTCardRequest *request = [[BTCardRequest alloc] init];
    request.card = [[BTCard alloc] initWithNumber:@"6212345678901232" expirationMonth:@"12" expirationYear:@"2019" cvv:@"123"];
    request.mobileCountryCode = @"62";
    request.mobilePhoneNumber = @"12345678901";

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.cardClient enrollCard:request completion:^(NSString * _Nullable enrollmentID, __unused BOOL smsCodeRequired, NSError * _Nullable error) {
        XCTAssertNil(error);
        request.enrollmentID = enrollmentID;
        request.smsCode = @"11111";
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.cardClient tokenizeCard:request options:nil completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertTrue([tokenizedCard.nonce isANonce]);
        XCTAssertEqual(tokenizedCard.cardNetwork, BTCardNetworkUnionPay);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark - Helpers

- (NSString *)fetchClientToken {
    NSURL *url = [NSURL URLWithString:@"http://braintree-sample-merchant.herokuapp.com/client_token?merchant_account_id=fake_switch_usd"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return jsonResponse[@"client_token"];
}

@end
