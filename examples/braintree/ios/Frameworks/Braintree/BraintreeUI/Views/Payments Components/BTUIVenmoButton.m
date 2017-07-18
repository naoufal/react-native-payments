#import "BTUIVenmoWordmarkVectorArtView.h"
#import "BTUI.h"
#import "BTUIVenmoButton.h"
#import "UIColor+BTUI.h"

@interface BTUIVenmoButton ()
@property (nonatomic, strong) BTUIVenmoWordmarkVectorArtView *venmoWordmark;
@end

@implementation BTUIVenmoButton

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
    self.backgroundColor = [UIColor whiteColor];

    self.venmoWordmark = [[BTUIVenmoWordmarkVectorArtView alloc] init];
    self.venmoWordmark.userInteractionEnabled = NO;
    self.venmoWordmark.translatesAutoresizingMaskIntoConstraints = NO;
    self.venmoWordmark.color = [self.theme venmoPrimaryBlue];

    [self addSubview:self.venmoWordmark];
}

- (void)updateConstraints {
    NSDictionary *metrics = @{ @"minHeight": @([self.theme paymentButtonMinHeight]),
                               @"maxHeight": @([self.theme paymentButtonMaxHeight]),
                               @"minWidth": @(200),
                               @"required": @(UILayoutPriorityRequired),
                               @"high": @(UILayoutPriorityDefaultHigh),
                               @"breathingRoom": @(10) };
    NSDictionary *views = @{ @"self": self ,
                             @"venmoWordmark": self.venmoWordmark };

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[venmoWordmark]|"
                                            options:0
                                            metrics:metrics
                                              views:views]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                    attribute:NSLayoutAttributeCenterX
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:self.venmoWordmark
                                                    attribute:NSLayoutAttributeCenterX
                                                   multiplier:1.0f
                                                      constant:0.0f]];

    [super updateConstraints];
}

- (void)setHighlighted:(BOOL)highlighted {
    [UIView animateWithDuration:0.08f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            if (highlighted) {
                                self.backgroundColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
                            } else {
                                self.backgroundColor = [UIColor whiteColor];
                            }
                        }
                     completion:nil];
}

@end
