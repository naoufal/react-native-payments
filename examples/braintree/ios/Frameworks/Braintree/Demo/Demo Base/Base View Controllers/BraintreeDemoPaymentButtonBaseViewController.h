#import <Foundation/Foundation.h>
#import "BraintreeDemoBaseViewController.h"
#import <BraintreeCore/BraintreeCore.h>

@interface BraintreeDemoPaymentButtonBaseViewController : BraintreeDemoBaseViewController

@property (nonatomic, strong) BTAPIClient *apiClient;
@property (nonatomic, strong) UIView *paymentButton;

/// A factory method that subclasses must implement to return a payment button view.
- (UIView *)createPaymentButton;

@end
