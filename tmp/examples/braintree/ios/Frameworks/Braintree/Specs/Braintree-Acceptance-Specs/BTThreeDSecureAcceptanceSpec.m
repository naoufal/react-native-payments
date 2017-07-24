#import "BTThreeDSecureDriver.h"
#import "BTClient+Testing.h"

SpecBegin(BTThreeDSecure)

describe(@"verifyCardWithNonce:amount:", ^{
    __block BTClient *client;
    __block id<BTPaymentMethodCreationDelegate> delegate;
    __block NSString *nonce;

    beforeEach(^{
        waitUntil(^(DoneCallback done) {
            [BTClient testClientWithConfiguration:@{ BTClientTestConfigurationKeyMerchantIdentifier:@"integration_merchant_id",
                                                     BTClientTestConfigurationKeyPublicKey:@"integration_public_key",
                                                     BTClientTestConfigurationKeyCustomer:@YES,
                                                     BTClientTestConfigurationKeyClientTokenVersion: @2,
                                                     BTClientTestConfigurationKeyMerchantAccountIdentifier: @"three_d_secure_merchant_account", }
                                       async:YES
                                       completion:^(BTClient *aClient) {
                                           client = aClient;
                                           BTClientCardRequest *r = [[BTClientCardRequest alloc] init];
                                           r.number = @"4000000000000002";
                                           r.expirationMonth = @"12";
                                           r.expirationYear = @"2020";
                                           r.shouldValidate = NO;
                                           [client saveCardWithRequest:r
                                                               success:^(BTCardPaymentMethod *card) {
                                                                   nonce = card.nonce;
                                                                   done();
                                                               } failure:nil];
                                       }];
        });

        delegate = [OCMockObject mockForProtocol:@protocol(BTPaymentMethodCreationDelegate)];
    });

    describe(@"for a card that requires authentication", ^{
        it(@"returns the nonce on authentication completion", ^{
            BTThreeDSecureDriver *threeDSecure = [[BTThreeDSecureDriver alloc] initWithClient:client delegate:delegate];

            id delegateRequestPresentationExpectation = [(OCMockObject *)delegate expect];
            __block UIViewController *threeDSecureViewController;
            [delegateRequestPresentationExpectation andDo:^(NSInvocation *invocation) {
                [invocation retainArguments];
                [invocation getArgument:&threeDSecureViewController atIndex:3];
                [system presentViewController:threeDSecureViewController
withinNavigationControllerWithNavigationBarClass:nil
                                 toolbarClass:nil
                           configurationBlock:nil];
            }];
            [delegateRequestPresentationExpectation paymentMethodCreator:threeDSecure requestsPresentationOfViewController:[OCMArg isNotNil]];

            [threeDSecure verifyCardWithNonce:nonce amount:[NSDecimalNumber decimalNumberWithString:@"1"]];

            [(OCMockObject *)delegate verifyWithDelay:30];

            [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                KIFTestWaitCondition(threeDSecureViewController != nil, error, @"Did not present 3D Secure authentication flow");
                return KIFTestStepResultSuccess;
            }];

            [[(OCMockObject *)delegate expect] paymentMethodCreator:threeDSecure didCreatePaymentMethod:[OCMArg checkWithBlock:^BOOL(id obj) {
                waitUntil(^(DoneCallback done) {
                    BTPaymentMethod *paymentMethod = obj;
                    [client fetchNonceThreeDSecureVerificationInfo:paymentMethod.nonce
                                                           success:^(NSDictionary *nonceInfo) {
                                                               expect(nonceInfo[@"reportStatus"]).to.equal(@"authenticate_successful");
                                                               done();
                                                           } failure:nil];
                });
                return YES;
            }]];

            [[(OCMockObject *)delegate expect] paymentMethodCreator:threeDSecure requestsDismissalOfViewController:[OCMArg isNotNil]];

            [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
            [tester tapUIWebviewXPathElement:@"//input[@name=\"external.field.password\"]"];
            [tester waitForTimeInterval:1.5];
            [tester enterTextIntoCurrentFirstResponder:@"1234"];
            [tester tapViewWithAccessibilityLabel:@"Submit"];

            [(OCMockObject *)delegate verifyWithDelay:30];
        });
    });

    describe(@"for a issuer that is not enrolled", ^{
        __block NSString *unenrolledNonce;

        beforeEach(^{
            waitUntil(^(DoneCallback done) {
                BTClientCardRequest *r = [[BTClientCardRequest alloc] init];
                r.number = @"4000000000000051";
                r.expirationMonth = @"12";
                r.expirationYear = @"2020";
                r.shouldValidate = NO;
                [client saveCardWithRequest:r
                                    success:^(BTCardPaymentMethod *card) {
                                        unenrolledNonce = card.nonce;
                                        done();
                                    } failure:nil];
            });
        });

        it(@"returns a nonce without user authentication", ^{
            BTThreeDSecureDriver *threeDSecure = [[BTThreeDSecureDriver alloc] initWithClient:client delegate:delegate];

            [[(OCMockObject *)delegate expect] paymentMethodCreator:threeDSecure didCreatePaymentMethod:[OCMArg checkWithBlock:^BOOL(id obj) {
                return [obj isKindOfClass:[BTCardPaymentMethod class]];
            }]];

            [threeDSecure verifyCardWithNonce:unenrolledNonce
                                       amount:[NSDecimalNumber decimalNumberWithString:@"1"]];

            [(OCMockObject *)delegate verifyWithDelay:30];
        });
    });

    describe(@"for an unsupported card type", ^{
        __block NSString *unsupportedNonce;

        beforeEach(^{

            waitUntil(^(DoneCallback done) {
                BTClientCardRequest *r = [[BTClientCardRequest alloc] init];
                r.number = @"6011111111111117";
                r.expirationMonth = @"12";
                r.expirationYear = @"2020";
                r.shouldValidate = NO;
                [client saveCardWithRequest:r
                                    success:^(BTCardPaymentMethod *card) {
                                        unsupportedNonce = card.nonce;
                                        done();
                                    } failure:nil];

            });
        });

        it(@"returns a card with a new nonce and appropriate threeDSecureInfo", ^{
            BTThreeDSecureDriver *threeDSecure = [[BTThreeDSecureDriver alloc] initWithClient:client delegate:delegate];
            
            [[(OCMockObject *)delegate expect] paymentMethodCreator:threeDSecure
                                             didCreatePaymentMethod:[OCMArg checkWithBlock:^BOOL(id obj) {
                if (![obj isKindOfClass:[BTCardPaymentMethod class]]) {
                    return NO;
                }
                BTCardPaymentMethod *card = (BTCardPaymentMethod *)obj;
                if ([card.nonce isEqualToString:unsupportedNonce] || !card.nonce || [card.nonce isEqualToString:@""]) {
                    return NO;
                }
                if (card.threeDSecureInfo.liabilityShiftPossible || card.threeDSecureInfo.liabilityShifted) {
                    return NO;
                }
                return YES;
            }]];
            
            [threeDSecure verifyCardWithNonce:unsupportedNonce
                                       amount:[NSDecimalNumber decimalNumberWithString:@"1"]];
            
            [(OCMockObject *)delegate verifyWithDelay:30];
        });
    });

    describe(@"when the user taps cancel", ^{
        it(@"requests dismissal and notifies the delegate of cancelation", ^{
            BTThreeDSecureDriver *threeDSecure = [[BTThreeDSecureDriver alloc] initWithClient:client delegate:delegate];
            
            id delegateRequestPresentationExpectation = [(OCMockObject *)delegate expect];
            __block UIViewController *threeDSecureViewController;
            [delegateRequestPresentationExpectation andDo:^(NSInvocation *invocation) {
                [invocation retainArguments];
                [invocation getArgument:&threeDSecureViewController atIndex:3];
                [system presentViewController:threeDSecureViewController
    withinNavigationControllerWithNavigationBarClass:nil
                                 toolbarClass:nil
                           configurationBlock:nil];
            }];
            
            [delegateRequestPresentationExpectation paymentMethodCreator:threeDSecure requestsPresentationOfViewController:[OCMArg isNotNil]];
            
            [threeDSecure verifyCardWithNonce:nonce amount:[NSDecimalNumber decimalNumberWithString:@"1"]];
            
            [(OCMockObject *)delegate verifyWithDelay:10];
            
            [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                KIFTestWaitCondition(threeDSecureViewController != nil, error, @"Did not present 3D Secure authentication flow");
                return KIFTestStepResultSuccess;
            }];
            
            [[(OCMockObject *)delegate expect] paymentMethodCreator:threeDSecure requestsDismissalOfViewController:[OCMArg isNotNil]];
            [[(OCMockObject *)delegate expect] paymentMethodCreatorDidCancel:threeDSecure];
            
            [tester tapViewWithAccessibilityLabel:@"Cancel"];
            
            [(OCMockObject *)delegate verifyWithDelay:30];
        });
    });
});

SpecEnd
