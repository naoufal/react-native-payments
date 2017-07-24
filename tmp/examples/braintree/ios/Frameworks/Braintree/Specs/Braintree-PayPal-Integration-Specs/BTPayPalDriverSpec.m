#import "BTPayPalDriver.h"

#import "Braintree.h"
#import "BTClient_Internal.h"
#import "PayPalOneTouchCore.h"
#import "PayPalOneTouchRequest.h"
#import "BTAppSwitchErrors.h"
#import "BTPayPalDriver_Compatibility.h"

@interface BTPayPalDriverSpecHelper : NSObject
@end

@implementation BTPayPalDriverSpecHelper

+ (void)setupSpec:(void (^)(NSString *returnURLScheme, id mockClient, id mockApplication))setupBlock {
    id configuration = [OCMockObject mockForClass:[BTConfiguration class]];
    [[[configuration stub] andReturnValue:@YES] payPalEnabled];
    [[[configuration stub] andReturn:[NSURL URLWithString:@"https://example.com/privacy"]] payPalPrivacyPolicyURL];
    [[[configuration stub] andReturn:[NSURL URLWithString:@"https://example.com/tos"]] payPalMerchantUserAgreementURL];
    [[[configuration stub] andReturn:@"offline"] payPalEnvironment];
    [[[configuration stub] andReturn:@"client-id"] payPalClientId];
    [[[configuration stub] andReturnValue:@NO] payPalUseBillingAgreement];
    
    id clientToken = [OCMockObject mockForClass:[BTClientToken class]];
    [[[clientToken stub] andReturn:@"client-token"] originalValue];
    
    id client = [OCMockObject mockForClass:[BTClient class]];
    [[[client stub] andReturn:client] copyWithMetadata:OCMOCK_ANY];
    [[[client stub] andReturn:clientToken] clientToken];
    [[[client stub] andReturn:configuration] configuration];

    NSString *returnURLScheme = @"com.braintreepayments.Braintree-Demo.payments";

    id bundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
    [[[bundle stub] andReturn:@[@{ @"CFBundleURLSchemes": @[returnURLScheme] }]] objectForInfoDictionaryKey:@"CFBundleURLTypes"];

    id application = [OCMockObject partialMockForObject:[UIApplication sharedApplication]];
    [[[application stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", returnURLScheme)];

    setupBlock(returnURLScheme, client, application);
}

@end

SpecBegin(BTPayPalDriver)

describe(@"PayPal One Touch Core", ^{
    describe(@"future payments", ^{
        describe(@"performing app switches", ^{
            it(@"performs an app switch to PayPal when the PayPal app is installed", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];

                    XCTestExpectation *appSwitchExpectation = [self expectationWithDescription:@"Perform App Switch"];
                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", HC_startsWith(@"com.paypal"))];
                    [[[[mockApplication expect] andReturnValue:@YES] andDo:^(__unused NSInvocation *invocation) {
                        [appSwitchExpectation fulfill];
                    }] openURL:HC_hasProperty(@"scheme", HC_startsWith(@"com.paypal"))];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    [payPalDriver startAuthorizationWithCompletion:nil];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockApplication verify];
                }];
            });

            it(@"performs an app switch to Safari when the PayPal app is not installed", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                    XCTestExpectation *appSwitchExpectation = [self expectationWithDescription:@"Perform App Switch"];

                    [[[mockApplication stub] andReturnValue:@NO] canOpenURL:HC_hasProperty(@"scheme", HC_startsWith(@"com.paypal"))];

                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"https")];
                    [[[[mockApplication expect] andReturnValue:@YES] andDo:^(NSInvocation *invocation) {
                        [appSwitchExpectation fulfill];
                    }] openURL:HC_hasProperty(@"scheme", @"https")];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    [payPalDriver startAuthorizationWithCompletion:nil];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockApplication verify];
                }];
            });

            it(@"fails to initialize if the returnURLScheme is not valid", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:@"invalid-return-url-scheme"];

                    expect(payPalDriver).to.beNil();
                }];
            });
        });

        describe(@"handling app switch returns", ^{
            it(@"receives a payment method on app switch return success", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];

                    BTPaymentMethod *fakePaymentMethod = [OCMockObject mockForClass:[BTPaymentMethod class]];
                    NSURL *fakeReturnURL = [OCMockObject mockForClass:[NSURL class]];

                    [[[mockClient expect] andDo:^(NSInvocation *invocation) {
                        void (^successBlock)(BTPaymentMethod *paymentMethod);
                        [invocation getArgument:&successBlock atIndex:4];
                        successBlock(fakePaymentMethod);
                    }] savePaypalAccount:OCMOCK_ANY clientMetadataID:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];

                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:OCMOCK_ANY];
                    [[[mockApplication stub] andReturnValue:@YES] openURL:OCMOCK_ANY];

                    id mockOTC = [OCMockObject mockForClass:[PayPalOneTouchCore class]];
                    [[[[mockOTC expect] classMethod] andDo:^(NSInvocation *invocation) {
                        void (^stubOTCCompletionBlock)(PayPalOneTouchCoreResult *result);
                        [invocation getArgument:&stubOTCCompletionBlock atIndex:3];
                        id result = [OCMockObject mockForClass:[PayPalOneTouchCoreResult class]];
                        [(PayPalOneTouchCoreResult *)[[result stub] andReturnValue:OCMOCK_VALUE(PayPalOneTouchResultTypeSuccess)] type];
                        [(PayPalOneTouchCoreResult *)[result stub] target];
                        [(PayPalOneTouchCoreResult *)[result stub] response];
                        stubOTCCompletionBlock(result);
                    }] parseResponseURL:fakeReturnURL completionBlock:[OCMArg isNotNil]];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Received call to completion block"];
                    [payPalDriver startAuthorizationWithCompletion:^void(BTPayPalPaymentMethod *paymentMethod, NSError *error) {
                        expect(paymentMethod).to.equal(fakePaymentMethod);
                        expect(error).to.beNil();
                        [completionExpectation fulfill];
                    }];

                    [BTPayPalDriver handleAppSwitchReturnURL:fakeReturnURL];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockClient verify];
                    [mockOTC verify];
                }];
            });

            it(@"receives the error passed through directly on failure", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];

                    NSError *fakeError = [OCMockObject mockForClass:[NSError class]];
                    NSURL *fakeReturnURL = [OCMockObject mockForClass:[NSURL class]];

                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:OCMOCK_ANY];
                    [[[mockApplication stub] andReturnValue:@YES] openURL:OCMOCK_ANY];

                    id mockOTC = [OCMockObject mockForClass:[PayPalOneTouchCore class]];
                    [[[[mockOTC expect] classMethod] andDo:^(NSInvocation *invocation) {
                        void (^stubOTCCompletionBlock)(PayPalOneTouchCoreResult *result);
                        [invocation getArgument:&stubOTCCompletionBlock atIndex:3];
                        id result = [OCMockObject mockForClass:[PayPalOneTouchCoreResult class]];
                        [(PayPalOneTouchCoreResult *)[[result stub] andReturnValue:OCMOCK_VALUE(PayPalOneTouchResultTypeError)] type];
                        [(PayPalOneTouchCoreResult *)[result stub] target];
                        [(PayPalOneTouchCoreResult *)[[result stub] andReturn:fakeError] error];
                        stubOTCCompletionBlock(result);
                    }] parseResponseURL:fakeReturnURL completionBlock:[OCMArg isNotNil]];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Received call to completion block"];
                    [payPalDriver startAuthorizationWithCompletion:^void(BTPayPalPaymentMethod *paymentMethod, NSError *error) {
                        expect(paymentMethod).to.beNil();
                        expect(error).to.equal(fakeError);
                        [completionExpectation fulfill];
                    }];

                    [BTPayPalDriver handleAppSwitchReturnURL:fakeReturnURL];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockClient verify];
                    [mockOTC verify];
                }];
            });

            it(@"receives neither a payment method nor an error on cancelation", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];

                    NSURL *fakeReturnURL = [OCMockObject mockForClass:[NSURL class]];

                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:OCMOCK_ANY];
                    [[[mockApplication stub] andReturnValue:@YES] openURL:OCMOCK_ANY];

                    id mockOTC = [OCMockObject mockForClass:[PayPalOneTouchCore class]];
                    [[[[mockOTC expect] classMethod] andDo:^(NSInvocation *invocation) {
                        void (^stubOTCCompletionBlock)(PayPalOneTouchCoreResult *result);
                        [invocation getArgument:&stubOTCCompletionBlock atIndex:3];
                        id result = [OCMockObject mockForClass:[PayPalOneTouchCoreResult class]];
                        [(PayPalOneTouchCoreResult *)[[result stub] andReturnValue:OCMOCK_VALUE(PayPalOneTouchResultTypeCancel)] type];
                        [(PayPalOneTouchCoreResult *)[result stub] target];
                        [(PayPalOneTouchCoreResult *)[result stub] error];
                        stubOTCCompletionBlock(result);
                    }] parseResponseURL:fakeReturnURL completionBlock:[OCMArg isNotNil]];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Received call to completion block"];
                    [payPalDriver startAuthorizationWithCompletion:^void(BTPayPalPaymentMethod *paymentMethod, NSError *error) {
                        expect(paymentMethod).to.beNil();
                        expect(error).to.beNil();
                        [completionExpectation fulfill];
                    }];

                    [BTPayPalDriver handleAppSwitchReturnURL:fakeReturnURL];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockClient verify];
                    [mockOTC verify];
                }];
            });
        });

        describe(@"scopes", ^{
            it(@"includes email and future payments", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];

                    XCTestExpectation *appSwitchExpectation = [self expectationWithDescription:@"opened URL"];
                    [[[[mockApplication expect] andReturnValue:@YES] andDo:^(NSInvocation *invocation) {
                        [appSwitchExpectation fulfill];
                    }] openURL:HC_hasProperty(@"scheme", @"https")];

                    id otcStub = [OCMockObject mockForClass:[PayPalOneTouchAuthorizationRequest class]];
                    [[[[otcStub expect] classMethod] andForwardToRealObject] requestWithScopeValues:HC_containsInAnyOrder(@"email", @"https://uri.paypal.com/services/payments/futurepayments", nil)
                                                                                         privacyURL:OCMOCK_ANY
                                                                                       agreementURL:OCMOCK_ANY
                                                                                           clientID:OCMOCK_ANY
                                                                                        environment:OCMOCK_ANY
                                                                                  callbackURLScheme:OCMOCK_ANY];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                    [payPalDriver startAuthorizationWithCompletion:nil];

                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [otcStub verify];
                }];
            });
        });

        describe(@"analytics", ^{
            it(@"posts an analytics event for a successful app switch to the PayPal app", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    XCTestExpectation *appSwitchExpectation = [self expectationWithDescription:@"Perform App Switch"];
                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", HC_startsWith(@"com.paypal"))];
                    [[[[mockApplication expect] andReturnValue:@YES] andDo:^(__unused NSInvocation *invocation) {
                        [appSwitchExpectation fulfill];
                    }] openURL:HC_hasProperty(@"scheme", HC_startsWith(@"com.paypal"))];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    [[mockClient expect] postAnalyticsEvent:@"ios.paypal-future-payments.appswitch.initiate.started"];

                    [payPalDriver startAuthorizationWithCompletion:nil];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockClient verify];
                }];
            });

            it(@"posts an analytics event for a successful app switch to the Browser", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    XCTestExpectation *appSwitchExpectation = [self expectationWithDescription:@"Perform App Switch"];
                    [[[mockApplication stub] andReturnValue:@NO] canOpenURL:HC_hasProperty(@"scheme", HC_startsWith(@"com.paypal"))];
                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"https")];
                    [[[[mockApplication expect] andReturnValue:@YES] andDo:^(__unused NSInvocation *invocation) {
                        [appSwitchExpectation fulfill];
                    }] openURL:HC_hasProperty(@"scheme", @"https")];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    [[mockClient expect] postAnalyticsEvent:@"ios.paypal-future-payments.webswitch.initiate.started"];

                    [payPalDriver startAuthorizationWithCompletion:nil];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockClient verify];
                }];
            });

            it(@"posts an analytics event for a failed app switch", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    XCTestExpectation *appSwitchExpectation = [self expectationWithDescription:@"Perform App Switch"];
                    [[[mockApplication stub] andReturnValue:@NO] canOpenURL:HC_hasProperty(@"scheme", HC_startsWith(@"com.paypal"))];
                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"https")];
                    [[[[mockApplication expect] andReturnValue:@YES] andDo:^(__unused NSInvocation *invocation) {
                        [appSwitchExpectation fulfill];
                    }] openURL:HC_hasProperty(@"scheme", @"https")];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    [[mockClient expect] postAnalyticsEvent:@"ios.paypal-future-payments.webswitch.initiate.started"];

                    [payPalDriver startAuthorizationWithCompletion:nil];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockClient verify];
                }];
            });

            it(@"posts analytics events when preflight checks fail", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    [[mockClient expect] postAnalyticsEvent:@"ios.paypal-otc.preflight.invalid-return-url-scheme"];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:@"invalid-return-url-scheme"];
                    expect(payPalDriver).to.beNil();

                    [mockClient verify];
                }];
            });

            it(@"post an analytics event to indicate handling the one touch core response ", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    NSURL *fakeReturnURL = [OCMockObject mockForClass:[NSURL class]];

                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:OCMOCK_ANY];
                    [[[mockApplication stub] andReturnValue:@YES] openURL:OCMOCK_ANY];

                    id mockOTC = [OCMockObject mockForClass:[PayPalOneTouchCore class]];
                    [[[[mockOTC stub] classMethod] andDo:^(NSInvocation *invocation) {
                        void (^stubOTCCompletionBlock)(PayPalOneTouchCoreResult *result);
                        [invocation getArgument:&stubOTCCompletionBlock atIndex:3];
                        id result = [OCMockObject mockForClass:[PayPalOneTouchCoreResult class]];
                        [(PayPalOneTouchCoreResult *)[[result stub] andReturnValue:OCMOCK_VALUE(PayPalOneTouchResultTypeCancel)] type];
                        [(PayPalOneTouchCoreResult *)[result stub] target];
                        [(PayPalOneTouchCoreResult *)[result stub] error];
                        stubOTCCompletionBlock(result);
                    }] parseResponseURL:fakeReturnURL completionBlock:[OCMArg isNotNil]];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    [[mockClient expect] postAnalyticsEvent:@"ios.paypal-future-payments.unknown.canceled"];
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];

                    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Received call to completion block"];
                    [payPalDriver startAuthorizationWithCompletion:^void(BTPayPalPaymentMethod *paymentMethod, NSError *error) {
                        [completionExpectation fulfill];
                    }];

                    [BTPayPalDriver handleAppSwitchReturnURL:fakeReturnURL];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockClient verify];
                }];
            });

            it(@"posts an anlaytics event to indicate tokenization success", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    NSURL *fakeReturnURL = [OCMockObject mockForClass:[NSURL class]];

                    [[[mockClient stub] andDo:^(NSInvocation *invocation) {
                        void (^successBlock)(BTPaymentMethod *paymentMethod);
                        [invocation getArgument:&successBlock atIndex:4];
                        successBlock(nil);
                    }] savePaypalAccount:OCMOCK_ANY clientMetadataID:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];

                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:OCMOCK_ANY];
                    [[[mockApplication stub] andReturnValue:@YES] openURL:OCMOCK_ANY];

                    id mockOTC = [OCMockObject mockForClass:[PayPalOneTouchCore class]];
                    [[[[mockOTC stub] classMethod] andDo:^(NSInvocation *invocation) {
                        void (^stubOTCCompletionBlock)(PayPalOneTouchCoreResult *result);
                        [invocation getArgument:&stubOTCCompletionBlock atIndex:3];
                        id result = [OCMockObject mockForClass:[PayPalOneTouchCoreResult class]];
                        [(PayPalOneTouchCoreResult *)[[result stub] andReturnValue:OCMOCK_VALUE(PayPalOneTouchResultTypeSuccess)] type];
                        [(PayPalOneTouchCoreResult *)[result stub] target];
                        [(PayPalOneTouchCoreResult *)[result stub] response];
                        stubOTCCompletionBlock(result);
                    }] parseResponseURL:fakeReturnURL completionBlock:[OCMArg isNotNil]];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    [[mockClient expect] postAnalyticsEvent:@"ios.paypal-future-payments.tokenize.succeeded"];
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];

                    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Received call to completion block"];
                    [payPalDriver startAuthorizationWithCompletion:^void(BTPayPalPaymentMethod *paymentMethod, NSError *error) {
                        [completionExpectation fulfill];
                    }];

                    [BTPayPalDriver handleAppSwitchReturnURL:fakeReturnURL];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockClient verify];
                }];
            });

            it(@"posts an anlaytics event to indicate tokenization failure", ^{
                [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                    NSURL *fakeReturnURL = [OCMockObject mockForClass:[NSURL class]];

                    [[[mockClient stub] andDo:^(NSInvocation *invocation) {
                        void (^failureBlock)(BTPaymentMethod *paymentMethod);
                        [invocation getArgument:&failureBlock atIndex:5];
                        failureBlock(nil);
                    }] savePaypalAccount:OCMOCK_ANY clientMetadataID:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];

                    [[[mockApplication stub] andReturnValue:@YES] canOpenURL:OCMOCK_ANY];
                    [[[mockApplication stub] andReturnValue:@YES] openURL:OCMOCK_ANY];

                    id mockOTC = [OCMockObject mockForClass:[PayPalOneTouchCore class]];
                    [[[[mockOTC stub] classMethod] andDo:^(NSInvocation *invocation) {
                        void (^stubOTCCompletionBlock)(PayPalOneTouchCoreResult *result);
                        [invocation getArgument:&stubOTCCompletionBlock atIndex:3];
                        id result = [OCMockObject mockForClass:[PayPalOneTouchCoreResult class]];
                        [(PayPalOneTouchCoreResult *)[[result stub] andReturnValue:OCMOCK_VALUE(PayPalOneTouchResultTypeSuccess)] type];
                        [(PayPalOneTouchCoreResult *)[result stub] target];
                        [(PayPalOneTouchCoreResult *)[result stub] response];
                        stubOTCCompletionBlock(result);
                    }] parseResponseURL:fakeReturnURL completionBlock:[OCMArg isNotNil]];

                    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];

                    [[mockClient expect] postAnalyticsEvent:@"ios.paypal-future-payments.tokenize.failed"];
                    [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];

                    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Received call to completion block"];
                    [payPalDriver startAuthorizationWithCompletion:^void(BTPayPalPaymentMethod *paymentMethod, NSError *error) {
                        [completionExpectation fulfill];
                    }];

                    [BTPayPalDriver handleAppSwitchReturnURL:fakeReturnURL];
                    [self waitForExpectationsWithTimeout:10 handler:nil];

                    [mockClient verify];
                }];
            });
        });

        describe(@"delegate notifications", ^{
        });

        describe(@"isAvailable", ^{
            
            
            it(@"returns YES when PayPal is enabled in configuration and One Touch Core is ready", ^{
                
                id configuration = [OCMockObject mockForClass:[BTConfiguration class]];
                [[[configuration stub] andReturnValue:@YES] payPalEnabled];
                [[[configuration stub] andReturn:[NSURL URLWithString:@"https://example.com/privacy"]] payPalPrivacyPolicyURL];
                [[[configuration stub] andReturn:[NSURL URLWithString:@"https://example.com/tos"]] payPalMerchantUserAgreementURL];
                [[[configuration stub] andReturn:@"offline"] payPalEnvironment];
                [[[configuration stub] andReturn:@"client-id"] payPalClientId];
                
                id clientToken = [OCMockObject mockForClass:[BTClientToken class]];
                [[[clientToken stub] andReturn:@"client-token"] originalValue];
                
                id client = [OCMockObject mockForClass:[BTClient class]];
                [[[client stub] andReturn:client] copyWithMetadata:OCMOCK_ANY];
                [[[client stub] andReturn:clientToken] clientToken];
                [[[client stub] andReturn:configuration] configuration];
                
                NSString *returnURLScheme = @"com.braintreepayments.Braintree-Demo.bt-payments";
                
                id bundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
                [[[bundle stub] andReturn:@[@{ @"CFBundleURLSchemes": @[returnURLScheme] }]] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
                
                id application = [OCMockObject partialMockForObject:[UIApplication sharedApplication]];
                [[[application stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", returnURLScheme)];
                
                NSError *error;
                BOOL isAvailable = [BTPayPalDriver verifyAppSwitchConfigurationForClient:client returnURLScheme:returnURLScheme error:&error];
                expect(isAvailable).to.beTruthy();
                expect(error).to.beNil();
                
                
            });

            it(@"returns NO when PayPal is not enabled in configuration", ^{
                
                id configuration = [OCMockObject mockForClass:[BTConfiguration class]];
                [[[configuration stub] andReturnValue:@NO] payPalEnabled];

                [[[configuration stub] andReturn:@"offline"] payPalEnvironment];
                [[[configuration stub] andReturn:@"client-id"] payPalClientId];
                
                id clientToken = [OCMockObject mockForClass:[BTClientToken class]];
                [[[clientToken stub] andReturn:@"client-token"] originalValue];
                
                id client = [OCMockObject mockForClass:[BTClient class]];
                [[[client stub] andReturn:client] copyWithMetadata:OCMOCK_ANY];
                [[[client stub] andReturn:clientToken] clientToken];
                [[[client stub] andReturn:configuration] configuration];
                
                NSString *returnURLScheme = @"com.braintreepayments.Braintree-Demo.bt-payments";
                
                id bundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
                [[[bundle stub] andReturn:@[@{ @"CFBundleURLSchemes": @[returnURLScheme] }]] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
                
                id application = [OCMockObject partialMockForObject:[UIApplication sharedApplication]];
                [[[application stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", returnURLScheme)];

                [[client expect] postAnalyticsEvent:@"ios.paypal-otc.preflight.disabled"];

                NSError *error;
                BOOL isAvailable = [BTPayPalDriver verifyAppSwitchConfigurationForClient:client returnURLScheme:returnURLScheme error:&error];
                expect(isAvailable).to.beFalsy();
                expect(error).notTo.beNil();
                
            });

            it(@"returns NO when the URL scheme has not been setup", ^{
                
                id configuration = [OCMockObject mockForClass:[BTConfiguration class]];
                [[[configuration stub] andReturnValue:@YES] payPalEnabled];
                
                [[[configuration stub] andReturn:@"offline"] payPalEnvironment];
                [[[configuration stub] andReturn:@"client-id"] payPalClientId];
                
                id clientToken = [OCMockObject mockForClass:[BTClientToken class]];
                [[[clientToken stub] andReturn:@"client-token"] originalValue];
                
                id client = [OCMockObject mockForClass:[BTClient class]];
                [[[client stub] andReturn:client] copyWithMetadata:OCMOCK_ANY];
                [[[client stub] andReturn:clientToken] clientToken];
                [[[client stub] andReturn:configuration] configuration];
                
                NSString *returnURLScheme = @"com.braintreepayments.Braintree-Demo.bt-payments";
                
                id application = [OCMockObject partialMockForObject:[UIApplication sharedApplication]];
                [[[application stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", returnURLScheme)];
                
                [[client expect] postAnalyticsEvent:@"ios.paypal-otc.preflight.invalid-return-url-scheme"];
                
                NSError *error;
                BOOL isAvailable = [BTPayPalDriver verifyAppSwitchConfigurationForClient:client returnURLScheme:returnURLScheme error:&error];
                expect(isAvailable).to.beFalsy();
                expect(error).notTo.beNil();
                
            });

            it(@"returns NO when the return URL scheme has not been registered with UIApplication", ^{
                
                id configuration = [OCMockObject mockForClass:[BTConfiguration class]];
                [[[configuration stub] andReturnValue:@YES] payPalEnabled];
                
                [[[configuration stub] andReturn:@"offline"] payPalEnvironment];
                [[[configuration stub] andReturn:@"client-id"] payPalClientId];
                
                id clientToken = [OCMockObject mockForClass:[BTClientToken class]];
                [[[clientToken stub] andReturn:@"client-token"] originalValue];
                
                id client = [OCMockObject mockForClass:[BTClient class]];
                [[[client stub] andReturn:client] copyWithMetadata:OCMOCK_ANY];
                [[[client stub] andReturn:clientToken] clientToken];
                [[[client stub] andReturn:configuration] configuration];
                
                NSString *returnURLScheme = @"com.braintreepayments.Braintree-Demo.bt-payments";
                
                id bundle = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
                [[[bundle stub] andReturn:@[@{ @"CFBundleURLSchemes": @[returnURLScheme] }]] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
                
                [[client expect] postAnalyticsEvent:@"ios.paypal-otc.preflight.invalid-return-url-scheme"];
                
                NSError *error;
                BOOL isAvailable = [BTPayPalDriver verifyAppSwitchConfigurationForClient:client returnURLScheme:returnURLScheme error:&error];
                expect(isAvailable).to.beFalsy();
                expect(error).notTo.beNil();
                
            });
        });

    });

    describe(@"classifying app switch returns", ^{
        
        afterEach(^{
            // Reset state of BTPayPalDriver after each test (execute BTPayPalHandleURLContinuation if set)
            [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:@""]];
        });
        
        it(@"accepts return URLs from the browser", ^{
            
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC.
                // Pretend that no wallet is installed.
                [[[mockApplication stub] andReturnValue:@NO] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v1")];
                [[[mockApplication stub] andReturnValue:@NO] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v1")];
                [[[mockApplication stub] andReturnValue:@NO] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@NO] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];

                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                [payPalDriver startAuthorizationWithCompletion:nil];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.braintree-demo.payments://onetouch/v1/success?payloadEnc=e0yvzQHOOoXyoLjKZvHBI0Rbyad6usxhOz22CjG3V1lOsguMRsuQpEqPxlIlK86VPmTuagb1jJcnDUK9QsWJE8ffe4i9Ms4ggd6r5EoymVM%2BAYgjyjaYtPPOxIgMepNGnvnYt9EKJs2Bd0wbZj0ekxSA6BzRZDPEpZ%2FjhssxJVscjbPvOwCoTnjEhuNxiOamAGSRd6fo7ln%2BishDwRCLz81qlV8cgfXNzlHrRw1P7CbTQ8XhNGn35CHD64ysuHAW97ZjAzPCRdikWbgiw2S%2BDvSePhRRnTR10e2NPDYBeVzGQFzvf6WRklrqcLeFwRcAqoa0ZneOPgMbk5nvylGY716caCCPtJKnoJAflZZK6%2F7iXcA%2F3p9qrQIrszmthu%2FbnA%2FP7dZsWRarUiT%2FZhZg32MsmV3B3fPjQOMbhB7dRv5uomhCjhNhPzXH7nFA54mKOlvAdTm1QOk5P%2Fh3AaHz0qwIKgXAhxIfwxqHgIYxtba53sdwa7OXfx14FRlcfPngrR02IAHeaulkH6vJ24ZAsoUUdNkvRfDmM1O2%2B4424%2FMINTUJJsR0%2FwrYrwzp0gC6fKoAzT%2FgFhL6QVLoUss%3D&payload=eyJ2ZXJzaW9uIjozLCJtc2dfR1VJRCI6IkMwQTkwODQ1LTJBRUQtNEZCRC04NzIwLTQzNUU2MkRGNjhFNCIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJsaXZlIiwiZXJyb3IiOm51bGx9&x-source=com.braintree.browserswitch"];
                NSString *source = @"com.apple.mobilesafari";
                
                BOOL canHandle = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:source];
                expect(canHandle).to.beTruthy();
                
                [mockApplication verify];
            }];
            
        });

        it(@"accepts return URLs from the app", ^{
            
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                [payPalDriver startAuthorizationWithCompletion:nil];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.Braintree-Demo.payments://onetouch/v1/success?payload=eyJ2ZXJzaW9uIjoyLCJhY2NvdW50X2NvdW50cnkiOiJVUyIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXhwaXJlc19pbiI6LTEsImRpc3BsYXlfbmFtZSI6Im1vY2tEaXNwbGF5TmFtZSIsInNjb3BlIjoiaHR0cHM6XC9cL3VyaS5wYXlwYWwuY29tXC9zZXJ2aWNlc1wvcGF5bWVudHNcL2Z1dHVyZXBheW1lbnRzIiwiZW1haWwiOiJtb2NrZW1haWxhZGRyZXNzQG1vY2suY29tIiwiYXV0aG9yaXphdGlvbl9jb2RlIjoibW9ja1RoaXJkUGFydHlBdXRob3JpemF0aW9uQ29kZSJ9&x-source=com.paypal.ppclient.touch.v1-or-v2"];
                NSString *source = @"com.paypal.ppclient.touch.v1";
                
                BOOL canHandle = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:source];
                expect(canHandle).to.beTruthy();
                
                source = @"com.paypal.ppclient.touch.v2";
                
                canHandle = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:source];
                expect(canHandle).to.beTruthy();
                
                [mockApplication verify];
            }];
            
        });

        it(@"rejects return URLs that did not come from browser or app", ^{
            
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                [payPalDriver startAuthorizationWithCompletion:nil];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.Braintree-Demo.payments://onetouch/v1/success?payload=eyJ2ZXJzaW9uIjoyLCJhY2NvdW50X2NvdW50cnkiOiJVUyIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXhwaXJlc19pbiI6LTEsImRpc3BsYXlfbmFtZSI6Im1vY2tEaXNwbGF5TmFtZSIsInNjb3BlIjoiaHR0cHM6XC9cL3VyaS5wYXlwYWwuY29tXC9zZXJ2aWNlc1wvcGF5bWVudHNcL2Z1dHVyZXBheW1lbnRzIiwiZW1haWwiOiJtb2NrZW1haWxhZGRyZXNzQG1vY2suY29tIiwiYXV0aG9yaXphdGlvbl9jb2RlIjoibW9ja1RoaXJkUGFydHlBdXRob3JpemF0aW9uQ29kZSJ9&x-source=com.paypal.ppclient.touch.v1-or-v2"];
                NSString *source = @"com.something.else";
                
                BOOL canHandle = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:source];
                expect(canHandle).to.beFalsy();
                
                [mockApplication verify];
            }];
            
        });

        it(@"rejects other malformed URLs", ^{
            
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                [payPalDriver startAuthorizationWithCompletion:nil];
                
                // This malformed returnURL is just missing payload
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.Braintree-Demo.payments://onetouch/v1/success?x-source=com.paypal.ppclient.touch.v1-or-v2"];
                
                NSString *source = @"com.paypal.ppclient.touch.v2";
                
                BOOL canHandle = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:source];
                expect(canHandle).to.beFalsy();
                
                
                [mockApplication verify];
            }];
            
        });

        it(@"rejects returns when there is no app switch in progress", ^{
            
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.Braintree-Demo.payments://onetouch/v1/success?payload=eyJ2ZXJzaW9uIjoyLCJhY2NvdW50X2NvdW50cnkiOiJVUyIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXhwaXJlc19pbiI6LTEsImRpc3BsYXlfbmFtZSI6Im1vY2tEaXNwbGF5TmFtZSIsInNjb3BlIjoiaHR0cHM6XC9cL3VyaS5wYXlwYWwuY29tXC9zZXJ2aWNlc1wvcGF5bWVudHNcL2Z1dHVyZXBheW1lbnRzIiwiZW1haWwiOiJtb2NrZW1haWxhZGRyZXNzQG1vY2suY29tIiwiYXV0aG9yaXphdGlvbl9jb2RlIjoibW9ja1RoaXJkUGFydHlBdXRob3JpemF0aW9uQ29kZSJ9&x-source=com.paypal.ppclient.touch.v1-or-v2"];
                
                NSString *source = @"com.paypal.ppclient.touch.v2";
                
                BOOL canHandle = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:source];
                expect(canHandle).to.beFalsy();
                
                
                [mockApplication verify];
            }];
            
        });

        it(@"ignores the case of the URL Scheme to account for Safari's habit of downcasing URL schemes", ^{
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                [payPalDriver startAuthorizationWithCompletion:nil];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.braintree-demo.PaYmEnTs://onetouch/v1/success?payload=eyJ2ZXJzaW9uIjoyLCJhY2NvdW50X2NvdW50cnkiOiJVUyIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXhwaXJlc19pbiI6LTEsImRpc3BsYXlfbmFtZSI6Im1vY2tEaXNwbGF5TmFtZSIsInNjb3BlIjoiaHR0cHM6XC9cL3VyaS5wYXlwYWwuY29tXC9zZXJ2aWNlc1wvcGF5bWVudHNcL2Z1dHVyZXBheW1lbnRzIiwiZW1haWwiOiJtb2NrZW1haWxhZGRyZXNzQG1vY2suY29tIiwiYXV0aG9yaXphdGlvbl9jb2RlIjoibW9ja1RoaXJkUGFydHlBdXRob3JpemF0aW9uQ29kZSJ9&x-source=com.paypal.ppclient.touch.v1-or-v2"];
                NSString *source = @"com.paypal.ppclient.touch.v2";
                
                BOOL canHandle = [BTPayPalDriver canHandleAppSwitchReturnURL:returnURL sourceApplication:source];
                expect(canHandle).to.beTruthy();
                
                [mockApplication verify];
            }];
        });
    });

    describe(@"handling app switch returns", ^{
        
        afterEach(^{
            // Reset state of BTPayPalDriver after each test (execute BTPayPalHandleURLContinuation if set)
            [BTPayPalDriver handleAppSwitchReturnURL:[NSURL URLWithString:@""]];
        });
        
        it(@"ignores an irrelevant or malformed URL", ^{
            
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                [payPalDriver startAuthorizationWithCompletion:nil];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.braintree-demo.PaYmEnTs://----malformed----"];
                
                [[mockClient reject] savePaypalAccount:OCMOCK_ANY clientMetadataID:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
                
                [BTPayPalDriver handleAppSwitchReturnURL:returnURL];
                
                [mockClient verify];
            }];
            
        });

        it(@"accepts a success app switch return", ^{
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                [payPalDriver startAuthorizationWithCompletion:nil];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.braintree-demo.payments://onetouch/v1/success?payload=eyJ2ZXJzaW9uIjoyLCJhY2NvdW50X2NvdW50cnkiOiJVUyIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXhwaXJlc19pbiI6LTEsImRpc3BsYXlfbmFtZSI6Im1vY2tEaXNwbGF5TmFtZSIsInNjb3BlIjoiaHR0cHM6XC9cL3VyaS5wYXlwYWwuY29tXC9zZXJ2aWNlc1wvcGF5bWVudHNcL2Z1dHVyZXBheW1lbnRzIiwiZW1haWwiOiJtb2NrZW1haWxhZGRyZXNzQG1vY2suY29tIiwiYXV0aG9yaXphdGlvbl9jb2RlIjoibW9ja1RoaXJkUGFydHlBdXRob3JpemF0aW9uQ29kZSJ9&x-source=com.paypal.ppclient.touch.v1-or-v2"];
                
                [[mockClient expect] savePaypalAccount:OCMOCK_ANY clientMetadataID:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
                
                [BTPayPalDriver handleAppSwitchReturnURL:returnURL];
                
                [mockClient verify];
            }];
        });

        it(@"accepts a failure app switch return", ^{
            
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                [payPalDriver startAuthorizationWithCompletion:nil];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.braintree-demo.PaYmEnTs://onetouch/v1/failure?error=some+message"];
                
                XCTestExpectation *parseOtcExpectation = [self expectationWithDescription:@"Parse otc response"];

                [PayPalOneTouchCore parseResponseURL:returnURL
                                     completionBlock:^(PayPalOneTouchCoreResult *result) {
                                         expect(result.type).to.equal(PayPalOneTouchResultTypeError);
                                         [parseOtcExpectation fulfill];
                                     }];
                
                [self waitForExpectationsWithTimeout:10 handler:nil];

                [mockClient verify];
            }];
            


        });

        it(@"accepts a cancelation app switch return", ^{
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                [payPalDriver startAuthorizationWithCompletion:nil];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.braintree-demo.payments://onetouch/v1/cancel?payload=eyJ2ZXJzaW9uIjozLCJtc2dfR1VJRCI6IjQ1QUZEQkE3LUJEQTYtNDNEMi04MUY2LUY4REM1QjZEOTkzQSIsImVudmlyb25tZW50IjoibW9jayJ9&x-source=com.paypal.ppclient.touch.v2"];
                
                XCTestExpectation *parseOtcExpectation = [self expectationWithDescription:@"Parse otc response"];
                
                [PayPalOneTouchCore parseResponseURL:returnURL
                                     completionBlock:^(PayPalOneTouchCoreResult *result) {
                                         expect(result.type).to.equal(PayPalOneTouchResultTypeCancel);
                                         [parseOtcExpectation fulfill];
                                     }];
                
                [self waitForExpectationsWithTimeout:10 handler:nil];
                
                [mockClient verify];
            }];
        });

        it(@"tokenizes a success response, returning the payment method nonce to the developer", ^{
            
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication) {
                
                id ppOtcMock = [OCMockObject mockForClass:[PayPalOneTouchCore class]];
                [[[ppOtcMock stub] andReturnValue:@YES] canParseURL:OCMOCK_ANY sourceApplication:OCMOCK_ANY];
                
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                XCTestExpectation *completionExpectation = [self expectationWithDescription:@"authorization completion callback"];
                [payPalDriver startAuthorizationWithCompletion:^(BTPayPalPaymentMethod *payPalPaymentMethod, NSError *error) {
                    NSLog(@"startAuthorizationWithCompletion %@ %@", payPalPaymentMethod, error);
                    [completionExpectation fulfill];
                }];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.braintree-demo.payments://onetouch/v1/success?payloadEnc=IiRZ%2FKEnD6RQ8UeUmOFO8Ofh1RqQcWFycpO6pB9Yzl7fLb5szdaHanap7gwpmKsq4MJ2KGRJ0MzZBPvmoL%2BxkSH7%2FC%2F4WqeeVeGYvCpAvsPpkg%2BY8PID54FqVDpP1EXKS3Vx%2F6XmqbDplNLUUNzXZ4P%2FNcaXiEZXoHv6odjm7rxP3Ric%2Fsal9oiCDGDeFOAwTkiklA%2BA5nsASGopzrMHeIVBtcA01yae%2BDrgwPhHWNy6hffL2yVPVREtpVRBLrXK0jzn9IGUKMbBSMg%2F8BZ14ijhU%2F4cFlqi51NARQEFXMJcSba%2FscQTV1%2Fzj7D6B9W4pUYk9WY7eygmwMs%2BTYkTYnKRJjHTPWzMScdesYjj161c6DdWBFFtCVcanwvdk5rp1YCaElOmYV5WZSGKkSORCNMNKVKe8AkXMVO%2BPc41&payload=eyJ2ZXJzaW9uIjozLCJtc2dfR1VJRCI6IkNCNkY1Q0IwLUY4NEYtNEZEMC1BNzQ1LTdCMDE0MDQ0OUQyRSIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXJyb3IiOm51bGx9&x-source=com.braintree.browserswitch"];
                
                // We must call +[Braintree handleOpenURL:sourceApplication:] (not [BTPayPalDriver handleAppSwitchReturnURL:returnURL])
                // in order to test that the returnURL is passed through to BTPayPalDriver.
                // This was a real bug that shipped in 4.0.0-pre2 and was fixed in 625ae947ee92561934dfb1a3a2bf387d8890b91f.
                // Also, sourceApplication is verified by OTC.
                [Braintree handleOpenURL:returnURL sourceApplication:@"com.apple.mobilesafari"];
                
                // Note: -savePaypalAccount:clientMetadataID:success:failure: isn't actually called here.
                
                [self waitForExpectationsWithTimeout:5 handler:nil];
                
                [mockClient verify];
                
                [ppOtcMock stopMocking];
            }];
        });

        it(@"returns tokenization failures to the developer", ^{ //Todo
        });

        it(@"returns a failure to the developer", ^{ //Todo
        });

        it(@"returns a cancelation to the developer", ^{ //Todo
        });
        
        it(@"rejects returns when there is no app switch in progress", ^{
            [BTPayPalDriverSpecHelper setupSpec:^(NSString *returnURLScheme, id mockClient, id mockApplication){
                [[mockClient stub] postAnalyticsEvent:OCMOCK_ANY];
                
                // Both -canOpenURL: and -openURL: are checked by OTC
                [[[mockApplication stub] andReturnValue:@YES] canOpenURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                [[[mockApplication stub] andReturnValue:@YES] openURL:HC_hasProperty(@"scheme", @"com.paypal.ppclient.touch.v2")];
                
                __unused BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithClient:mockClient returnURLScheme:returnURLScheme];
                
                NSURL *returnURL = [NSURL URLWithString:@"com.braintreepayments.braintree-demo.payments://onetouch/v1/success?payload=eyJ2ZXJzaW9uIjoyLCJhY2NvdW50X2NvdW50cnkiOiJVUyIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXhwaXJlc19pbiI6LTEsImRpc3BsYXlfbmFtZSI6Im1vY2tEaXNwbGF5TmFtZSIsInNjb3BlIjoiaHR0cHM6XC9cL3VyaS5wYXlwYWwuY29tXC9zZXJ2aWNlc1wvcGF5bWVudHNcL2Z1dHVyZXBheW1lbnRzIiwiZW1haWwiOiJtb2NrZW1haWxhZGRyZXNzQG1vY2suY29tIiwiYXV0aG9yaXphdGlvbl9jb2RlIjoibW9ja1RoaXJkUGFydHlBdXRob3JpemF0aW9uQ29kZSJ9&x-source=com.paypal.ppclient.touch.v1-or-v2"];
                
                [[mockClient reject] savePaypalAccount:OCMOCK_ANY clientMetadataID:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
                
                [BTPayPalDriver handleAppSwitchReturnURL:returnURL];
                
                [mockClient verify];
            }];
        });
    });
});

SpecEnd
