#import "BTUIThemedView.h"

@interface BTUIFloatLabel : BTUIThemedView

@property (nonatomic, readonly, strong) UILabel *label;

- (void)showWithAnimation:(BOOL)shouldAnimate;
- (void)hideWithAnimation:(BOOL)shouldAnimate;

@end
