#import "BraintreeDemoDropInLegacyViewController.h"

#import <PureLayout/PureLayout.h>
#import <BraintreeCore/BraintreeCore.h>
#import <BraintreeUI/BraintreeUI.h>
#import <BraintreeVenmo/BraintreeVenmo.h>
#import "BraintreeDemoSettings.h"

@interface BraintreeDemoDropInLegacyViewController () <BTDropInViewControllerDelegate>

@property (nonatomic, strong) BTAPIClient *apiClient;

@end

@implementation BraintreeDemoDropInLegacyViewController

- (instancetype)initWithAuthorization:(NSString *)authorization {
    if (self = [super initWithAuthorization:authorization]) {
        _apiClient = [[BTAPIClient alloc] initWithAuthorization:authorization];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Drop In (Legacy)";

    UIButton *dropInButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dropInButton.translatesAutoresizingMaskIntoConstraints = NO;
    [dropInButton addTarget:self action:@selector(tappedToShowDropIn) forControlEvents:UIControlEventTouchUpInside];
    [dropInButton setBackgroundColor:[UIColor redColor]];
    [dropInButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    dropInButton.layer.cornerRadius = 5.0f;
    dropInButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [dropInButton setTitle:@"Buy Now" forState:UIControlStateNormal];
    [dropInButton sizeToFit];

    [self.view addSubview:dropInButton];
    [dropInButton autoCenterInSuperview];

    self.progressBlock(@"Ready to present Drop In (Old)");
}

- (void)tappedToShowDropIn {
    BTPaymentRequest *paymentRequest = [[BTPaymentRequest alloc] init];
    paymentRequest.summaryTitle = @"Our Fancy Magazine";
    paymentRequest.summaryDescription = @"53 Week Subscription";
    paymentRequest.displayAmount = @"$19.00";
    paymentRequest.callToActionText = @"$19 - Subscribe Now";
    paymentRequest.shouldHideCallToAction = NO;
    BTDropInViewController *dropIn = [[BTDropInViewController alloc] initWithAPIClient:self.apiClient];
    dropIn.delegate = self;
    dropIn.paymentRequest = paymentRequest;
    dropIn.title = @"Check Out";

    if ([BraintreeDemoSettings useModalPresentation]) {
        self.progressBlock(@"Presenting Drop In Modally");
        dropIn.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tappedCancel)];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dropIn];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        self.progressBlock(@"Pushing Drop In on nav stack");
        [self.navigationController pushViewController:dropIn animated:YES];
    }
}


- (void)tappedCancel {
    self.progressBlock(@"Dismissing Drop In");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BTDropInViewControllerDelegate

// Renamed from -dropInViewController:didSucceedWithPaymentMethod:
- (void)dropInViewController:(BTDropInViewController *)viewController didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    if ([BraintreeDemoSettings useModalPresentation]) {
        [viewController dismissViewControllerAnimated:YES completion:^{
            self.completionBlock(paymentMethodNonce);
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        self.completionBlock(paymentMethodNonce);
    }
}

- (void)dropInViewControllerWillComplete:(__unused BTDropInViewController *)viewController {
    self.progressBlock(@"Drop In Will Complete");
}

- (void)dropInViewControllerDidCancel:(BTDropInViewController *)viewController {
    self.progressBlock(@"User Canceled Drop In");
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
