#import "BraintreeDemoPayPalScopesViewController.h"

#import <BraintreePayPal/BraintreePayPal.h>
#import <BraintreeUI/BraintreeUI.h>

@interface BraintreeDemoPayPalScopesViewController () <BTViewControllerPresentingDelegate>
@property(nonatomic, strong) UITextView *addressTextView;
@end

@implementation BraintreeDemoPayPalScopesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.addressTextView = [[UITextView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 2) - 100, (self.view.bounds.size.width / 8) * 7, 200, 100)];
    [self.view addSubview:self.addressTextView];
    self.addressTextView.backgroundColor = [UIColor clearColor];

    self.paymentButton.hidden = YES;
    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration * _Nullable configuration, NSError * _Nullable error) {
        if (error) {
            self.progressBlock(error.localizedDescription);
            return;
        }

        if (!configuration.isPayPalEnabled) {
            self.progressBlock(@"canCreatePaymentMethodWithProviderType: returns NO, hiding custom PayPal button");
        } else {
            self.paymentButton.hidden = NO;
        }
    }];
}

- (UIView *)createPaymentButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"PayPal (Address Scope)" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor blueColor] bt_adjustedBrightness:0.5] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(tappedCustomPayPal) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tappedCustomPayPal {
    BTPayPalDriver *driver = [[BTPayPalDriver alloc] initWithAPIClient:self.apiClient];
    driver.viewControllerPresentingDelegate = self;
    self.progressBlock(@"Tapped PayPal - initiating authorization using BTPayPalDriver");

    [driver authorizeAccountWithAdditionalScopes:[NSSet setWithArray:@[@"address"]] completion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
        if (error) {
            self.progressBlock(error.localizedDescription);
        } else if (tokenizedPayPalAccount) {
            self.completionBlock(tokenizedPayPalAccount);

            BTPostalAddress *address = tokenizedPayPalAccount.shippingAddress;
            self.addressTextView.text = [NSString stringWithFormat:@"Address:\n%@\n%@\n%@ %@\n%@ %@", address.streetAddress, address.extendedAddress, address.locality, address.region, address.postalCode, address.countryCodeAlpha2];
        } else {
            self.progressBlock(@"Cancelled");
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
