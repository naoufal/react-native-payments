#import "BraintreeDemoBTPaymentButtonViewController.h"
#import <PureLayout/ALView+PureLayout.h>
#import "BraintreeDemoPaymentButtonBaseViewController.h"
#import <BraintreeCore/BraintreeCore.h>

@implementation BraintreeDemoPaymentButtonBaseViewController

- (instancetype)initWithAuthorization:(NSString *)authorization {
    self = [super initWithAuthorization:authorization];
    if (self) {
        self.apiClient = [[BTAPIClient alloc] initWithAuthorization:authorization];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Payment Button";

    [self.view setBackgroundColor:[UIColor colorWithRed:250.0f/255.0f green:253.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];

    self.paymentButton = [self createPaymentButton];
    [self.view addSubview:self.paymentButton];

    [self.paymentButton autoCenterInSuperviewMargins];
    // This margin is important for the Apple Pay button.
    // BTPaymentButton looks fine without, but it's also not too terrible with it.
    [self.paymentButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:20];
    [self.paymentButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:20];
    [self.paymentButton autoSetDimension:ALDimensionHeight toSize:44 relation:NSLayoutRelationGreaterThanOrEqual];
}

- (UIView *)createPaymentButton {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Subclasses of BraintreeDemoPaymentButtonViewController must override createPaymentButton. BraintreeDemoPaymentButtonViewController should not be initialized directly."
                                 userInfo:nil];
}

@end
