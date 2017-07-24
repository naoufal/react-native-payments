#import "BTIntegrationTestsHelper.h"
#import <BraintreeCore/BraintreeCore.h>
#import <BraintreeCard/BraintreeCard.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

@interface BTCardClient_IntegrationTests : XCTestCase
@end

@implementation BTCardClient_IntegrationTests

- (void)testTokenizeCard_whenCardHasValidationDisabledAndCardIsInvalid_tokenizesSuccessfully {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTCardClient *client = [[BTCardClient alloc] initWithAPIClient:apiClient];
    BTCard *card = [self invalidCard];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenize card"];
    [client tokenizeCard:card completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
        expect(tokenizedCard.nonce.isANonce).to.beTruthy();
        expect(error).to.beNil();
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testTokenizeCard_whenCardIsInvalidAndValidationIsEnabled_failsWithExpectedValidationError {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTCardClient *client = [[BTCardClient alloc] initWithAPIClient:apiClient];
    BTCard *card = [[BTCard alloc] initWithNumber:@"123" expirationMonth:@"12" expirationYear:@"2020" cvv:nil];
    card.shouldValidate = YES;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenize card"];
    [client tokenizeCard:card completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
        XCTAssertNil(tokenizedCard);
        XCTAssertEqualObjects(error.domain, BTCardClientErrorDomain);
        XCTAssertEqual(error.code, BTCardClientErrorTypeCustomerInputInvalid);
        XCTAssertEqualObjects(error.localizedDescription, @"Credit card is invalid");
        XCTAssertEqualObjects(error.localizedFailureReason, @"Credit card number must be 12-19 digits");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testTokenizeCard_whenCardHasValidationDisabledAndCardIsValid_tokenizesSuccessfully {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTCardClient *client = [[BTCardClient alloc] initWithAPIClient:apiClient];
    BTCard *card = [self validCard];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenize card"];
    [client tokenizeCard:card completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
        expect(tokenizedCard.nonce.isANonce).to.beTruthy();
        expect(error).to.beNil();
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}


- (void)testTokenizeCard_whenUsingTokenizationKeyAndCardHasValidationEnabled_failsWithAuthorizationError {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTCardClient *client = [[BTCardClient alloc] initWithAPIClient:apiClient];
    BTCard *card = [self invalidCard];
    card.shouldValidate = YES;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenize card"];
    [client tokenizeCard:card completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
        XCTAssertNil(tokenizedCard);
        expect(error.domain).to.equal(BTHTTPErrorDomain);
        expect(error.code).to.equal(BTHTTPErrorCodeClientError);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)error.userInfo[BTHTTPURLResponseKey];
        expect(httpResponse.statusCode).to.equal(403);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testTokenizeCard_whenUsingClientTokenAndCardHasValidationEnabledAndCardIsValid_tokenizesSuccessfully {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTCardClient *client = [[BTCardClient alloc] initWithAPIClient:apiClient];
    BTCard *card = [self validCard];
    card.shouldValidate = YES;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenize card"];
    [client tokenizeCard:card completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
        expect(tokenizedCard.nonce.isANonce).to.beTruthy();
        expect(error).to.beNil();
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testTokenizeCard_whenUsingVersionThreeClientTokenAndCardHasValidationEnabledAndCardIsValid_tokenizesSuccessfully {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN_VERSION_3];
    BTCardClient *client = [[BTCardClient alloc] initWithAPIClient:apiClient];
    BTCard *card = [self validCard];
    card.shouldValidate = YES;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenize card"];
    [client tokenizeCard:card completion:^(BTCardNonce * _Nullable tokenizedCard, NSError * _Nullable error) {
        expect(tokenizedCard.nonce.isANonce).to.beTruthy();
        expect(error).to.beNil();
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark - Helpers

- (BTCard *)invalidCard {
    BTCard *card = [[BTCard alloc] init];
    card.number = @"INVALID_CARD";
    card.expirationMonth = @"XX";
    card.expirationYear = @"YYYY";
    return card;
}

- (BTCard *)validCard {
    BTCard *card = [[BTCard alloc] init];
    card.number = @"4111111111111111";
    card.expirationMonth = @"12";
    card.expirationYear = @"2018";
    return card;
}

@end
