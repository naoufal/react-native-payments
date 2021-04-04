#import "GatewayManager.h"
#import "BraintreeCore.h"
#import "BraintreeApplePay.h"


@implementation GatewayManager

+ (NSArray *)getSupportedGateways
{
    NSMutableArray *supportedGateways = [NSMutableArray array];

    [supportedGateways addObject:@"braintree"];

    return [supportedGateways copy];
}

- (void)configureGateway:(NSDictionary *_Nonnull)gatewayParameters
      merchantIdentifier:(NSString *_Nonnull)merchantId
{



    if ([gatewayParameters[@"gateway"] isEqualToString:@"braintree"]) {
        [self configureBraintreeGateway:gatewayParameters];
    }

}

- (void)createTokenWithPayment:(PKPayment *_Nonnull)payment
                    completion:(void (^_Nullable)(NSString * _Nullable token, NSError * _Nullable error))completion
{

    [self createBraintreeTokenWithPayment:payment completion:completion];

}

// Stripe
- (void)configureStripeGateway:(NSDictionary *_Nonnull)gatewayParameters
            merchantIdentifier:(NSString *_Nonnull)merchantId
{

}

- (void)createStripeTokenWithPayment:(PKPayment *)payment completion:(void (^)(NSString * _Nullable, NSError * _Nullable))completion
{
}

// Braintree
- (void)configureBraintreeGateway:(NSDictionary *_Nonnull)gatewayParameters
{

    NSString *braintreeTokenizationKey = gatewayParameters[@"braintree:tokenizationKey"];
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:braintreeTokenizationKey];

}

- (void)createBraintreeTokenWithPayment:(PKPayment *_Nonnull)payment
                    completion:(void (^_Nullable)(NSString * _Nullable token, NSError * _Nullable error))completion
{

    BTApplePayClient *applePayClient = [[BTApplePayClient alloc]
                                        initWithAPIClient:self.braintreeClient];

    [applePayClient tokenizeApplePayPayment:payment
                                 completion:^(BTApplePayCardNonce *tokenizedApplePayPayment,
                                              NSError *error)
    {
        if (error) {

            completion(nil, error);
        } else {

            completion(tokenizedApplePayPayment.nonce, nil);
        }
    }];

}

@end
