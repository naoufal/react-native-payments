#import "BraintreeDemoBTPaymentButtonViewController.h"
#import <BraintreeCard/BraintreeCard.h>
#import <BraintreeUI/BraintreeUI.h>
#import <PureLayout/ALView+PureLayout.h>

@interface BraintreeDemoBTPaymentButtonViewController () <BTAppSwitchDelegate, UITableViewDelegate, BTViewControllerPresentingDelegate>
@end

@implementation BraintreeDemoBTPaymentButtonViewController

- (UIView *)createPaymentButton {
    BTPaymentButton *paymentButton = [[BTPaymentButton alloc] initWithAPIClient:self.apiClient completion:^(BTPaymentMethodNonce *paymentMethodNonce, NSError *error) {
        if (paymentMethodNonce) {
            self.progressBlock(@"Got a nonce 💎!");
            NSLog(@"%@", [paymentMethodNonce debugDescription]);
            self.completionBlock(paymentMethodNonce);
        } else if (error) {
            self.progressBlock(error.localizedDescription);
        } else {
            self.progressBlock(@"Canceled 🔰");
        }
    }];
    paymentButton.appSwitchDelegate = self;
    paymentButton.viewControllerPresentingDelegate = self;
    return paymentButton;
}


- (void)appSwitcherWillPerformAppSwitch:(__unused id)appSwitcher {
    self.progressBlock(@"Will perform app switch");
}

- (void)appSwitcher:(__unused id)appSwitcher didPerformSwitchToTarget:(__unused BTAppSwitchTarget)target {
    self.progressBlock(@"Did perform app switch");
}

- (void)appSwitcherWillProcessPaymentInfo:(__unused id)appSwitcher {
    self.progressBlock(@"Processing payment info...");
}

- (void)paymentDriver:(__unused id)driver requestsPresentationOfViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)paymentDriver:(__unused id)driver requestsDismissalOfViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
