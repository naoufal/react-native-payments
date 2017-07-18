#import <XCTest/XCTest.h>
#import "BTCard_Internal.h"

// See also BTCard_Tests
@interface BTCard_Internal_Tests : XCTestCase

@end

@implementation BTCard_Internal_Tests

- (void)testParameters_standardProperties {
    BTCard *card = [[BTCard alloc] initWithNumber:@"4111111111111111"
                                  expirationMonth:@"12"
                                   expirationYear:@"2038"
                                              cvv:@"123"];
    BTJSON *parameters = [[BTJSON alloc] initWithValue:card.parameters];
    XCTAssertEqualObjects([parameters[@"number"] asString], @"4111111111111111");
    XCTAssertEqualObjects([parameters[@"expiration_date"] asString], @"12/2038");
    XCTAssertEqualObjects([parameters[@"cvv"] asString], @"123");
    XCTAssertTrue([parameters[@"options"][@"validate"] isFalse]);
}

- (void)testParameters_whenShouldValidateIsTrue_encodesParametersCorrectly {
    BTCard *card = [[BTCard alloc] init];
    card.shouldValidate = YES;
    BTJSON *parameters = [[BTJSON alloc] initWithValue:card.parameters];
    XCTAssertTrue([parameters[@"options"][@"validate"] isTrue]);
}

- (void)testParameters_whenShouldValidateIsTrueInParameters_encodesParametersCorrectly {
    BTCard *card = [[BTCard alloc] initWithParameters:@{@"options": @{@"validate": @YES}}];
    BTJSON *parameters = [[BTJSON alloc] initWithValue:card.parameters];
    XCTAssertTrue([parameters[@"options"][@"validate"] isTrue]);
}

- (void)testParameters_encodesAllParametersIncludingAdditionalParameters {
    BTCard *card =
    [[BTCard alloc] initWithParameters:@{}];

    card.number = @"4111111111111111";
    card.expirationMonth = @"12";
    card.expirationYear = @"2038";
    card.postalCode = @"40404";
    card.streetAddress = @"724 Evergreen Terrace";
    card.locality = @"some locality";
    card.region = @"some region";
    card.countryName = @"some country name";
    card.countryCodeAlpha2 = @"US";

    BTJSON *parameters = [[BTJSON alloc] initWithValue:card.parameters];
    XCTAssertEqualObjects([parameters[@"number"] asString], @"4111111111111111");
    XCTAssertEqualObjects([parameters[@"expiration_date"] asString], @"12/2038");
    XCTAssertEqualObjects([parameters[@"billing_address"][@"postal_code"] asString], @"40404");
    XCTAssertEqualObjects([parameters[@"billing_address"][@"street_address"] asString], @"724 Evergreen Terrace");
    XCTAssertEqualObjects([parameters[@"billing_address"][@"locality"] asString], @"some locality");
    XCTAssertEqualObjects([parameters[@"billing_address"][@"region"] asString], @"some region");
    XCTAssertEqualObjects([parameters[@"billing_address"][@"country_name"] asString], @"some country name");
    XCTAssertEqualObjects([parameters[@"billing_address"][@"country_code_alpha2"] asString], @"US");
}

@end
