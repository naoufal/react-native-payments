#import "BTClientToken.h"
#import "BTClient+BTPayPal.h"
#import "PayPalMobile.h"
#import "BTErrors+BTPayPal.h"
#import "BTTestClientTokenFactory.h"
#import "BTConfiguration.h"
#import "BTClient+Offline.h"

#import "BTClient_Internal.h"
#import "BTClientSpecHelper.h"

SharedExamplesBegin(BTClient_BTPayPalSpec)

sharedExamplesFor(@"a BTClient", ^(NSDictionary *data) {
    
    __block BOOL asyncClient = [data[@"asyncClient"] boolValue];
    __block NSMutableDictionary *mutableClaims;
    
    beforeEach(^{
        
        NSDictionary *paypalClaims = @{
                                       BTConfigurationKeyPayPalMerchantName: @"PayPal Merchant",
                                       BTConfigurationKeyPayPalMerchantPrivacyPolicyUrl: @"http://merchant.example.com/privacy",
                                       BTConfigurationKeyPayPalMerchantUserAgreementUrl: @"http://merchant.example.com/tos",
                                       BTConfigurationKeyPayPalClientId: @"PayPal-Test-Merchant-ClientId",
                                       BTConfigurationKeyPayPalDirectBaseUrl: @"http://api.paypal.example.com"
                                       };
        
        NSDictionary *baseClaims = @{
                                     BTConfigurationKeyClientApiURL: @"http://gateway.example.com/client_api",
                                     BTConfigurationKeyPayPalEnabled: @YES,
                                     BTConfigurationKeyPayPal: [paypalClaims mutableCopy] };
        
        
        mutableClaims = [baseClaims mutableCopy];
    });
    
    describe(@"btPayPal_preparePayPalMobileWithError", ^{
        
        describe(@"in Live PayPal environment", ^{
            describe(@"btPayPal_payPalEnvironment", ^{
                it(@"returns PayPal mSDK notion of Live", ^{
                    mutableClaims[@"paypal"][@"environment"] = BTConfigurationPayPalEnvironmentLive;
                    BTClient * client = [BTClientSpecHelper clientForTestCase:self withOverrides:mutableClaims async:asyncClient];
                    expect([client btPayPal_environment]).to.equal(PayPalEnvironmentProduction);
                });
            });
        });
        
        describe(@"with custom PayPal environment", ^{
            it(@"does not return an error with the valid set of claims", ^{
                mutableClaims[@"paypal"][@"environment"] = BTConfigurationPayPalEnvironmentCustom;
                BTClient * client = [BTClientSpecHelper clientForTestCase:self withOverrides:mutableClaims async:asyncClient];
                NSError *error;
                BOOL success = [client btPayPal_preparePayPalMobileWithError:&error];
                expect(error).to.beNil();
                expect(success).to.beTruthy();
            });
            
            it(@"returns an error if the client ID is present but the Base URL is missing", ^{
                mutableClaims[@"paypal"][@"directBaseUrl"] = [NSNull null];
                mutableClaims[@"paypal"][@"environment"] = BTConfigurationPayPalEnvironmentCustom;
                BTClient * client = [BTClientSpecHelper clientForTestCase:self withOverrides:mutableClaims async:asyncClient];
                NSError *error;
                BOOL success = [client btPayPal_preparePayPalMobileWithError:&error];
                expect(error.code).to.equal(BTMerchantIntegrationErrorPayPalConfiguration);
                expect(error.userInfo).notTo.beNil();
                expect(success).to.beFalsy();
            });
            
            it(@"returns an error if the PayPal Base URL is present but the client ID is missing", ^{
                mutableClaims[@"paypal"][@"clientId"] = [NSNull null];
                mutableClaims[@"paypal"][@"environment"] = BTConfigurationPayPalEnvironmentCustom;
                BTClient * client = [BTClientSpecHelper clientForTestCase:self withOverrides:mutableClaims async:asyncClient];
                NSError *error;
                [client btPayPal_preparePayPalMobileWithError:&error];
                expect(error.code).to.equal(BTMerchantIntegrationErrorPayPalConfiguration);
                expect(error.userInfo).notTo.beNil();
            });
            
            describe(@"btPayPal_payPalEnvironment", ^{
                it(@"returns a pretty custom environment name", ^{
                    mutableClaims[@"paypal"][@"environment"] = BTConfigurationPayPalEnvironmentCustom;
                    BTClient * client = [BTClientSpecHelper clientForTestCase:self withOverrides:mutableClaims async:asyncClient];
                    expect([client btPayPal_environment]).to.equal(BTClientPayPalMobileEnvironmentName);
                });
            });
        });
        
        describe(@"when the environment is not production", ^{
            describe(@"if the merchant privacy policy URL, merchant agreement URL, merchant name, and client ID are missing", ^{
                it(@"does not return an error", ^{
                    mutableClaims[@"paypal"][BTConfigurationKeyPayPalMerchantPrivacyPolicyUrl] = [NSNull null];
                    mutableClaims[@"paypal"][BTConfigurationKeyPayPalMerchantUserAgreementUrl] = [NSNull null];
                    mutableClaims[@"paypal"][BTConfigurationKeyPayPalMerchantName] = [NSNull null];
                    mutableClaims[@"paypal"][@"environment"] = BTConfigurationPayPalEnvironmentCustom;
                    BTClient * client = [BTClientSpecHelper clientForTestCase:self withOverrides:mutableClaims async:asyncClient];
                    NSError *error;
                    [client btPayPal_preparePayPalMobileWithError:&error];
                    expect(error).to.beNil();
                });
            });
            
        });
    });
    
    describe(@"scopes", ^{
        it(@"includes email and future payments", ^{
            mutableClaims[@"paypal"][@"environment"] = BTConfigurationPayPalEnvironmentLive;
            BTClient * client = [BTClientSpecHelper clientForTestCase:self withOverrides:mutableClaims async:asyncClient];
            NSSet *scopes = [client btPayPal_scopes];
            expect(scopes).to.contain(@"email");
            expect(scopes).to.contain(@"https://uri.paypal.com/services/payments/futurepayments");
        });
        
        it(@"does not contain address scope by default", ^{
            mutableClaims[@"paypal"][@"environment"] = BTConfigurationPayPalEnvironmentLive;
            BTClient * client = [BTClientSpecHelper clientForTestCase:self withOverrides:mutableClaims async:asyncClient];
            NSSet *scopes = [client btPayPal_scopes];
            expect(scopes).toNot.contain(@"address");
        });
        
        it(@"includes additional scopes and default scopes (email and future payments)", ^{
            mutableClaims[@"paypal"][@"environment"] = BTConfigurationPayPalEnvironmentLive;
            BTClient * client = [BTClientSpecHelper clientForTestCase:self withOverrides:mutableClaims async:asyncClient];
            client.additionalPayPalScopes = [NSSet setWithObjects:@"address", nil];
            NSSet *scopes = [client btPayPal_scopes];
            expect(scopes).to.contain(@"address");
            expect(scopes).to.contain(@"email");
            expect(scopes).to.contain(@"https://uri.paypal.com/services/payments/futurepayments");
        });
        
    });
    
});

SharedExamplesEnd

SpecBegin(DeprecatedBTClient)

describe(@"shared initialization behavior", ^{
    NSDictionary* data = @{@"asyncClient": @NO};
    itShouldBehaveLike(@"a BTClient", data);
});

SpecEnd

SpecBegin(AsyncBTClient)

describe(@"shared initialization behavior", ^{
    NSDictionary* data = @{@"asyncClient": @YES};
    itShouldBehaveLike(@"a BTClient", data);
});

SpecEnd
