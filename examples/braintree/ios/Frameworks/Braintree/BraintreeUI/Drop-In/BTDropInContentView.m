#import "BTDropInContentView.h"
#import "BTDropInLocalizedString.h"
#import "BTTokenizationService.h"

@interface BTDropInContentView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *verticalLayoutConstraints;
/// An array of `NSLayoutConstraint` horizontal constraints on the payment button.
/// These constraints may need to be updated when
@property (nonatomic, strong) NSArray *paymentButtonConstraints;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation BTDropInContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize Subviews

        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
        self.activityView.hidden = YES;
        [self addSubview:self.activityView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

        self.summaryView = [[BTUISummaryView alloc] init];

        UIView *summaryBorderBottom = [[UIView alloc] init];
        summaryBorderBottom.backgroundColor = self.theme.borderColor;
        summaryBorderBottom.translatesAutoresizingMaskIntoConstraints = NO;
        [self.summaryView addSubview:summaryBorderBottom];
        [self.summaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[border]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"border": summaryBorderBottom}]];
        [self.summaryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[border(==borderWidth)]|"
                                                                                 options:0
                                                                                 metrics:@{@"borderWidth": @(self.theme.borderWidth)}
                                                                                   views:@{@"border": summaryBorderBottom}]];

        self.cardFormSectionHeader = [[UILabel alloc] init];

        self.cardForm = [[BTUICardFormView alloc] init];
        [self.cardForm setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

        self.selectedPaymentMethodView = [[BTUIPaymentMethodView alloc] init];

        self.changeSelectedPaymentMethodButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.changeSelectedPaymentMethodButton setTitle:BTDropInLocalizedString(DROP_IN_CHANGE_PAYMENT_METHOD_BUTTON_TEXT)
                                                forState:UIControlStateNormal];

        self.ctaControl = [[BTUICTAControl alloc] init];

        // Add Constraints & Subviews

        // Full-Width Views
        for (UIView *view in @[self.selectedPaymentMethodView, self.summaryView, self.ctaControl, self.cardForm]) {
            [self addSubview:view withHorizontalMargins:NO];
        }

        // Not quite full-width views
        for (UIView *view in @[self.cardFormSectionHeader, self.changeSelectedPaymentMethodButton]) {
            [self addSubview:view withHorizontalMargins:YES];
        }

        self.paymentButton = [[BTPaymentButton alloc] init];
        // The payment button horizontal constraints may be updated to add a margin to the button *after*
        // fetching the configuration, so keep a reference to them to update them in updateConstraints
        self.paymentButtonConstraints = [self addSubview:self.paymentButton withHorizontalMargins:NO];

        self.state = BTDropInContentViewStateForm;

        // Keyboard dismissal when tapping outside text field
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];

    }
    return self;
}

/// Adds a subview, and returns an array of constraints applied to the subview
- (NSArray *)addSubview:(UIView *)view withHorizontalMargins:(BOOL)useHorizontalMargins {
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *metrics = useHorizontalMargins ? @{@"horizontalMargin": @(self.theme.horizontalMargin)} : @{@"horizontalMargin": @(0)};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(horizontalMargin)-[view]-(horizontalMargin)-|"
                                                                   options:0
                                                                   metrics:metrics
                                                                     views:@{@"view": view}];
    [self addConstraints:constraints];
    return constraints;
}

- (void)updateConstraints {

    if (self.verticalLayoutConstraints != nil) {
        [self removeConstraints:self.verticalLayoutConstraints];
    }

    CGFloat paymentButtonMargin;
    if ([self.paymentButton.enabledPaymentOptions isEqualToOrderedSet:[NSOrderedSet orderedSetWithArray:@[@"PayPal"]]]) {
        paymentButtonMargin = self.theme.horizontalMargin;
    } else {
        paymentButtonMargin = 0;
    }
    for (NSLayoutConstraint *constraint in self.paymentButtonConstraints) {
        constraint.constant = paymentButtonMargin;
    }
    [self.paymentButton setNeedsLayout];
    [self.paymentButton layoutIfNeeded];

    NSDictionary *viewBindings = @{
                                   @"activityView": self.activityView,
                                   @"summaryView": self.summaryView,
                                   @"paymentButton": self.paymentButton,
                                   @"cardFormSectionHeader": self.cardFormSectionHeader,
                                   @"cardForm": self.cardForm,
                                   @"ctaControl": self.ctaControl,
                                   @"selectedPaymentMethodView": self.selectedPaymentMethodView,
                                   @"changeSelectedPaymentMethodButton": self.changeSelectedPaymentMethodButton
                                   };

    NSMutableArray *newConstraints = [NSMutableArray array];
    for (NSString *visualFormat in [self evaluateVisualFormat]) {
        [newConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:viewBindings]];
    }

    if(self.heightConstraint != nil) {
        [self.superview removeConstraint:self.heightConstraint];
    }

    if (self.state != BTDropInContentViewStateForm) {

        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                toItem:self.superview
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.0f
                                                              constant:0];
        [self.superview addConstraint:self.heightConstraint];
    }
    [self.superview setNeedsLayout];

    [self addConstraints:newConstraints];
    self.verticalLayoutConstraints = newConstraints;

    [super updateConstraints];

}
- (void)setHideSummary:(BOOL)hideSummary {
    _hideSummary = hideSummary;
    [self updateContentView];
}

- (void)setHideCTA:(BOOL)hideCTA {
    _hideCTA = hideCTA;
    [self updateContentView];
}

- (void)setState:(BTDropInContentViewStateType)state {
    _state = state;
    [self updateContentView];
}

- (void)setState:(BTDropInContentViewStateType)newState animate:(BOOL)animate completion:(void(^)())completionBlock {
    if (!animate) {
        [self setState:newState];
    } else {
        BTDropInContentViewStateType oldState = self.state;
        CGFloat duration = 0.2f;
        if (oldState == BTDropInContentViewStateActivity) {
            if (newState == BTDropInContentViewStateForm) {
                [UIView animateWithDuration:duration animations:^{
                    self.activityView.alpha = 0.0f;
                } completion:^(__unused BOOL finished) {
                    [self setState:newState];
                    self.paymentButton.alpha = 0.0f;
                    self.cardForm.alpha = 0.0f;
                    self.cardFormSectionHeader.alpha = 0.0f;
                    self.ctaControl.alpha = 0.0f;
                    [self setNeedsUpdateConstraints];
                    [self layoutIfNeeded];
                    [UIView animateWithDuration:duration animations:^{
                        self.paymentButton.alpha = 1.0f;
                        self.cardForm.alpha = 1.0f;
                        self.cardFormSectionHeader.alpha = 1.0f;
                        self.ctaControl.alpha = 1.0f;
                        if (completionBlock) {
                            completionBlock();
                        }
                    }];
                }];
                return;
            }

            if (newState == BTDropInContentViewStatePaymentMethodsOnFile) {
                self.activityView.alpha = 1.0f;
                [UIView animateWithDuration:duration animations:^{
                    self.activityView.alpha = 0.0f;
                } completion:^(__unused BOOL finished) {
                    [self setState:newState];
                    self.selectedPaymentMethodView.alpha = 0.0f;
                    self.changeSelectedPaymentMethodButton.alpha = 0.0f;
                    self.ctaControl.alpha = 0.0f;
                    [self setNeedsUpdateConstraints];
                    [self layoutIfNeeded];
                    [UIView animateWithDuration:duration animations:^{
                        self.selectedPaymentMethodView.alpha = 1.0f;
                        self.changeSelectedPaymentMethodButton.alpha = 1.0f;
                        self.ctaControl.alpha = 1.0f;
                        if (completionBlock) {
                            completionBlock();
                        }
                    }];
                }];
                return;
            }
        }
        [self setState:newState];
    }
}

- (void)setState:(BTDropInContentViewStateType)newState animate:(BOOL)animate {
    [self setState:newState animate:animate completion:nil];
}

- (void)setHidePaymentButton:(BOOL)hidePaymentButton {
    _hidePaymentButton = hidePaymentButton;
    self.paymentButton.hidden = hidePaymentButton;
    [self updateContentView];
}

- (void)updateContentView {

    // Reset all to hidden, just for clarity
    self.activityView.hidden = YES;
    self.summaryView.hidden = self.hideSummary;
    self.paymentButton.hidden = YES;
    self.cardFormSectionHeader.hidden = YES;
    self.cardForm.hidden = YES;
    self.selectedPaymentMethodView.hidden = YES;
    self.changeSelectedPaymentMethodButton.hidden = YES;
    self.ctaControl.hidden = YES;

    switch (self.state) {
        case BTDropInContentViewStateForm:
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            self.ctaControl.hidden = self.hideCTA;
            self.paymentButton.hidden = self.hidePaymentButton;
            if ([[BTTokenizationService sharedService] isTypeAvailable:@"Card"]) {
                self.cardFormSectionHeader.hidden = NO;
                self.cardForm.hidden = NO;
            }
            break;
        case BTDropInContentViewStatePaymentMethodsOnFile:
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            self.ctaControl.hidden = self.hideCTA;
            self.selectedPaymentMethodView.hidden = NO;
            self.changeSelectedPaymentMethodButton.hidden = NO;
            break;
        case BTDropInContentViewStateActivity:
            self.activityView.hidden = NO;
            self.activityView.alpha = 1.0f;
            [self.activityView startAnimating];
            break;
        default:
            break;
    }
    [self setNeedsUpdateConstraints];
}


#pragma mark Tap Gesture Delegate

- (BOOL)gestureRecognizer:(__unused UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Disallow recognition of tap gestures on UIControls (like, say, buttons)
    if ([touch.view isKindOfClass:[UIControl class]] || [touch.view isDescendantOfView:self.paymentButton]) {
        return NO;
    }
    return YES;
}


- (void)tapped {
    [self.cardForm endEditing:YES];
}

- (NSArray*) evaluateVisualFormat{
    NSString *summaryViewVisualFormat = self.summaryView.hidden ? @"" : @"[summaryView(>=60)]";
    NSString *ctaControlVisualFormat = self.ctaControl.hidden ? @"" : @"[ctaControl(==50)]";

    if (self.state == BTDropInContentViewStateActivity) {
        return @[[NSString stringWithFormat:@"V:|%@-(40)-[activityView]-(>=40)-%@|", summaryViewVisualFormat, ctaControlVisualFormat]];

    } else if (self.state != BTDropInContentViewStatePaymentMethodsOnFile) {
        if (!self.ctaControl.hidden) {
            ctaControlVisualFormat = [NSString stringWithFormat:@"-(15)-%@-(>=0)-", ctaControlVisualFormat];
        }
        if (self.hidePaymentButton){
            return @[[NSString stringWithFormat:@"V:|%@-(35)-[cardFormSectionHeader]-(7)-[cardForm]%@|", summaryViewVisualFormat, ctaControlVisualFormat]];
        } else {
            summaryViewVisualFormat = [NSString stringWithFormat:@"%@-(35)-", summaryViewVisualFormat];
            return @[[NSString stringWithFormat:@"V:|%@[paymentButton(==44)]-(18)-[cardFormSectionHeader]-(7)-[cardForm]%@|", summaryViewVisualFormat, ctaControlVisualFormat]];
        }

    } else {
        NSString *primaryLayout = [NSString stringWithFormat:@"V:|%@-(15)-[selectedPaymentMethodView(==45)]-(15)-[changeSelectedPaymentMethodButton]-(>=15)-%@|", summaryViewVisualFormat, ctaControlVisualFormat];
        NSMutableArray *visualLayouts = [NSMutableArray arrayWithObject:primaryLayout];
        if (!self.ctaControl.hidden) {
            [visualLayouts addObject:@"V:[ctaControl]|"];
        }
        return visualLayouts;
    }
}

@end
