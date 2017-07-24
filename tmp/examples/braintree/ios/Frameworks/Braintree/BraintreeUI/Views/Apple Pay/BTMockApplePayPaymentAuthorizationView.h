#import <UIKit/UIKit.h>

@protocol BTMockApplePayPaymentAuthorizationViewDelegate;

@interface BTMockApplePayPaymentAuthorizationView : UIView

- (instancetype)initWithDelegate:(id<BTMockApplePayPaymentAuthorizationViewDelegate>)delegate;

@end

@protocol BTMockApplePayPaymentAuthorizationViewDelegate <NSObject>

- (void)mockApplePayPaymentAuthorizationViewDidSucceed:(BTMockApplePayPaymentAuthorizationView *)view;
- (void)mockApplePayPaymentAuthorizationViewDidCancel:(BTMockApplePayPaymentAuthorizationView *)view;

@end
