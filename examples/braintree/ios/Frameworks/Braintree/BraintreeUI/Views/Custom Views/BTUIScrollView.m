#import "BTUIScrollView.h"

@implementation BTUIScrollView

- (void)defaultScrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    [super scrollRectToVisible:rect animated:animated];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    if (self.scrollRectToVisibleDelegate != nil) {
        [self.scrollRectToVisibleDelegate scrollView:self requestsScrollRectToVisible:rect animated:animated];
    }
}

- (BOOL)touchesShouldCancelInContentView:(__unused UIView *)view {
    return YES;
}

@end
