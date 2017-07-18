#import <BraintreeCore/BTAPIClient_Internal.h>
#import <BraintreePayPal/BraintreePayPal.h>
#import <BraintreePayPal/BTPayPalDriver_Internal.h>
#import "BTIntegrationTestsHelper.h"
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

@interface BTAppSwitchTestDelegate : NSObject <BTAppSwitchDelegate>
@property (nonatomic, strong) XCTestExpectation *willPerform;
@property (nonatomic, strong) XCTestExpectation *didPerform;
@property (nonatomic, strong) XCTestExpectation *willProcess;
@property (nonatomic, strong) id lastAppSwitcher;
@property (nonatomic, assign) BTAppSwitchTarget lastTarget;
@end

@implementation BTAppSwitchTestDelegate

- (void)appSwitcherWillPerformAppSwitch:(id)appSwitcher {
    self.lastAppSwitcher = appSwitcher;
    [self.willPerform fulfill];
}

- (void)appSwitcher:(id)appSwitcher didPerformSwitchToTarget:(BTAppSwitchTarget)target {
    self.lastTarget = target;
    self.lastAppSwitcher = appSwitcher;
    [self.didPerform fulfill];
}

- (void)appSwitcherWillProcessPaymentInfo:(id)appSwitcher {
    self.lastAppSwitcher = appSwitcher;
    [self.willProcess fulfill];
}

@end

@interface BTViewControllerPresentingTestDelegate : NSObject <BTViewControllerPresentingDelegate>
@property (nonatomic, strong) XCTestExpectation *requestsPresentationExpectation;
@property (nonatomic, strong) XCTestExpectation *requestsDismissalExpectation;
@property (nonatomic, strong) id lastDriver;
@property (nonatomic, strong) id lastViewController;
@end

@implementation BTViewControllerPresentingTestDelegate

- (void)paymentDriver:(id)driver requestsDismissalOfViewController:(UIViewController *)viewController {
    self.lastDriver = driver;
    self.lastViewController = viewController;
    [self.requestsDismissalExpectation fulfill];
}

- (void)paymentDriver:(id)driver requestsPresentationOfViewController:(UIViewController *)viewController {
    self.lastDriver = driver;
    self.lastViewController = viewController;
    [self.requestsPresentationExpectation fulfill];
}

@end

@interface BTPayPalApprovalHandlerTestDelegate : NSObject <BTPayPalApprovalHandler>
@property (nonatomic, strong) XCTestExpectation *handleApprovalExpectation;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) BOOL cancel;
@end

@implementation BTPayPalApprovalHandlerTestDelegate

- (void)handleApproval:(__unused PPOTRequest *)request paypalApprovalDelegate:(id<BTPayPalApprovalDelegate>)delegate {
    if (self.cancel) {
        [delegate onApprovalCancel];
    } else {
        [delegate onApprovalComplete:self.url];
    }
    [self.handleApprovalExpectation fulfill];
}

@end


@interface BraintreePayPal_IntegrationTests : XCTestCase
@property (nonatomic, strong) NSNumber *didReceiveCompletionCallback;
// We keep a reference to these stub delegates so they don't get released!
@property (nonatomic, strong) BTViewControllerPresentingTestDelegate *viewControllerPresentingDelegate;
@property (nonatomic, strong) BTAppSwitchTestDelegate *appSwitchDelegate;

@end


@implementation BraintreePayPal_IntegrationTests

NSString * const OneTouchCoreAppSwitchSuccessURLFixture = @"com.braintreepayments.Demo.payments://onetouch/v1/success?payload=eyJ2ZXJzaW9uIjoyLCJhY2NvdW50X2NvdW50cnkiOiJVUyIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXhwaXJlc19pbiI6LTEsImRpc3BsYXlfbmFtZSI6Im1vY2tEaXNwbGF5TmFtZSIsInNjb3BlIjoiaHR0cHM6XC9cL3VyaS5wYXlwYWwuY29tXC9zZXJ2aWNlc1wvcGF5bWVudHNcL2Z1dHVyZXBheW1lbnRzIiwiZW1haWwiOiJtb2NrZW1haWxhZGRyZXNzQG1vY2suY29tIiwiYXV0aG9yaXphdGlvbl9jb2RlIjoibW9ja1RoaXJkUGFydHlBdXRob3JpemF0aW9uQ29kZSJ9&x-source=com.paypal.ppclient.touch.v1-or-v2";

#pragma mark - Authorization (Future Payments)

- (void)testFuturePayments_withTokenizationKey_tokenizesPayPalAccount {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    payPalDriver.clientMetadataId = @"fake-client-metadata-id";

    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenized PayPal Account"];
    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        XCTAssertTrue(tokenizedPayPalAccount.nonce.isANonce);
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture]];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFuturePayments_withClientToken_tokenizesPayPalAccount {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    id stubDelegate = [[BTViewControllerPresentingTestDelegate alloc] init];
    payPalDriver.viewControllerPresentingDelegate = stubDelegate;
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    XCTestExpectation *expectation = [self expectationWithDescription:@"Tokenized PayPal Account"];
    [payPalDriver authorizeAccountWithAdditionalScopes:[NSSet set] forceFuturePaymentFlow:YES completion:^(BTPayPalAccountNonce * _Nonnull tokenizedPayPalAccount, NSError * _Nonnull error) {
        XCTAssertTrue(tokenizedPayPalAccount.nonce.isANonce);
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture]];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFuturePayments_whenReturnURLSchemeIsMissing_returnsError {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    id stubDelegate = [[BTViewControllerPresentingTestDelegate alloc] init];
    payPalDriver.viewControllerPresentingDelegate = stubDelegate;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [payPalDriver authorizeAccountWithAdditionalScopes:[NSSet set] forceFuturePaymentFlow:YES completion:^(BTPayPalAccountNonce * _Nonnull tokenizedPayPalAccount, NSError * _Nonnull error) {
        XCTAssertNil(tokenizedPayPalAccount);
        XCTAssertEqualObjects(error.domain, BTPayPalDriverErrorDomain);
        XCTAssertEqual(error.code, BTPayPalDriverErrorTypeIntegrationReturnURLScheme);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFuturePayments_whenReturnURLSchemeIsInvalid_returnsError {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    id stubDelegate = [[BTViewControllerPresentingTestDelegate alloc] init];
    payPalDriver.viewControllerPresentingDelegate = stubDelegate;
    [BTAppSwitch sharedInstance].returnURLScheme = @"not-my-app-bundle-id";

    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [payPalDriver authorizeAccountWithAdditionalScopes:[NSSet set] forceFuturePaymentFlow:YES completion:^(BTPayPalAccountNonce * _Nonnull tokenizedPayPalAccount, NSError * _Nonnull error) {
        XCTAssertNil(tokenizedPayPalAccount);
        XCTAssertEqualObjects(error.domain, BTPayPalDriverErrorDomain);
        XCTAssertEqual(error.code, BTPayPalDriverErrorTypeIntegrationReturnURLScheme);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFuturePayments_onCancelledAppSwitchAuthorization_callsBackWithNoTokenizedAccountOrError {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    id stubDelegate = [[BTViewControllerPresentingTestDelegate alloc] init];
    payPalDriver.viewControllerPresentingDelegate = stubDelegate;

    self.didReceiveCompletionCallback = nil;
    [payPalDriver authorizeAccountWithAdditionalScopes:[NSSet set] forceFuturePaymentFlow:YES completion:^(BTPayPalAccountNonce * _Nonnull tokenizedPayPalAccount, NSError * _Nonnull error) {
        XCTAssertNil(tokenizedPayPalAccount);
        XCTAssertNil(error);
        self.didReceiveCompletionCallback = @(YES);
    }];

    [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:@"com.braintreepayments.Demo.payments://onetouch/v1/cancel?payload=eyJ2ZXJzaW9uIjozLCJtc2dfR1VJRCI6IjQ1QUZEQkE3LUJEQTYtNDNEMi04MUY2LUY4REM1QjZEOTkzQSIsImVudmlyb25tZW50IjoibW9jayJ9&x-source=com.paypal.ppclient.touch.v2"]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"didReceiveCompletionCallback != nil"];
    [self expectationForPredicate:predicate evaluatedWithObject:self handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark - One-time (Checkout) payments

- (void)testOneTimePayment_withTokenizationKey_tokenizesPayPalAccount {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [self stubDelegatesForPayPalDriver:payPalDriver];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block XCTestExpectation *tokenizationExpectation;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:@"1.00"];
    [payPalDriver requestOneTimePayment:request completion:^(BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount, NSError * _Nullable error) {
        XCTAssertTrue(tokenizedPayPalAccount.nonce.isANonce);
        XCTAssertNil(error);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    tokenizationExpectation = [self expectationWithDescription:@"Tokenize one-time payment"];
    [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture]];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testOneTimePayment_withClientToken_tokenizesPayPalAccount {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [self stubDelegatesForPayPalDriver:payPalDriver];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block XCTestExpectation *tokenizationExpectation;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:@"1.00"];
    [payPalDriver requestOneTimePayment:request completion:^(BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount, NSError * _Nullable error) {
        XCTAssertTrue(tokenizedPayPalAccount.nonce.isANonce);
        XCTAssertNil(error);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    tokenizationExpectation = [self expectationWithDescription:@"Tokenize one-time payment"];
    [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture]];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testOneTimePayment_withClientToken_tokenizesPayPalAccount_withCustomHandler {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block BTPayPalApprovalHandlerTestDelegate *testApproval = [BTPayPalApprovalHandlerTestDelegate new];
    testApproval.handleApprovalExpectation = [self expectationWithDescription:@"Delegate received handleApproval:paypalApprovalDelegate:"];
    testApproval.url = [NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture];

    __block XCTestExpectation *tokenizationExpectation;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:@"1.00"];
    [payPalDriver requestOneTimePayment:request handler:testApproval completion:^(BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount, NSError * _Nullable error) {
        XCTAssertTrue(tokenizedPayPalAccount.nonce.isANonce);
        XCTAssertNil(error);
        XCTAssertNotNil(testApproval);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    tokenizationExpectation = [self expectationWithDescription:@"Tokenize one-time payment"];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testOneTimePayment_withClientToken_returnsErrorWithMalformedURL_withCustomHandler {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block BTPayPalApprovalHandlerTestDelegate *testApproval = [BTPayPalApprovalHandlerTestDelegate new];
    testApproval.handleApprovalExpectation = [self expectationWithDescription:@"Delegate received handleApproval:paypalApprovalDelegate:"];
    testApproval.url = [NSURL URLWithString:@"bad://url"];

    __block XCTestExpectation *tokenizationExpectation;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:@"1.00"];
    [payPalDriver requestOneTimePayment:request handler:testApproval completion:^(BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount, NSError * _Nullable error) {
        XCTAssertNil(tokenizedPayPalAccount);
        XCTAssertNotNil(error);
        XCTAssertNotNil(testApproval);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testOneTimePayment_withClientToken_cancels_withCustomHandler {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block BTPayPalApprovalHandlerTestDelegate *testApproval = [BTPayPalApprovalHandlerTestDelegate new];
    testApproval.handleApprovalExpectation = [self expectationWithDescription:@"Delegate received handleApproval:paypalApprovalDelegate:"];
    testApproval.cancel = YES;

    __block XCTestExpectation *tokenizationExpectation;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:@"1.00"];
    [payPalDriver requestOneTimePayment:request handler:testApproval completion:^(BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount, NSError * _Nullable error) {
        XCTAssertNil(tokenizedPayPalAccount);
        XCTAssertNil(error);
        XCTAssertNotNil(testApproval);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark - Billing Agreement

- (void)testBillingAgreement_withTokenizationKey_tokenizesPayPalAccount {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [self stubDelegatesForPayPalDriver:payPalDriver];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block XCTestExpectation *tokenizationExpectation;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] init];
    [payPalDriver requestBillingAgreement:request completion:^(BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount, NSError * _Nullable error) {
        XCTAssertTrue(tokenizedPayPalAccount.nonce.isANonce);
        XCTAssertNil(error);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    tokenizationExpectation = [self expectationWithDescription:@"Tokenize billing agreement payment"];
    [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture]];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testBillingAgreement_withClientToken_tokenizesPayPalAccount {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [self stubDelegatesForPayPalDriver:payPalDriver];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block XCTestExpectation *tokenizationExpectation;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] init];
    [payPalDriver requestBillingAgreement:request completion:^(BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount, NSError * _Nullable error) {
        XCTAssertTrue(tokenizedPayPalAccount.nonce.isANonce);
        XCTAssertNil(error);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    tokenizationExpectation = [self expectationWithDescription:@"Tokenize billing agreement payment"];
    [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture]];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testBillingAgreement_withClientToken_tokenizesPayPalAccount_withCustomHandler {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block BTPayPalApprovalHandlerTestDelegate *testApproval = [BTPayPalApprovalHandlerTestDelegate new];
    testApproval.handleApprovalExpectation = [self expectationWithDescription:@"Delegate received handleApproval:paypalApprovalDelegate:"];
    testApproval.url = [NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture];

    __block XCTestExpectation *tokenizationExpectation;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] init];
    [payPalDriver requestBillingAgreement:request handler:testApproval completion:^(BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount, NSError * _Nullable error) {
        XCTAssertTrue(tokenizedPayPalAccount.nonce.isANonce);
        XCTAssertNil(error);
        XCTAssertNotNil(testApproval);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    tokenizationExpectation = [self expectationWithDescription:@"Tokenize billing agreement payment"];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testBillingAgreement_withClientToken_returnsErrorWithMalformedURL_withCustomHandler {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block BTPayPalApprovalHandlerTestDelegate *testApproval = [BTPayPalApprovalHandlerTestDelegate new];
    testApproval.handleApprovalExpectation = [self expectationWithDescription:@"Delegate received handleApproval:paypalApprovalDelegate:"];
    testApproval.url = [NSURL URLWithString:@"bad://url"];

    __block XCTestExpectation *tokenizationExpectation = [self expectationWithDescription:@"Tokenize billing agreement payment"];
    BTPayPalRequest *request = [[BTPayPalRequest alloc] init];
    [payPalDriver requestBillingAgreement:request handler:testApproval completion:^(__unused BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount,__unused  NSError * _Nullable error) {
        XCTAssertNil(tokenizedPayPalAccount);
        XCTAssertNotNil(error);
        XCTAssertNotNil(testApproval);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testBillingAgreement_withClientToken_cancels_withCustomHandler {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_CLIENT_TOKEN];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";

    __block BTPayPalApprovalHandlerTestDelegate *testApproval = [BTPayPalApprovalHandlerTestDelegate new];
    testApproval.handleApprovalExpectation = [self expectationWithDescription:@"Delegate received handleApproval:paypalApprovalDelegate:"];
    testApproval.cancel = YES;

    __block XCTestExpectation *tokenizationExpectation = [self expectationWithDescription:@"Tokenize billing agreement payment"];
    BTPayPalRequest *request = [[BTPayPalRequest alloc] init];
    [payPalDriver requestBillingAgreement:request handler:testApproval completion:^(__unused BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount,__unused  NSError * _Nullable error) {
        XCTAssertNil(tokenizedPayPalAccount);
        XCTAssertNil(error);
        XCTAssertNotNil(testApproval);
        [tokenizationExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark - Return URL handling

- (void)testCanHandleAppSwitchReturnURL_forURLsFromBrowserSwitch_returnsYES {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    [self stubDelegatesForPayPalDriver:payPalDriver];

    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        XCTAssertNotNil(tokenizedPayPalAccount);
        if (error) {
            XCTFail(@"%@", error);
        }
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.Demo.payments://onetouch/v1/success?payloadEnc=e0yvzQHOOoXyoLjKZvHBI0Rbyad6usxhOz22CjG3V1lOsguMRsuQpEqPxlIlK86VPmTuagb1jJcnDUK9QsWJE8ffe4i9Ms4ggd6r5EoymVM%2BAYgjyjaYtPPOxIgMepNGnvnYt9EKJs2Bd0wbZj0ekxSA6BzRZDPEpZ%2FjhssxJVscjbPvOwCoTnjEhuNxiOamAGSRd6fo7ln%2BishDwRCLz81qlV8cgfXNzlHrRw1P7CbTQ8XhNGn35CHD64ysuHAW97ZjAzPCRdikWbgiw2S%2BDvSePhRRnTR10e2NPDYBeVzGQFzvf6WRklrqcLeFwRcAqoa0ZneOPgMbk5nvylGY716caCCPtJKnoJAflZZK6%2F7iXcA%2F3p9qrQIrszmthu%2FbnA%2FP7dZsWRarUiT%2FZhZg32MsmV3B3fPjQOMbhB7dRv5uomhCjhNhPzXH7nFA54mKOlvAdTm1QOk5P%2Fh3AaHz0qwIKgXAhxIfwxqHgIYxtba53sdwa7OXfx14FRlcfPngrR02IAHeaulkH6vJ24ZAsoUUdNkvRfDmM1O2%2B4424%2FMINTUJJsR0%2FwrYrwzp0gC6fKoAzT%2FgFhL6QVLoUss%3D&payload=eyJ2ZXJzaW9uIjozLCJtc2dfR1VJRCI6IkMwQTkwODQ1LTJBRUQtNEZCRC04NzIwLTQzNUU2MkRGNjhFNCIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJsaXZlIiwiZXJyb3IiOm51bGx9&x-source=com.braintree.browserswitch"];
    NSString *source = @"com.apple.mobilesafari";

    BOOL canHandleAppSwitch = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:source];

    XCTAssertTrue(canHandleAppSwitch);
}

- (void)testCanHandleAppSwitchReturnURL_forURLsFromWebSwitch_returnsYES {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    [self stubDelegatesForPayPalDriver:payPalDriver];
    id stubApplication = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([stubApplication canOpenURL:[OCMArg any]]).andReturn(YES);

    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        XCTAssertNotNil(tokenizedPayPalAccount);
        if (error) {
            XCTFail(@"%@", error);
        }
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    NSURL *returnURL = [NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture];
    BOOL canHandleV1AppSwitch = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:@"com.apple.mobilesafari"];
    BOOL canHandleV2AppSwitch = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:@"com.apple.safariviewservice"];

    XCTAssertTrue(canHandleV1AppSwitch);
    XCTAssertTrue(canHandleV2AppSwitch);
}

- (void)testCanHandleAppSwitchReturnURL_forMalformedURLs_returnsNO {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    [self stubDelegatesForPayPalDriver:payPalDriver];
    id stubApplication = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([stubApplication canOpenURL:[OCMArg any]]).andReturn(YES);

    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        XCTAssertNotNil(tokenizedPayPalAccount);
        if (error) {
            XCTFail(@"%@", error);
        }
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    // This malformed returnURL is just missing payload
    NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.Demo.payments://onetouch/v1/success?x-source=com.paypal.ppclient.touch.v1-or-v2"];
    BOOL canHandleAppSwitch = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:@"com.paypal.ppclient.touch.v1"];

    XCTAssertFalse(canHandleAppSwitch);
}

- (void)testCanHandleAppSwitchReturnURL_forUnsupportedSourceApplication_returnsNO {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    [self stubDelegatesForPayPalDriver:payPalDriver];
    id stubApplication = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([stubApplication canOpenURL:[OCMArg any]]).andReturn(YES);
    
    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        XCTAssertNotNil(tokenizedPayPalAccount);
        if (error) {
            XCTFail(@"%@", error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
    // This malformed returnURL is just missing payload
    NSURL *returnURL = [NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture];
    BOOL canHandleAppSwitch = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:@"com.example.application"];
    
    XCTAssertFalse(canHandleAppSwitch);
}

- (void)testCanHandleAppSwitchReturnURL_whenNoAppSwitchIsInProgress_returnsNO {
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    id stubApplication = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([stubApplication canOpenURL:[OCMArg any]]).andReturn(YES);

    NSURL *returnURL = [NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture];
    BOOL canHandleAppSwitch = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:@"com.malicious.app"];

    XCTAssertFalse(canHandleAppSwitch);
}

- (void)testCanHandleAppSwitchReturnURL_afterHandlingAnAppSwitchAndBeforeInitiatingAnotherAppSwitch_returnsNO {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    [self stubDelegatesForPayPalDriver:payPalDriver];
    id stubApplication = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([stubApplication canOpenURL:[OCMArg any]]).andReturn(YES);

    self.didReceiveCompletionCallback = nil;
    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        XCTAssertNotNil(tokenizedPayPalAccount);
        if (error) {
            XCTFail(@"%@", error);
        }
        self.didReceiveCompletionCallback = @(YES);
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    NSURL *returnURL = [NSURL URLWithString:OneTouchCoreAppSwitchSuccessURLFixture];
    BOOL canHandleAppSwitch = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:@"com.apple.mobilesafari"];
    XCTAssertTrue(canHandleAppSwitch);
    [BTPayPalDriver handleAppSwitchReturnURL:returnURL];

    // Pause until handleAppSwitchReturnURL has finished
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"didReceiveCompletionCallback != nil"];
    [self expectationForPredicate:predicate evaluatedWithObject:self handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];

    canHandleAppSwitch = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:@"com.apple.mobilesafari"];
    XCTAssertFalse(canHandleAppSwitch);
}

- (void)testCanHandleAppSwitchReturnURL_whenAppSwitchReturnURLHasMismatchedCase_returnsYES {
    // Motivation for this test is because of Safari's habit of downcasing URL schemes
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    [self stubDelegatesForPayPalDriver:payPalDriver];
    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        XCTAssertNotNil(tokenizedPayPalAccount);
        if (error) {
            XCTFail(@"%@", error);
        }
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.Demo.payments://onetouch/v1/success?payloadEnc=e0yvzQHOOoXyoLjKZvHBI0Rbyad6usxhOz22CjG3V1lOsguMRsuQpEqPxlIlK86VPmTuagb1jJcnDUK9QsWJE8ffe4i9Ms4ggd6r5EoymVM%2BAYgjyjaYtPPOxIgMepNGnvnYt9EKJs2Bd0wbZj0ekxSA6BzRZDPEpZ%2FjhssxJVscjbPvOwCoTnjEhuNxiOamAGSRd6fo7ln%2BishDwRCLz81qlV8cgfXNzlHrRw1P7CbTQ8XhNGn35CHD64ysuHAW97ZjAzPCRdikWbgiw2S%2BDvSePhRRnTR10e2NPDYBeVzGQFzvf6WRklrqcLeFwRcAqoa0ZneOPgMbk5nvylGY716caCCPtJKnoJAflZZK6%2F7iXcA%2F3p9qrQIrszmthu%2FbnA%2FP7dZsWRarUiT%2FZhZg32MsmV3B3fPjQOMbhB7dRv5uomhCjhNhPzXH7nFA54mKOlvAdTm1QOk5P%2Fh3AaHz0qwIKgXAhxIfwxqHgIYxtba53sdwa7OXfx14FRlcfPngrR02IAHeaulkH6vJ24ZAsoUUdNkvRfDmM1O2%2B4424%2FMINTUJJsR0%2FwrYrwzp0gC6fKoAzT%2FgFhL6QVLoUss%3D&payload=eyJ2ZXJzaW9uIjozLCJtc2dfR1VJRCI6IkMwQTkwODQ1LTJBRUQtNEZCRC04NzIwLTQzNUU2MkRGNjhFNCIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJsaXZlIiwiZXJyb3IiOm51bGx9&x-source=com.braintree.browserswitch"];
    NSString *source = @"com.apple.mobilesafari";
    BOOL canHandleAppSwitch = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:source];

    XCTAssertTrue(canHandleAppSwitch);
}

#pragma mark handleURL

- (void)testHandleURL_whenURLIsConsideredInvalidByPayPalOTC_returnsError {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    [self stubDelegatesForPayPalDriver:payPalDriver];
    id stubApplication = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([stubApplication canOpenURL:[OCMArg any]]).andReturn(YES);

    self.didReceiveCompletionCallback = nil;
    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        XCTAssertNil(tokenizedPayPalAccount);
        XCTAssertNotNil(error);
        self.didReceiveCompletionCallback = @(YES);
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:@"com.braintreepayments.Demo.payments://----invalid----"]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"didReceiveCompletionCallback != nil"];
    [self expectationForPredicate:predicate evaluatedWithObject:self handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testHandleURL_whenURLIsMissingHostAndPath_returnsError {
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:SANDBOX_TOKENIZATION_KEY];
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    [BTAppSwitch sharedInstance].returnURLScheme = @"com.braintreepayments.Demo.payments";
    [self stubDelegatesForPayPalDriver:payPalDriver];
    id stubApplication = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([stubApplication canOpenURL:[OCMArg any]]).andReturn(YES);

    self.didReceiveCompletionCallback = nil;
    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        XCTAssertNil(tokenizedPayPalAccount);
        XCTAssertNotNil(error);
        self.didReceiveCompletionCallback = @(YES);
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:@"com.braintreepayments.Demo.payments://"]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"didReceiveCompletionCallback != nil"];
    [self expectationForPredicate:predicate evaluatedWithObject:self handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

#pragma mark - Helper

// Stubs the app switch or view controller presenting delegate, depending on which one will be used.
// The main purpose is to wait for delegate callbacks to occur in the app switch lifecycle to ensure
// that the PayPal driver's app switch return block is set and its behavior is ready to be tested.
- (void)stubDelegatesForPayPalDriver:(BTPayPalDriver *)payPalDriver {
    if (!self.viewControllerPresentingDelegate) {
        self.viewControllerPresentingDelegate = [[BTViewControllerPresentingTestDelegate alloc] init];
    }
    if (!self.appSwitchDelegate) {
        self.appSwitchDelegate = [[BTAppSwitchTestDelegate alloc] init];
    }

    if (NSClassFromString(@"SFSafariViewController")) {
        self.viewControllerPresentingDelegate.requestsPresentationExpectation = [self expectationWithDescription:@"Delegate received requestsPresentation"];
        payPalDriver.viewControllerPresentingDelegate = self.viewControllerPresentingDelegate;
    } else {
        self.appSwitchDelegate.willPerform = [self expectationWithDescription:@"Delegate received willPerformAppSwitch"];
        self.appSwitchDelegate.didPerform = [self expectationWithDescription:@"Delegate received didPerformAppSwitch"];
        payPalDriver.appSwitchDelegate = self.appSwitchDelegate;
    }
}

@end
