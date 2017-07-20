#import "BTUI.h"
#import "BTUIPayPalButton.h"
#import "BTUIPayPalWordmarkVectorArtView.h"

@implementation BTUIPayPalButton

#define PAYPAL_BUTTON_COLOR [UIColor colorWithRed:0 green:156/255.0 blue:222/255.0 alpha:1]
#define PAYPAL_BUTTON_HIGHLIGHTED [UIColor colorWithRed:0 green:138/255.0 blue:197/255.0 alpha:1]

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.theme = [BTUI braintreeTheme];
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    self.opaque = NO;
    self.backgroundColor = PAYPAL_BUTTON_COLOR;

    self.payPalWordmark = [[BTUIPayPalWordmarkVectorArtView alloc] initWithPadding];
    self.payPalWordmark.userInteractionEnabled = NO;
    self.payPalWordmark.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:self.payPalWordmark];
}

- (void)updateConstraints {
    NSDictionary *metrics = @{ @"minHeight": @([self.theme paymentButtonMinHeight]),
                               @"maxHeight": @([self.theme paymentButtonMaxHeight]),
                               @"minWidth": @(200),
                               @"required": @(UILayoutPriorityRequired),
                               @"high": @(UILayoutPriorityDefaultHigh),
                               @"breathingRoom": @(10) };
    NSDictionary *views = @{ @"self": self ,
                             @"payPalWordmark": self.payPalWordmark };

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[payPalWordmark]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                    attribute:NSLayoutAttributeCenterX
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:self.payPalWordmark
                                                    attribute:NSLayoutAttributeCenterX
                                                   multiplier:1.0f
                                                      constant:0.0f]];

    [super updateConstraints];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 44);
}

- (void)setHighlighted:(BOOL)highlighted {
    [UIView animateWithDuration:0.08f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            if (highlighted) {
                                self.backgroundColor = PAYPAL_BUTTON_HIGHLIGHTED;
                            } else {
                                self.backgroundColor = PAYPAL_BUTTON_COLOR;
                            }
                        }
                     completion:nil];
}

@end
