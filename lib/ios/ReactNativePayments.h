@import UIKit;
@import PassKit;

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@interface ReactNativePayments : NSObject <RCTBridgeModule, PKPaymentAuthorizationViewControllerDelegate>
@property NSString *paymentProcessor;
@property NSString *paymentProcessorPublicKey;
@property NSString *backendUrl;

@property (nonatomic, strong) RCTResponseSenderBlock callback;
@property (nonatomic, strong) PKPaymentRequest *paymentRequest;
@property (nonatomic, strong) PKPaymentAuthorizationViewController *viewController;
@property (nonatomic, copy) void (^completion)(PKPaymentAuthorizationStatus);

@end