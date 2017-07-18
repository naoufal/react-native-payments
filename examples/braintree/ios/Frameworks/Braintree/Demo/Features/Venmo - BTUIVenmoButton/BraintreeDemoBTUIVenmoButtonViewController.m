#import "BraintreeDemoBTUIVenmoButtonViewController.h"
#import <BraintreeVenmo/BraintreeVenmo.h>
#import <BraintreeUI/BraintreeUI.h>

@interface BraintreeDemoBTUIVenmoButtonViewController ()
@property (nonatomic, strong) BTUIVenmoButton *venmoButton;
@end

@implementation BraintreeDemoBTUIVenmoButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BTUIVenmoButton";
    self.venmoButton.hidden = YES;
    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration * _Nullable __unused configuration, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                self.progressBlock(error.localizedDescription);
                NSLog(@"Failed to fetch configuration: %@", error);
                return;
            }
        });
    }];
}

- (UIView *)createPaymentButton {
    if (!self.venmoButton) {
        self.venmoButton = [[BTUIVenmoButton alloc] init];
        [self.venmoButton addTarget:self action:@selector(tappedPayPalButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self.venmoButton;
}

- (void)tappedPayPalButton {
    self.progressBlock(@"Tapped Venmo - initiating Venmo auth");

    BTVenmoDriver *driver = [[BTVenmoDriver alloc] initWithAPIClient:self.apiClient];
    
    [driver authorizeAccountAndVault:YES completion:^(BTVenmoAccountNonce * _Nullable venmoAccount, NSError * _Nullable error) {
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
