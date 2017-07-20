@import PassKit;

#import <Foundation/Foundation.h>

#if __has_include(<BraintreeApplePay/BraintreeApplePay.h>)
#import <BraintreeApplePay/BraintreeApplePay.h>
#endif

@interface GatewayManager : NSObject
#if __has_include(<BraintreeApplePay/BraintreeApplePay.h>)
@property (nonatomic, strong) BTAPIClient * _Nullable braintreeClient;
#endif

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
