#import "BTUICardVectorArtView.h"

@implementation BTUICardVectorArtView

- (id)init {
    self = [super init];
    if (self) {
        self.artDimensions = CGSizeMake(87.0f, 55.0f);
        self.opaque = NO;
    }
    return self;
}

- (void)updateConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                    attribute:NSLayoutAttributeHeight
                                                    multiplier:87.0f/55.0f
                                                      constant:0]];
    [super updateConstraints];
}

@end
