#import "BTUIPaymentButtonCollectionViewCell.h"

@interface BTUIPaymentButtonCollectionViewCell ()
@property (nonatomic, strong) NSMutableArray *paymentButtonConstraints;
@end

@implementation BTUIPaymentButtonCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.userInteractionEnabled = NO;
        self.paymentButtonConstraints = [NSMutableArray array];
    }
    return self;
}

- (void)setPaymentButton:(UIControl *)paymentButton {
    if (self.paymentButtonConstraints) {
        [self removeConstraints:self.paymentButtonConstraints];
        [self.paymentButtonConstraints removeAllObjects];
    }
    [self.paymentButton removeFromSuperview];

    _paymentButton = paymentButton;
    [self.contentView addSubview:paymentButton];

    paymentButton.userInteractionEnabled = NO;

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (self.paymentButton) {
        NSDictionary *views = @{ @"paymentButton": self.paymentButton };
        [self.paymentButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[paymentButton]|"
                                                                                                   options:0
                                                                                                   metrics:nil
                                                                                                     views:views]];
        [self.paymentButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[paymentButton]|"
                                                                                                   options:0
                                                                                                   metrics:nil
                                                                                                     views:views]];
        [self addConstraints:self.paymentButtonConstraints];
    }
    [super updateConstraints];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    [self.paymentButton setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    [self.paymentButton setSelected:selected];
}

@end

