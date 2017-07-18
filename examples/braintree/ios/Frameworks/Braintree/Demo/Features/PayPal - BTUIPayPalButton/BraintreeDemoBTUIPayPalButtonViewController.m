#import "BraintreeDemoBTUIPayPalButtonViewController.h"
#import "BTUIPaymentButtonCollectionViewCell.h"
#import <BraintreePayPal/BraintreePayPal.h>
#import <BraintreeUI/BraintreeUI.h>

@interface BraintreeDemoBTUIPayPalButtonViewController () <BTViewControllerPresentingDelegate>
@end

@implementation BraintreeDemoBTUIPayPalButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BTUIPayPalButton";

    self.paymentButton.hidden = YES;
    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration * _Nullable configuration, NSError * _Nullable error) {
        if (error) {
            self.progressBlock(@"Failed to fetch configuration");
            NSLog(@"Failed to fetch configuration: %@", error);
            return;
        }

        if (!configuration.isPayPalEnabled) {
            self.progressBlock(@"canCreatePaymentMethodWithProviderType: returns NO, hiding PayPal button");
        } else {
            self.paymentButton.hidden = NO;
        }
    }];
}

- (UIView *)createPaymentButton {
    BTUIPayPalButton *payPalButton = [[BTUIPayPalButton alloc] init];
    [payPalButton addTarget:self action:@selector(tappedPayPalButton) forControlEvents:UIControlEventTouchUpInside];
    return payPalButton;
}

- (void)tappedPayPalButton {
    BTPayPalDriver *payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:self.apiClient];
    payPalDriver.viewControllerPresentingDelegate = self;
    [payPalDriver authorizeAccountWithCompletion:^(BTPayPalAccountNonce * _Nullable tokenizedPayPalAccount, NSError * _Nullable error) {
        if (tokenizedPayPalAccount) {
            self.progressBlock(@"Got a nonce 💎!");
            NSLog(@"%@", [tokenizedPayPalAccount debugDescription]);
            self.completionBlock(tokenizedPayPalAccount);
        } else if (error) {
            self.progressBlock(error.localizedDescription);
        } else {
            self.progressBlock(@"Canceled 🔰");
        }
    }];
}

- (void)paymentDriver:(__unused id)driver requestsPresentationOfViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)paymentDriver:(__unused id)driver requestsDismissalOfViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
