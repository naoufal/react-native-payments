#import "BTUIPayPalCompactButton.h"
#import "BTUIPayPalWordmarkCompactVectorArtView.h"

@interface BTUIPayPalCompactButton ()
@end

@implementation BTUIPayPalCompactButton

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
    self.backgroundColor = [UIColor whiteColor];

    self.payPalWordmark = [[BTUIPayPalWordmarkCompactVectorArtView alloc] initWithPadding];
    self.payPalWordmark.userInteractionEnabled = NO;
    self.payPalWordmark.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:self.payPalWordmark];
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
