#import "BTUICardHint.h"

#import "BTUI.h"

#import "BTUICVVFrontVectorArtView.h"
#import "BTUICVVBackVectorArtView.h"

@interface BTUICardHint ()
@property (nonatomic, strong) UIView *hintVectorArtView;
@property (nonatomic, strong) NSArray *hintVectorArtViewConstraints;
@end

@implementation BTUICardHint

- (id)initWithFrame:(CGRect)frame {
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
    self.layer.borderColor = self.theme.cardHintBorderColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 2.0f;

    self.hintVectorArtView = [[BTUI braintreeTheme] vectorArtViewForPaymentOptionType:BTUIPaymentOptionTypeUnknown];
    [self.hintVectorArtView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.hintVectorArtView];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:87.0f/55.0f
                                                      constant:0.0f]];

    [self setNeedsLayout];
}

- (void)updateConstraints {
    if (self.hintVectorArtViewConstraints) {
        [self removeConstraints:self.hintVectorArtViewConstraints];
    }

    self.hintVectorArtViewConstraints = @[[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.hintVectorArtView
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1.0f
                                                                        constant:1.0f],

                                          [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.hintVectorArtView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1.0f
                                                                        constant:0.0f],

                                          [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.hintVectorArtView
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier:1.0f
                                                                        constant:0.0f] ];

    [self addConstraints:self.hintVectorArtViewConstraints];

    [super updateConstraints];
}

- (void)updateViews {
    UIView *cardVectorArtView;
    switch (self.displayMode) {
        case BTCardHintDisplayModeCardType:
            cardVectorArtView = [[BTUI braintreeTheme] vectorArtViewForPaymentOptionType:self.cardType];
            break;
        case BTCardHintDisplayModeCVVHint:
            if (self.cardType == BTUIPaymentOptionTypeAMEX) {
                cardVectorArtView = [BTUICVVFrontVectorArtView new];
            } else {
                cardVectorArtView = [BTUICVVBackVectorArtView new];
            }
            break;
    }

    [self.hintVectorArtView removeFromSuperview];
    self.hintVectorArtView = cardVectorArtView;
    [self.hintVectorArtView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.hintVectorArtView];
    [self setHighlighted:self.highlighted];

    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)setCardType:(BTUIPaymentOptionType)cardType {
    _cardType = cardType;
    [self updateViews];
}

- (void)setCardType:(BTUIPaymentOptionType)cardType animated:(BOOL)animated {
    if (cardType == self.cardType) {
        return;
    }
    if (animated) {
        [UIView transitionWithView:self
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self setCardType:cardType];
                        } completion:nil];
    } else {
        [self setCardType:cardType];
    }
}

- (void)setDisplayMode:(BTCardHintDisplayMode)displayMode {
    _displayMode = displayMode;
    [self updateViews];
}

- (void)setDisplayMode:(BTCardHintDisplayMode)displayMode animated:(BOOL)animated {
    if (animated) {
        [UIView transitionWithView:self
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self setDisplayMode:displayMode];
                        } completion:nil];
    } else {
        [self updateViews];
    }
}

#pragma mark - Highlighting

- (void)setHighlighted:(BOOL)highlighted {
    [self setHighlighted:highlighted animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    _highlighted = highlighted;
    UIColor *c = highlighted ? self.tintColor : nil;
    [self setHighlightColor:c animated:animated];
}

- (void)setHighlightColor:(UIColor *)color animated:(BOOL)animated {
    if (![self.hintVectorArtView respondsToSelector:@selector(setHighlightColor:)]) {
        return;
    }
    if (animated) {
        [UIView transitionWithView:self.hintVectorArtView
                          duration:self.theme.quickTransitionDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.hintVectorArtView performSelector:@selector(setHighlightColor:) withObject:color];
                            [self.hintVectorArtView setNeedsDisplay];
                        }
                        completion:nil
         ];
    } else {
        [self.hintVectorArtView performSelector:@selector(setHighlightColor:) withObject:color];
        [self.hintVectorArtView setNeedsDisplay];
    }
}

- (void)tintColorDidChange {
    [self setHighlighted:self.highlighted animated:YES];
}

@end
