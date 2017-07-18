#import "BTCardRequest.h"

@implementation BTCardRequest

- (instancetype)initWithCard:(BTCard *)card {
    if (!card) {
        return nil;
    }
    if (self = [super init]) {
        _card = card;
    }
    return self;
}

@end
