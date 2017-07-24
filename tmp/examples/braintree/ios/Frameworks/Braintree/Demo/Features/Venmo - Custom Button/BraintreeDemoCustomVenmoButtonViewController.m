#import "BraintreeDemoCustomVenmoButtonViewController.h"
#import <BraintreeVenmo/BraintreeVenmo.h>
#import <BraintreeUI/UIColor+BTUI.h>


@interface BraintreeDemoCustomVenmoButtonViewController ()
@property (nonatomic, strong) BTVenmoDriver *venmoDriver;
@end

@implementation BraintreeDemoCustomVenmoButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.venmoDriver = [[BTVenmoDriver alloc] initWithAPIClient:self.apiClient];
    self.title = @"Custom Venmo Button";
    self.paymentButton.hidden = [self.venmoDriver isiOSAppAvailableForAppSwitch];
}

- (UIView *)createPaymentButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Venmo (custom button)" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor bt_colorFromHex:@"3D95CE" alpha:1.0f] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor bt_colorFromHex:@"3D95CE" alpha:1.0f] bt_adjustedBrightness:0.7] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(tappedCustomVenmo) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)tappedCustomVenmo {
    self.progressBlock(@"Tapped Venmo - initiating Venmo auth");
    [self.venmoDriver authorizeAccountAndVault:NO completion:^(BTVenmoAccountNonce * _Nullable venmoAccount, NSError * _Nullable error) {
        if (venmoAccount) {
            self.progressBlock(@"Got a nonce 💎!");
            NSLog(@"%@", [venmoAccount debugDescription]);
            self.completionBlock(venmoAccount);
        } else if (error) {
            self.progressBlock(error.localizedDescription);
        } else {
            self.progressBlock(@"Canceled 🔰");
        }
    }];
}

@end
