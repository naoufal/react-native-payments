#import <XCTest/XCTest.h>
#import "BTHTTP.h"
#import "BTDropInErrorState.h"
#import "BTErrors.h"
#import "BTUICardFormView.h"

@interface BTDropInErrorState_Tests : XCTestCase

@end

@implementation BTDropInErrorState_Tests

- (void)testErrorTitle_returnsErrorTitleBasedOnNSErrorTopLevelErrorMessage {
    NSDictionary *validationErrors = @{@"error": @{
                                               @"message": @"Credit Card is Invalid" },
                                       @"fieldErrors": @[
                                               @{
                                                   @"field": @"creditCard",
                                                   @"fieldErrors": @[
                                                           @{
                                                               @"field": @"cvv",
                                                               @"message": @"CVV is required" }
                                                           ]
                                                   }]};

    NSDictionary *userInfo = @{BTCustomerInputBraintreeValidationErrorsKey: validationErrors};
    NSError *error = [[NSError alloc] initWithDomain:BTHTTPErrorDomain
                                                code:BTHTTPErrorCodeClientError
                                            userInfo:userInfo];
    BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];
    XCTAssertEqualObjects(state.errorTitle, @"Credit Card is Invalid");
}

- (void)testErrorTitle_whenThereAreNoFieldErrorsAssociated_returnsErrorTitleBasedOnNSErrorTopLevelErrorMessage {
    NSDictionary *validationErrors = @{ @"error": @{ @"message": @"Everything is Invalid" } };
    NSDictionary *userInfo = @{BTCustomerInputBraintreeValidationErrorsKey: validationErrors};
    NSError *error = [[NSError alloc] initWithDomain:BTHTTPErrorDomain
                                                code:BTHTTPErrorCodeClientError
                                            userInfo:userInfo];

    BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];
    XCTAssertEqualObjects(state.errorTitle, @"Everything is Invalid");
}

- (void)testHighlightedFields_whenErrorUserInfoHasFieldErrors_returnsSetOfFieldsWithValidationErrorsAssociated {
    NSDictionary *validationErrors = @{@"error": @{
                                               @"message": @"Credit Card is Invalid" },
                                       @"fieldErrors": @[
                                               @{
                                                   @"field": @"creditCard",
                                                   @"fieldErrors": @[
                                                           @{ @"field": @"cvv",
                                                              @"message": @"CVV is required" },
                                                           @{ @"field": @"billingAddress",
                                                              @"fieldErrors": @[@{ @"field": @"postalCode",
                                                                                   @"message": @"Postal Code is required" }],
                                                              },
                                                           @{ @"field": @"number",
                                                              @"message": @"Number is required" },
                                                           @{ @"field": @"expirationDate",
                                                              @"message": @"Expiration date is required" },
                                                           ]
                                                   }]};

    NSDictionary *userInfo = @{BTCustomerInputBraintreeValidationErrorsKey: validationErrors};
    NSError *error = [[NSError alloc] initWithDomain:BTHTTPErrorDomain
                                                code:BTHTTPErrorCodeClientError
                                            userInfo:userInfo];

    BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];

    XCTAssertTrue(state.highlightedFields.count == 4);
    XCTAssertTrue([state.highlightedFields containsObject:@(BTUICardFormFieldNumber)]);
    XCTAssertTrue([state.highlightedFields containsObject:@(BTUICardFormFieldExpiration)]);
    XCTAssertTrue([state.highlightedFields containsObject:@(BTUICardFormFieldCvv)]);
    XCTAssertTrue([state.highlightedFields containsObject:@(BTUICardFormFieldPostalCode)]);
}

- (void)testHighlightedFields_whenErrorUserInfoHasNoFieldErrors_returnsEmptySet {
    NSDictionary *validationErrors = @{@"error": @{
                                               @"message": @"Credit Card is Invalid" },
                                       @"fieldErrors": @[
                                               @{
                                                   @"field": @"creditCard",
                                                   @"fieldErrors": @[
                                                           @{ @"field": @"paymentMethodNonce",
                                                              @"message": @"Payment method nonces cannot be used to update an existing card." },
                                                           ]
                                                   }]};
    NSDictionary *userInfo = @{BTCustomerInputBraintreeValidationErrorsKey: validationErrors};
    NSError *error = [[NSError alloc] initWithDomain:BTHTTPErrorDomain
                                                code:BTHTTPErrorCodeClientError
                                            userInfo:userInfo];

    BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];

    XCTAssertTrue(state.highlightedFields.count == 0);
}

- (void)testHighlightedFields_whenErrorContainsUnknownFields_ignoresThem {
    NSDictionary *validationErrors = @{@"error": @{ @"message": @"Everything is invalid" },
                                       @"fieldErrors": @[
                                               @{
                                                 @"field": @"creditCard",
                                                 @"fieldErrors": @[
                                                         @{ @"field": @"unknownField",
                                                            @"message": @"You can't highlight what you can't understand!" },
                                                         ]
                                                 }]
                                       };

    NSDictionary *userInfo = @{BTCustomerInputBraintreeValidationErrorsKey: validationErrors};
    NSError *error = [[NSError alloc] initWithDomain:BTHTTPErrorDomain
                                                code:BTHTTPErrorCodeClientError
                                            userInfo:userInfo];

    BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];

    XCTAssertTrue(state.highlightedFields.count == 0);
}

@end
