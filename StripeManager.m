#import "StripeManager.h"
#import "ApplePayManager.h"

@implementation StripeManager

+ (void)handlePaymentAuthorizationWithPayment:(NSString *)publishableKey
                                      payment:(PKPayment *)payment
                                   completion:(void (^)(PKPaymentAuthorizationStatus))completion
                                     callback:(RCTResponseSenderBlock)callback

{
    // Set Stripe Pubishable Key
    [Stripe setDefaultPublishableKey:publishableKey];
    
    // Create Token
    
//    [[STPAPIClient sharedClient] createTokenWithPayment:payment completion:^(STPToken *token, NSError *error)
//    {
//        // Error creating token with Stripe
//        if (error) {
//            NSLog(@"error: %@", error);
//            completion(PKPaymentAuthorizationStatusFailure);
//            return;
//        }
    
//        [self createBackendChargeWithToken:token completion:completion];
//
//    }];
    
    // Creating Tokens with ApplePay Test Cards currently fails.  So for now we'll just create tokens with a Stripe Test Card.
    STPCard *card = [[STPCard alloc] init];
    card.number = @"4242 4242 4242 4242";
    card.expMonth = 11;
    card.expYear = 19;
    card.cvc = @"310";
    
    [[STPAPIClient sharedClient] createTokenWithCard:card completion:^(STPToken *token, NSError *error)
    {
        if (error) {
            NSLog(@"Stripe Error: %@", error);
            completion(PKPaymentAuthorizationStatusFailure);
            return;
        } else {
            NSLog(@"Stripe Token: %@", token.tokenId);
            
            // Send token to JS
            callback(@[[NSNull null], token.tokenId]);
        }
    }];
}

@end
