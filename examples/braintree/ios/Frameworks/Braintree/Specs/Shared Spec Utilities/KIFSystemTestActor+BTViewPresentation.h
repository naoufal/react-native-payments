#import "KIFSystemTestActor.h"

/// Provides convenience methods for presenting view controllers and views for KIF tests
@interface KIFSystemTestActor (BTViewPresentation)

/// Present a view controller in the app
///
/// @param viewController The view controller to show. Cannot be `nil`.
- (void)presentViewController:(UIViewController *)viewController;

/// Present a view by adding it as a subview of a new view controller, then presenting the view controller
/// in the app.
///
/// @param view The view to display.
- (void)presentView:(UIView *)view;

@end
