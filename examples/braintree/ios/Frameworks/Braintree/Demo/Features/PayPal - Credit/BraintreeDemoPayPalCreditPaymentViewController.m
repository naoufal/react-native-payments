#import "BraintreeDemoPayPalCreditPaymentViewController.h"

#import <BraintreePayPal/BraintreePayPal.h>

@interface BraintreeDemoPayPalCreditPaymentViewController () <BTAppSwitchDelegate, BTViewControllerPresentingDelegate>
@property (nonatomic, strong) UISegmentedControl *paypalTypeSwitch;
@end

@implementation BraintreeDemoPayPalCreditPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paypalTypeSwitch = [[UISegmentedControl alloc] initWithItems:@[@"Checkout", @"Billing Agreement"]];
    self.paypalTypeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    self.paypalTypeSwitch.selectedSegmentIndex = 0;
    [self.view addSubview:self.paypalTypeSwitch];
    NSDictionary *viewBindings = @{
                                   @"view": self,
                                   @"paypalTypeSwitch":self.paypalTypeSwitch
                                   };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[paypalTypeSwitch]-(50)-|" options:0 metrics:nil views:viewBindings]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[paypalTypeSwitch]-|" options:0 metrics:nil views:viewBindings]];

}

- (UIView *)createPaymentButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"PayPal with Credit Offered" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:50.0/255 green:50.0/255 blue:255.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(tappedPayPalOneTimePayment:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tappedPayPalOneTimePayment:(UIButton *)sender {
    
    if (self.paypalTypeSwitch.selectedSegmentIndex == 0) {
        self.progressBlock(@"Tapped - initiating Checkout payment with credit offered");
    } else {
        self.progressBlock(@"Tapped - initiating Billing Agreement payment with credit offered");
    }

    [sender setTitle:@"Processing..." forState:UIControlStateDisabled];
    [sender setEnabled:NO];

    BTPayPalDriver *driver = [[BTPayPalDriver alloc] initWithAPIClient:self.apiClient];
    driver.appSwitchDelegate = self;
    driver.viewControllerPresentingDelegate = self;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:@"4.30"];

    request.offerCredit = YES;

    if (self.paypalTypeSwitch.selectedSegmentIndex == 0) {
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
    } else {
        [driver requestBillingAgreement:request completion:^(BTPayPalAccountNonce * _Nullable payPalAccount, NSError * _Nullable error) {
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
