#import <UIKit/UIKit.h>

@protocol BTUIScrollViewScrollRectToVisibleDelegate;

/*!
 @class BTUIScrollView
 @brief Subclass of UIScrollView that disables default iOS "autoscrolling" to text fields by overriding the scrollRectToVisible method with a call to a delegate.
*/
@interface BTUIScrollView : UIScrollView

/*!
 @brief Delegate that, if set, receives messages when scrollRectToVisible is called
 @note If nil, scrollRectToVisible is simply a no-op.
*/
@property (nonatomic, weak) id<BTUIScrollViewScrollRectToVisibleDelegate> scrollRectToVisibleDelegate;

/*!
 @brief The "default" scrollRectToVisible implementation
*/
- (void)defaultScrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

@end


@protocol BTUIScrollViewScrollRectToVisibleDelegate <NSObject>

- (void)scrollView:(BTUIScrollView *)scrollView requestsScrollRectToVisible:(__unused CGRect)rect animated:(__unused BOOL)animated;

@end
