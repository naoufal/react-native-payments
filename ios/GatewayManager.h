@import PassKit;
#import <Foundation/Foundation.h>
#import "BraintreeCore.h"


@interface GatewayManager : NSObject

@property (nonatomic, strong) BTAPIClient * _Nullable braintreeClient;


+ (NSArray *_Nonnull)getSupportedGateways;
- (void)configureGateway:(NSDictionary *_Nonnull)gatewayParameters
      merchantIdentifier:(NSString *_Nonnull)merchantId;
- (void)createTokenWithPayment:(PKPayment *_Nonnull)payment
                    completion:(void (^_Nullable)(NSString * _Nullable token, NSError * _Nullable error))completion;

// Stripe
- (void)configureStripeGateway:(NSDictionary *_Nonnull)gatewayParameters
            merchantIdentifier:(NSString *_Nonnull)merchantId;
- (void)createStripeTokenWithPayment:(PKPayment *_Nonnull)payment
                          completion:(void (^_Nullable)(NSString * _Nullable token, NSError * _Nullable error))completion;

// Braintree
- (void)configureBraintreeGateway:(NSDictionary *_Nonnull)gatewayParameters;

- (void)createBraintreeTokenWithPayment:(PKPayment *_Nonnull)payment
                    completion:(void (^_Nullable)(NSString * _Nullable token, NSError * _Nullable error))completion;
@end
