#import "BTUIThemedView.h"

@implementation BTUIThemedView

- (id)init {
    self = [super init];
    if (self) {
        _theme = [BTUI braintreeTheme];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _theme = [BTUI braintreeTheme];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _theme = [BTUI braintreeTheme];
    }
    return self;
}

@end
