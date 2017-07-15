@import PassKit;

#import <Foundation/Foundation.h>

@interface GatewayManager : NSObject
+ (NSArray *_Nonnull)getSupportedGateways;
+ (void)configureGateway:(NSDictionary *_Nonnull)gatewayParameters
      merchantIdentifier:(NSString *_Nonnull)merchantId;
+ (void)createTokenWithPayment:(PKPayment *_Nonnull)payment
                    completion:(void (^_Nullable)(NSString * _Nullable token, NSError * _Nullable error))completion;

// Stripe
+ (void)configureStripeGateway:(NSDictionary *_Nonnull)gatewayParameters
            merchantIdentifier:(NSString *_Nonnull)merchantId;
+ (void)createStripeTokenWithPayment:(PKPayment *_Nonnull)payment
                          completion:(void (^_Nullable)(NSString * _Nullable token, NSError * _Nullable error))completion;

@end
