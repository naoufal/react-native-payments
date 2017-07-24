#import "BTUIFloatLabel.h"

@interface BTUIFloatLabel ()
@property (nonatomic, readwrite, strong) UILabel *label;
@property (nonatomic, strong) NSArray *verticalConstraints;
@end

@implementation BTUIFloatLabel

- (id)init {
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.font = self.theme.textFieldFloatLabelFont;
    self.label.textColor = self.theme.textFieldFloatLabelTextColor;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.opaque = NO;
    self.label.numberOfLines = 1;
    self.label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.label];

    self.verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:[self viewBindings]];
}

- (void)updateConstraints {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:[self viewBindings]]];
    [self addConstraints:self.verticalConstraints];

    [super updateConstraints];
}

- (void)showWithAnimation:(BOOL)shouldAnimate {
    void (^animations)(void) = ^{
        self.label.alpha = 1.0f;
        [self layoutIfNeeded];
    };

    [self removeConstraints:self.verticalConstraints];
    self.verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:[self viewBindings]];
    [self setNeedsUpdateConstraints];

    if (shouldAnimate) {
        [UIView animateWithDuration:self.theme.quickTransitionDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:animations
                         completion:nil];
    } else {
        animations();
    }
}

- (void)hideWithAnimation:(BOOL)shouldAnimate {
    void (^animations)(void) = ^{
        self.label.alpha = 0.0f;
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
    };

    [self removeConstraints:self.verticalConstraints];
    self.verticalConstraints = @[ [NSLayoutConstraint constraintWithItem:self.label
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0f
                                                             constant:0.0f] ];
    [self setNeedsUpdateConstraints];
    if (shouldAnimate) {
        [UIView animateWithDuration:self.theme.quickTransitionDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:animations
                         completion:nil];
    } else {
        animations();
    }
}

#pragma mark - Theme

- (void)setTheme:(BTUI *)theme {
  [super setTheme:theme];
  
  self.label.font = self.theme.textFieldFloatLabelFont;
  self.label.textColor = self.theme.textFieldFloatLabelTextColor;
}

- (NSDictionary *)viewBindings {
    return @{ @"label": self.label };
}

@end
