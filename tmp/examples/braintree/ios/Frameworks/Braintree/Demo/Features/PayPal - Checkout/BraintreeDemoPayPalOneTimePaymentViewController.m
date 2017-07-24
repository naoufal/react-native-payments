#import "BraintreeDemoPayPalOneTimePaymentViewController.h"

#import <BraintreePayPal/BraintreePayPal.h>

@interface BraintreeDemoPayPalOneTimePaymentViewController () <BTAppSwitchDelegate, BTViewControllerPresentingDelegate>

@end

@implementation BraintreeDemoPayPalOneTimePaymentViewController

- (UIView *)createPaymentButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"PayPal one-time payment" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:50.0/255 green:50.0/255 blue:255.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(tappedPayPalOneTimePayment:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tappedPayPalOneTimePayment:(UIButton *)sender {
    self.progressBlock(@"Tapped PayPal - initiating one-time payment using BTPayPalDriver");

    [sender setTitle:@"Processing..." forState:UIControlStateDisabled];
    [sender setEnabled:NO];

    BTPayPalDriver *driver = [[BTPayPalDriver alloc] initWithAPIClient:self.apiClient];
    driver.appSwitchDelegate = self;
    driver.viewControllerPresentingDelegate = self;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:@"4.30"];
    [driver requestOneTimePayment:request completion:^(BTPayPalAccountNonce * _Nullable payPalAccount, NSError * _Nullable error) {
        [sender setEnabled:YES];

        if (error) {
            self.progressBlock(error.localizedDescription);
        } else if (payPalAccount) {
            self.completionBlock(payPalAccount);
        } else {
            self.progressBlock(@"Cancelled");
        }
    }];
}

#pragma mark BTAppSwitchDelegate

- (void)appSwitcherWillPerformAppSwitch:(__unused id)appSwitcher {
   self.progressBlock(@"paymentDriverWillPerformAppSwitch:");
}

- (void)appSwitcherWillProcessPaymentInfo:(__unused id)appSwitcher {
    self.progressBlock(@"paymentDriverWillProcessPaymentInfo:");
}

- (void)appSwitcher:(__unused id)appSwitcher didPerformSwitchToTarget:(BTAppSwitchTarget)target {
    switch (target) {
        case BTAppSwitchTargetWebBrowser:
            self.progressBlock(@"appSwitcher:didPerformSwitchToTarget: browser");
            break;
        case BTAppSwitchTargetNativeApp:
            self.progressBlock(@"appSwitcher:didPerformSwitchToTarget: app");
            break;
        case BTAppSwitchTargetUnknown:
            self.progressBlock(@"appSwitcher:didPerformSwitchToTarget: unknown");
            break;
    }
}

- (void)paymentDriver:(__unused id)driver requestsPresentationOfViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)paymentDriver:(__unused id)driver requestsDismissalOfViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
