#import "Stripe.h"
#import "RCTBridgeModule.h"

@interface StripeManager : NSObject
+ (void)handlePaymentAuthorizationWithPayment:(NSString *)publishableKey
                                      payment:(PKPayment *)payment
                                   completion:(void (^)(PKPaymentAuthorizationStatus))completion
                                     callback:(RCTResponseSenderBlock)callback;
@end
