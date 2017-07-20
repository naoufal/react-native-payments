#import "BTVenmoAppSwitchReturnURL.h"
#import "BTSpecHelper.h"
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

SpecBegin(BTVenmoAppSwitchReturnURL)

describe(@"URL parsing", ^{
    describe(@"valid success return URL", ^{
        it(@"creates the payment method", ^{
            BTVenmoAppSwitchReturnURL *returnURL = [[BTVenmoAppSwitchReturnURL alloc] initWithURL:[NSURL URLWithString:@"com.example.app://x-callback-url/vzero/auth/venmo/success?paymentMethodNonce=a-nonce"]];
            expect(returnURL.nonce).to.equal(@"a-nonce");
            expect(returnURL.error).to.beNil();
        });

        it(@"sets the state to succeeded", ^{
            BTVenmoAppSwitchReturnURL *returnURL = [[BTVenmoAppSwitchReturnURL alloc] initWithURL:[NSURL URLWithString:@"com.example.app://x-callback-url/vzero/auth/venmo/success?paymentMethodNonce=a-nonce"]];
            expect(returnURL.state).to.equal(BTVenmoAppSwitchReturnURLStateSucceeded);
        });

    });

    describe(@"valid cancel return URL", ^{
        it(@"sets the state canceled", ^{
            BTVenmoAppSwitchReturnURL *returnURL = [[BTVenmoAppSwitchReturnURL alloc] initWithURL:[NSURL URLWithString:@"com.example.app://x-callback-url/vzero/auth/venmo/cancel"]];

            expect(returnURL.state).to.equal(BTVenmoAppSwitchReturnURLStateCanceled);
        });

        it(@"does not parse an error or payment method", ^{
            BTVenmoAppSwitchReturnURL *returnURL = [[BTVenmoAppSwitchReturnURL alloc] initWithURL:[NSURL URLWithString:@"com.example.app://x-callback-url/vzero/auth/venmo/cancel"]];

            expect(returnURL.error).to.beNil();
            expect(returnURL.nonce).to.beNil();
        });
    });

    describe(@"valid error return URL", ^{
        it(@"sets the state to failed", ^{
            BTVenmoAppSwitchReturnURL *returnURL = [[BTVenmoAppSwitchReturnURL alloc] initWithURL:[NSURL URLWithString:@"com.example.app://x-callback-url/vzero/auth/venmo/error?errorMessage=Venmo%20Fail&errorCode=-7"]];
            expect(returnURL.state).to.equal(BTVenmoAppSwitchReturnURLStateFailed);
        });

        it(@"parses the error message and code from a failed Venmo App Switch return", ^{
            BTVenmoAppSwitchReturnURL *returnURL = [[BTVenmoAppSwitchReturnURL alloc] initWithURL:[NSURL URLWithString:@"com.example.app://x-callback-url/vzero/auth/venmo/error?errorMessage=Venmo%20Fail&errorCode=-7"]];

            expect(returnURL.nonce).to.beNil();
            expect(returnURL.error).to.equal([NSError errorWithDomain:BTVenmoAppSwitchReturnURLErrorDomain
                                                                 code:-7
                                                             userInfo:@{
                                                                        NSLocalizedDescriptionKey: @"Venmo Fail"
                                                                        }]);
        });
    });

    describe(@"invalid return URL", ^{
        it(@"sets the state to unknown", ^{
            BTVenmoAppSwitchReturnURL *returnURL = [[BTVenmoAppSwitchReturnURL alloc] initWithURL:[NSURL URLWithString:@"com.example.app://x-callback-url/vzero/auth/venmo/something"]];
            expect(returnURL.state).to.equal(BTVenmoAppSwitchReturnURLStateUnknown);
        });
    });
});

describe(@"isValidURL:sourceApplication:", ^{
    NSURL *url = [NSURL URLWithString:@"scheme://x-callback-url/vzero/auth/venmo/foo"];

    it(@"accepts app switches received from Venmo", ^{
        expect([BTVenmoAppSwitchReturnURL isValidURL:url sourceApplication:@"net.kortina.labs.Venmo"]).to.beTruthy();
    });

    it(@"accepts app switches received from other Venmo builds", ^{
        expect([BTVenmoAppSwitchReturnURL isValidURL:url sourceApplication:@"net.kortina.labs.Venmo.debug"]).to.beTruthy();
        expect([BTVenmoAppSwitchReturnURL isValidURL:url sourceApplication:@"net.kortina.labs.Venmo.internal"]).to.beTruthy();
        expect([BTVenmoAppSwitchReturnURL isValidURL:url sourceApplication:@"net.kortina.labs.Venmo.some-new-feature"]).to.beTruthy();
    });

    it(@"accepts app switches received from PayPal Debug (for developer-facing test wallet)", ^{
        expect([BTVenmoAppSwitchReturnURL isValidURL:url sourceApplication:@"com.paypal.PPClient.Debug"]).to.beTruthy();
    });

    it(@"rejects app switches received from all others", ^{
        expect([BTVenmoAppSwitchReturnURL isValidURL:url sourceApplication:@"com.YourCompany.Some-App"]).to.beFalsy();
    });
});

SpecEnd
