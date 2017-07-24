#import "BTDropInViewController.h"
#import "BTDropInContentView.h"
#import "BTViewControllerPresentingDelegate.h"

@interface BTDropInViewController ()

@property (nonatomic, strong) BTDropInContentView *dropInContentView;

- (BTDropInViewController *)addPaymentMethodDropInViewController;

// Exposed for internal testing of presenting view controllers from top
- (void)paymentDriver:(__unused id)driver requestsPresentationOfViewController:(UIViewController *)viewController;

@end
