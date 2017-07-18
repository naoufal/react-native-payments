#import "BTDropInErrorState.h"
#import "BTErrors.h"
#import "BTUICardFormView.h"

SpecBegin(BTDropInErrorState)

describe(@"errorTitle", ^{
    it(@"returns an error title based on the NSError's top level error message", ^{
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
        NSError *error = [[NSError alloc] initWithDomain:BTBraintreeAPIErrorDomain
                                                    code:BTCustomerInputErrorInvalid
                                                userInfo:userInfo];
        BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];
        expect(state.errorTitle).to.equal(@"Credit Card is Invalid");
    });

    it(@"returns an error title based on the NSError's top level error message, even when there are no field errors associated", ^{
        NSDictionary *validationErrors = @{ @"error": @{ @"message": @"Everything is Invalid" } };




        NSDictionary *userInfo = @{BTCustomerInputBraintreeValidationErrorsKey: validationErrors};
        NSError *error = [[NSError alloc] initWithDomain:BTBraintreeAPIErrorDomain
                                                    code:BTCustomerInputErrorInvalid
                                                userInfo:userInfo];
        BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];
        expect(state.errorTitle).to.equal(@"Everything is Invalid");
    });
});

describe(@"highlighted fields", ^{
    it(@"returns a set of fields with validation errors associated", ^{
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
        NSError *error = [[NSError alloc] initWithDomain:BTBraintreeAPIErrorDomain
                                                    code:BTCustomerInputErrorInvalid
                                                userInfo:userInfo];
        BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];
        expect(state.highlightedFields).to.haveCountOf(4);
        expect(state.highlightedFields).to.contain(BTUICardFormFieldNumber);\
        expect(state.highlightedFields).to.contain(BTUICardFormFieldExpiration);
        expect(state.highlightedFields).to.contain(BTUICardFormFieldCvv);
        expect(state.highlightedFields).to.contain(BTUICardFormFieldPostalCode);
    });

    it(@"returns the empty set when no fields needs to be highlighted", ^{
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
        NSError *error = [[NSError alloc] initWithDomain:BTBraintreeAPIErrorDomain
                                                    code:BTCustomerInputErrorInvalid
                                                userInfo:userInfo];
        BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];
        expect(state.highlightedFields).to.haveCountOf(0);
    });

    it(@"ignores unknown fields", ^{
        NSDictionary *validationErrors = @{@"error": @{ @"message": @"Everything is invalid" } };

        NSDictionary *userInfo = @{BTCustomerInputBraintreeValidationErrorsKey: validationErrors};
        NSError *error = [[NSError alloc] initWithDomain:BTBraintreeAPIErrorDomain
                                                    code:BTCustomerInputErrorInvalid
                                                userInfo:userInfo];
        BTDropInErrorState *state = [[BTDropInErrorState alloc] initWithError:error];
        expect(state.highlightedFields).to.haveCountOf(0);
    });

});

SpecEnd
