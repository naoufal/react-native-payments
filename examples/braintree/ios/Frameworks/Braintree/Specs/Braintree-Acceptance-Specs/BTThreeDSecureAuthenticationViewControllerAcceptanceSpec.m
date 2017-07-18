#import "BTThreeDSecureAuthenticationViewController.h"
#import "BTClient+Testing.h"
#import "BTClient_Internal.h"

#import "KIFUITestActor+BTWebView.h"
#import "EXPMatchers+BTBeANonce.h"

#define TIME_TO_WAIT_FOR_KEYBOARD 1.5

@interface BTThreeDSecureAuthenticationViewController_AcceptanceSpecHelper : NSObject <BTThreeDSecureAuthenticationViewControllerDelegate>

@property (nonatomic, strong) BTClient *client;
@property (nonatomic, strong) BTThreeDSecureAuthenticationViewController *threeDSecureViewController;
@property (nonatomic, strong) BTThreeDSecureLookupResult *lookupResult;
@property (nonatomic, copy) NSString *originalNonce;

@property (nonatomic, copy) void (^authenticateBlock)(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, BTCardPaymentMethod *card, void (^completion)(BTThreeDSecureViewControllerCompletionStatus));
@property (nonatomic, copy) void (^finishBlock)(BTThreeDSecureAuthenticationViewController *threeDSecureViewController);
@property (nonatomic, copy) void (^failureBlock)(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, NSError *error);
@end

@implementation BTThreeDSecureAuthenticationViewController_AcceptanceSpecHelper

+ (instancetype)helper {
    BTThreeDSecureAuthenticationViewController_AcceptanceSpecHelper *helper = [[self alloc] init];
    waitUntil(^(DoneCallback done) {
        [BTClient testClientWithConfiguration:@{ BTClientTestConfigurationKeyMerchantIdentifier:@"integration_merchant_id",
                                                 BTClientTestConfigurationKeyPublicKey:@"integration_public_key",
                                                 BTClientTestConfigurationKeyCustomer:@YES,
                                                 BTClientTestConfigurationKeyClientTokenVersion: @2,
                                                 BTClientTestConfigurationKeyMerchantAccountIdentifier: @"three_d_secure_merchant_account", }
                                         async:YES
                                         completion:^(BTClient *client) {
                                             helper.client = client;
                                             done();
                                         }];
    });

    return helper;
}

- (void)lookupCard:(NSString *)number completion:(void (^)(BTThreeDSecureLookupResult *))completion {
    BTClientCardRequest *request = [[BTClientCardRequest alloc] init];
    request.number = number;
    request.expirationMonth = @"12";
    request.expirationYear = @"2020";
    request.shouldValidate = YES;

    [self.client saveCardWithRequest:request
                             success:^(BTPaymentMethod *card) {
                                 NSString *originalNonce = card.nonce;
                                 self.originalNonce = originalNonce;
                                 [self.client lookupNonceForThreeDSecure:originalNonce
                                                       transactionAmount:[NSDecimalNumber decimalNumberWithString:@"1"]
                                                                 success:^(BTThreeDSecureLookupResult *threeDSecureLookup) {
                                                                     completion(threeDSecureLookup);
                                                                 } failure:^(NSError *error) {
                                                                     completion(nil);
                                                                 }];
                             } failure:^(__unused NSError *error) {
                                 completion(nil);
                             }];
}

- (void)fetchThreeDSecureVerificationInfo:(NSString *)nonce completion:(void (^)(NSDictionary *response))completion {
    [self.client fetchNonceThreeDSecureVerificationInfo:nonce
                                                success:^(NSDictionary *threeDSecureVerificationInfo){
                                                    completion(threeDSecureVerificationInfo);
                                                } failure:^(__unused NSError *error){
                                                    completion(nil);
                                                }];
}

- (void)lookupNumber:(NSString *)number
               andDo:(void (^)(BTThreeDSecureAuthenticationViewController *threeDSecureViewController))testBlock
     didAuthenticate:(void (^)(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, BTCardPaymentMethod *card, void (^completion)(BTThreeDSecureViewControllerCompletionStatus)))authenticateBlock
             didFail:(void (^)(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, NSError *error))failureBlock
           didFinish:(void (^)(BTThreeDSecureAuthenticationViewController *threeDSecureViewController))finishBlock {

    waitUntil(^(DoneCallback done) {
        [self lookupCard:number
              completion:^(BTThreeDSecureLookupResult *threeDSecureLookup){
                  self.lookupResult = threeDSecureLookup;
                  done();
              }];
    });

    self.threeDSecureViewController = [[BTThreeDSecureAuthenticationViewController alloc] initWithLookupResult:self.lookupResult];

    self.authenticateBlock = authenticateBlock;
    self.finishBlock = finishBlock;
    self.failureBlock = failureBlock;

    self.threeDSecureViewController.delegate = self;

    if (testBlock) {
        testBlock(self.threeDSecureViewController);
    }
}

#pragma mark ThreeDSecureViewControllerDelegate

- (void)threeDSecureViewController:(BTThreeDSecureAuthenticationViewController *)viewController
               didAuthenticateCard:(BTCardPaymentMethod *)card
                        completion:(void (^)(BTThreeDSecureViewControllerCompletionStatus))completionBlock {
    if (self.authenticateBlock) {
        self.authenticateBlock(viewController, card, completionBlock);
    } else {
        [[NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:@"BTThreeDSecureViewController_AcceptanceSpecHelper received an unexpected call to threeDSecureViewController:didAuthenticateNonce:completion:"
                               userInfo:nil] raise];
    }
}

- (void)threeDSecureViewController:(BTThreeDSecureAuthenticationViewController *)viewController didFailWithError:(NSError *)error {
    if (self.failureBlock) {
        self.failureBlock(viewController, error);
    } else {
        [[NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:@"BTThreeDSecureViewController_AcceptanceSpecHelper received an unexpected call to threeDSecureViewController:didFailWithError:"
                               userInfo:nil] raise];
    }
}

- (void)threeDSecureViewControllerDidFinish:(BTThreeDSecureAuthenticationViewController *)viewController {
    if (self.finishBlock) {
        self.finishBlock(viewController);
    } else {
        [[NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:@"BTThreeDSecureViewController_AcceptanceSpecHelper received an unexpected call to threeDSecureViewControllerDidFinish:"
                               userInfo:nil] raise];
    }
}

- (void)lookupHappyPathAndDo:(void (^)(BTThreeDSecureAuthenticationViewController *threeDSecureViewController))completion {
    [self lookupNumber:@"4000000000000002" andDo:completion didAuthenticate:nil didFail:nil didFinish:nil];
}

@end

SpecBegin(BTThreeDSecureAuthenticationViewController_Acceptance)

describe(@"3D Secure View Controller", ^{
    __block BTThreeDSecureAuthenticationViewController_AcceptanceSpecHelper *helper;
    beforeEach(^{
        helper = [BTThreeDSecureAuthenticationViewController_AcceptanceSpecHelper helper];
    });

    describe(@"developer perspective - delegate messages", ^{
        it(@"fails to load a view controller when lookup fails", ^{
            BTThreeDSecureLookupResult *lookupResult = nil;
            BTThreeDSecureAuthenticationViewController *threeDSecureViewController = [[BTThreeDSecureAuthenticationViewController alloc] initWithLookupResult:lookupResult];

            expect(threeDSecureViewController).to.beNil();
        });

        it(@"fails to load a view controller when lookup does not require a user flow", ^{
            BTThreeDSecureLookupResult *lookupResult = [[BTThreeDSecureLookupResult alloc] init];
            BTThreeDSecureAuthenticationViewController *threeDSecureViewController = [[BTThreeDSecureAuthenticationViewController alloc] initWithLookupResult:lookupResult];

            expect(lookupResult.requiresUserAuthentication).to.beFalsy();
            expect(threeDSecureViewController).to.beNil();
        });

        it(@"calls didAuthenticate with the upgraded nonce (consuming the original nonce)", ^{
            __block BOOL calledDidAuthenticate = NO;
            [helper lookupNumber:@"4000000000000002"
                           andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                               [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                               [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
                               [tester tapUIWebviewXPathElement:@"//input[@name=\"external.field.password\"]"];
                               [tester waitForTimeInterval:TIME_TO_WAIT_FOR_KEYBOARD];

                               [tester enterTextIntoCurrentFirstResponder:@"1234"];
                               [tester tapViewWithAccessibilityLabel:@"Submit"];
                           } didAuthenticate:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, BTCardPaymentMethod *card, void (^completion)(BTThreeDSecureViewControllerCompletionStatus)) {
                               calledDidAuthenticate = YES;
                               expect(card.nonce).to.beANonce();
                           } didFail:nil
                       didFinish:nil];

            [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                KIFTestWaitCondition(calledDidAuthenticate, error, @"Did not call didAuthenticate");
                return KIFTestStepResultSuccess;
            }];
        });

        it(@"calls didFinish after didAuthenticate calls its completion with success", ^{
            __block BOOL calledDidAuthenticate = NO;
            __block BOOL calledDidFinish = NO;
            [helper lookupNumber:@"4000000000000002"
                           andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                               [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                               [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
                               [tester tapUIWebviewXPathElement:@"//input[@name=\"external.field.password\"]"];
                               [tester waitForTimeInterval:TIME_TO_WAIT_FOR_KEYBOARD];

                               [tester enterTextIntoCurrentFirstResponder:@"1234"];
                               [tester tapViewWithAccessibilityLabel:@"Submit"];
                           } didAuthenticate:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, BTCardPaymentMethod *card, void (^completion)(BTThreeDSecureViewControllerCompletionStatus)) {
                               calledDidAuthenticate = YES;
                               expect(calledDidFinish).to.beFalsy();
                               completion(BTThreeDSecureViewControllerCompletionStatusSuccess);
                           } didFail:nil
                       didFinish:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                           calledDidFinish = YES;
                           expect(calledDidAuthenticate).to.beTruthy();
                       }];

            [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                KIFTestWaitCondition(calledDidAuthenticate, error, @"Did not call didAuthenticate");
                KIFTestWaitCondition(calledDidFinish, error, @"Did not call didFinish");
                return KIFTestStepResultSuccess;
            }];
        });

        it(@"calls didFail when authentication fails (leaving the original nonce transactable)", ^{
            __block BOOL calledDidFail = NO;
            __block BOOL calledDidFinish = NO;

            [helper lookupNumber:@"4000000000000010"
                           andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                               [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                               [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
                               [tester tapUIWebviewXPathElement:@"//input[@name=\"external.field.password\"]"];
                               [tester waitForTimeInterval:TIME_TO_WAIT_FOR_KEYBOARD];

                               [tester enterTextIntoCurrentFirstResponder:@"1234"];
                               [tester tapViewWithAccessibilityLabel:@"Submit"];
                           } didAuthenticate:nil
                         didFail:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, NSError *error) {
                             expect(error.domain).to.equal(BTThreeDSecureErrorDomain);
                             expect(error.code).to.equal(BTThreeDSecureFailedAuthenticationErrorCode);
                             expect(error.localizedDescription).to.equal(@"Failed to authenticate, please try a different form of payment");
                             expect(error.userInfo[BTThreeDSecureInfoKey]).to.equal(@{ @"liabilityShifted": @NO, @"liabilityShiftPossible": @YES, });
                             calledDidFail = YES;
                         }
                       didFinish:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                           expect(calledDidFail).to.beTruthy();
                           calledDidFinish = YES;
                       }];

            [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                KIFTestWaitCondition(calledDidFail, error, @"Did not call didFail");
                KIFTestWaitCondition(calledDidFinish, error, @"Did not call didFinish");
                return KIFTestStepResultSuccess;
            }];
        });
    });

    describe(@"user flows - 3DS Statuses (enrolled, authenticated, signature verified)", ^{
        context(@"cardholder enrolled, successful authentication, successful signature verification - Y,Y,Y", ^{
            it(@"successfully authenticates a user when they enter their password", ^{
                __block BOOL checkedNonce = NO;
                [helper lookupNumber:@"4000000000000002"
                               andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                   [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                                   [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
                                   [tester tapUIWebviewXPathElement:@"//input[@name=\"external.field.password\"]"];
                                   [tester waitForTimeInterval:TIME_TO_WAIT_FOR_KEYBOARD];

                                   [tester enterTextIntoCurrentFirstResponder:@"1234"];
                                   [tester tapViewWithAccessibilityLabel:@"Submit"];
                               } didAuthenticate:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, BTCardPaymentMethod *card, void (^completion)(BTThreeDSecureViewControllerCompletionStatus)) {
                                   [helper fetchThreeDSecureVerificationInfo:card.nonce
                                                                  completion:^(NSDictionary *response) {
                                                                      expect(response[@"reportStatus"]).to.equal(@"authenticate_successful");
                                                                      checkedNonce = YES;
                                                                  }];
                               } didFail:nil
                           didFinish:nil];

                [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                    KIFTestWaitCondition(checkedNonce, error, @"Did not check nonce");
                    return KIFTestStepResultSuccess;
                }];
            });
        });

        context(@"issuer not enrolled - N", ^{
            it(@"bypasses the entire authentication experience", ^{
                [helper lookupNumber:@"4000000000000051"
                               andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                   expect(threeDSecureViewController).to.beNil();
                               } didAuthenticate:nil didFail:nil didFinish:nil];
            });
        });

        context(@"simulated cardinal error on lookup - error", ^{
            it(@"bypasses the entire authentication experience", ^{
                [helper lookupNumber:@"4000000000000077"
                               andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                   expect(threeDSecureViewController).to.beNil();
                               } didAuthenticate:nil
                             didFail:nil
                           didFinish:nil];
            });
        });

        context(@"User enters incorrect password - Y,N,Y", ^{
            it(@"it presents the failure to the user and fails to authenticate the nonce", ^{
                __block BOOL calledDidFail;
                __block BOOL calledDidFinish;

                [helper lookupNumber:@"4000000000000028"
                               andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {

                                   [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];


                                   [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
                                   [tester tapUIWebviewXPathElement:@"//input[@name=\"external.field.password\"]"];
                                   [tester enterTextIntoCurrentFirstResponder:@"bad"];
                                   [tester tapViewWithAccessibilityLabel:@"Submit"];
                                   [tester waitForViewWithAccessibilityLabel:@"Account Authentication Blocked"];
                                   [tester tapViewWithAccessibilityLabel:@"Continue"];
                               } didAuthenticate:nil
                             didFail:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, NSError *error) {
                                 expect(error.domain).to.equal(BTThreeDSecureErrorDomain);
                                 expect(error.code).to.equal(BTThreeDSecureFailedAuthenticationErrorCode);
                                 expect(error.localizedDescription).to.equal(@"Failed to authenticate, please try a different form of payment");
                                 expect(error.userInfo[BTThreeDSecureInfoKey]).to.equal(@{ @"liabilityShifted": @NO, @"liabilityShiftPossible": @YES});
                                 calledDidFail = YES;
                             } didFinish:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                 calledDidFinish = YES;
                             }];

                [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                    KIFTestWaitCondition(calledDidFail, error, @"Did not call didFail");
                    KIFTestWaitCondition(calledDidFinish, error, @"Did not call didFinish");
                    return KIFTestStepResultSuccess;
                }];
            });
        });

        context(@"User attempted to enter a password - Y,A,Y", ^{
            it(@"displays a loading indication to the user and successfully authenticates the nonce", ^{
                __block BOOL checkedNonce;

                [helper lookupNumber:@"4000000000000101"
                               andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                   [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];
                               } didAuthenticate:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, BTCardPaymentMethod *card, void (^completion)(BTThreeDSecureViewControllerCompletionStatus status)) {
                                   [helper fetchThreeDSecureVerificationInfo:card.nonce
                                                                  completion:^(NSDictionary *response) {
                                                                      expect(response[@"reportStatus"]).to.equal(@"authenticate_attempt_successful");
                                                                      checkedNonce = YES;
                                                                  }];
                               } didFail:nil
                           didFinish:nil];

                [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                    KIFTestWaitCondition(checkedNonce, error, @"Did not check nonce");
                    return KIFTestStepResultSuccess;
                }];
            });
        });

        context(@"Signature verification fails - Y,Y,N", ^{
            it(@"accepts a password but resuts in an failed verification", ^{
                __block BOOL calledDidFail = NO;
                __block BOOL calledDidFinish = NO;

                [helper lookupNumber:@"4000000000000010"
                               andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                   [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                                   [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
                                   [tester tapUIWebviewXPathElement:@"//input[@name=\"external.field.password\"]"];
                                   [tester waitForTimeInterval:TIME_TO_WAIT_FOR_KEYBOARD];

                                   [tester enterTextIntoCurrentFirstResponder:@"1234"];
                                   [tester tapViewWithAccessibilityLabel:@"Submit"];
                               } didAuthenticate:nil
                             didFail:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, NSError *error) {
                                 expect(error.domain).to.equal(BTThreeDSecureErrorDomain);
                                 expect(error.code).to.equal(BTThreeDSecureFailedAuthenticationErrorCode);
                                 expect(error.localizedDescription).to.equal(@"Failed to authenticate, please try a different form of payment");
                                 expect(error.userInfo[BTThreeDSecureInfoKey]).to.equal(@{ @"liabilityShifted": @NO, @"liabilityShiftPossible": @YES, });
                                 calledDidFail = YES;
                             }
                           didFinish:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                               calledDidFinish = YES;
                           }];

                [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                    KIFTestWaitCondition(calledDidFail, error, @"Did not call didFail");
                    KIFTestWaitCondition(calledDidFinish, error, @"Did not call didFinish");
                    return KIFTestStepResultSuccess;
                }];
            });
        });

        context(@"issuer is down - Y,U", ^{
            it(@"returns a nonce without asking user for authentication", ^{
                __block BOOL calledDidFail = NO;
                __block BOOL calledDidFinish = NO;

                [helper lookupNumber:@"4000000000000036"
                               andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                   [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                                   [tester waitForViewWithAccessibilityLabel:@"System Error" traits:UIAccessibilityTraitStaticText];
                                   [tester tapViewWithAccessibilityLabel:@"Continue"];
                               } didAuthenticate:nil
                             didFail:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, NSError *error) {
                                 calledDidFail = YES;
                                 
                                 expect(error.domain).to.equal(BTThreeDSecureErrorDomain);
                                 expect(error.code).to.equal(BTThreeDSecureFailedAuthenticationErrorCode);
                                 expect(error.userInfo[BTThreeDSecureInfoKey]).to.equal(@{ @"liabilityShifted": @NO, @"liabilityShiftPossible": @YES, });
                             } didFinish:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                 expect(calledDidFail).to.beTruthy();
                                 calledDidFinish = YES;
                             }];

                [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                    KIFTestWaitCondition(calledDidFail, error, @"Did not call didFail");
                    KIFTestWaitCondition(calledDidFinish, error, @"Did not call didFinish");
                    return KIFTestStepResultSuccess;
                }];
            });
        });

        context(@"Early termination due to cardinal error - Y, Error", ^{
            it(@"accepts a password but fails to authenticate the nonce", ^{
                __block BOOL calledDidFail = NO;
                __block BOOL calledDidFinish = NO;

                [helper lookupNumber:@"4000000000000093"
                               andDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                   [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                                   [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
                                   [tester tapUIWebviewXPathElement:@"//input[@name=\"external.field.password\"]"];
                                   [tester waitForTimeInterval:TIME_TO_WAIT_FOR_KEYBOARD];

                                   [tester enterTextIntoCurrentFirstResponder:@"1234"];
                                   [tester tapViewWithAccessibilityLabel:@"Submit"];
                               } didAuthenticate:nil
                             didFail:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController, NSError *error) {
                                 calledDidFail = YES;
                                 expect(error.domain).to.equal(BTThreeDSecureErrorDomain);
                                 expect(error.code).to.equal(BTThreeDSecureFailedAuthenticationErrorCode);
                                 expect(error.userInfo[BTThreeDSecureInfoKey]).to.equal(@{ @"liabilityShiftPossible": @YES, @"liabilityShifted": @NO, });
                             } didFinish:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                                 calledDidFinish = YES;
                                 expect(calledDidFail).to.beTruthy();
                             }];

                [system runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
                    KIFTestWaitCondition(calledDidFail, error, @"Did not call didFail");
                    KIFTestWaitCondition(calledDidFinish, error, @"Did not call didFinish");
                    return KIFTestStepResultSuccess;
                }];
            });
        });

        context(@"The ACS Frame fails to load", ^{
            it(@"accepts a password but fails to authenticate the nonce", ^{
                id<OHHTTPStubsDescriptor> stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.host isEqualToString:@"acs.example.com"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain code:123 userInfo:@{ NSLocalizedDescriptionKey: @"Something bad happened" }]];
                }];

                BTThreeDSecureLookupResult *lookupResult = [[BTThreeDSecureLookupResult alloc] init];
                lookupResult.acsURL = [NSURL URLWithString:@"https://acs.example.com/"];
                lookupResult.PAReq = @"pareq";
                lookupResult.termURL = [NSURL URLWithString:@"https://example.com/term"];
                lookupResult.MD = @"md";

                BTThreeDSecureAuthenticationViewController *threeDSecureViewController = [[BTThreeDSecureAuthenticationViewController alloc] initWithLookupResult:lookupResult];

                [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                [tester waitForViewWithAccessibilityLabel:@"Something bad happened"];
                [tester tapViewWithAccessibilityLabel:@"OK"];
                [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Something bad happened"];

                [OHHTTPStubs removeStub:stub];
            });
        });
    });

    describe(@"web view interaction details", ^{
        xit(@"displays a loading indicator during page loads", ^{
            [helper lookupHappyPathAndDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                [system waitForApplicationToSetNetworkActivityIndicatorVisible:YES];
                [system waitForApplicationToSetNetworkActivityIndicatorVisible:NO];
                [system waitForTimeInterval:1];
                [tester tapViewWithAccessibilityLabel:@"Submit"];
                [system waitForApplicationToSetNetworkActivityIndicatorVisible:YES];
                [system waitForTimeInterval:1];
                [tester waitForViewWithAccessibilityLabel:@"Incorrect, Please try again"];
                [system waitForApplicationToSetNetworkActivityIndicatorVisible:NO];
            }];
        });

        it(@"closes the popup when the user taps Cancel in the nav bar", ^{
            [helper lookupHappyPathAndDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                [tester tapViewWithAccessibilityLabel:@"Help"];
                [tester waitForViewWithAccessibilityLabel:@"Social Security Number"];
                [tester tapViewWithAccessibilityLabel:@"Cancel"];

                [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
            }];
        });
        
        it(@"closes the popup when the user taps a close link", ^{
            [helper lookupHappyPathAndDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];
                
                [tester tapViewWithAccessibilityLabel:@"Help"];
                [tester waitForViewWithAccessibilityLabel:@"Social Security Number"];
                [tester tapUIWebviewXPathElement:@"//a[text()=\"Social Security Number\"]"];
                [tester tapUIWebviewXPathElement:@"(//a[contains(text(), \"Return\")])[last()]"];

                [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];
            }];
        });

        it(@"uses the html title tag for the view controllers title", ^{
            [helper lookupHappyPathAndDo:^(BTThreeDSecureAuthenticationViewController *threeDSecureViewController) {
                [system presentViewController:threeDSecureViewController withinNavigationControllerWithNavigationBarClass:nil toolbarClass:nil configurationBlock:nil];

                [tester waitForViewWithAccessibilityLabel:@"Please submit your Verified by Visa password." traits:UIAccessibilityTraitStaticText];

                expect(threeDSecureViewController.title).to.equal(@"Authentication");
            }];
        });
    });
});

SpecEnd
