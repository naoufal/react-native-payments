@import UIKit;
@import PassKit;

#import "RCTBridgeModule.h"

@interface ApplePayManager : NSObject <RCTBridgeModule, PKPaymentAuthorizationViewControllerDelegate>
@property NSString *paymentProcessor;
@property NSString *paymentProcessorPublicKey;
@property NSString *backendUrl;

@property (nonatomic, strong) RCTResponseSenderBlock callback;
@property (nonatomic, strong) PKPayment *payment;
@property (nonatomic, copy) void (^completion)(PKPaymentAuthorizationStatus);
@end