#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @brief Protocol for receiving payment lifecycle messages from a payment driver that requires presentation of a view controller to authorize a payment.
*/
@protocol BTViewControllerPresentingDelegate <NSObject>

/*!
 @brief The payment driver requires presentation of a view controller in order to proceed.

 @discussion Your implementation should present the viewController modally, e.g. via
 `presentViewController:animated:completion:`

 @param driver         The payment driver
 @param viewController The view controller to present
*/
- (void)paymentDriver:(id)driver requestsPresentationOfViewController:(UIViewController *)viewController;

/*!
 @brief The payment driver requires dismissal of a view controller.

 @discussion Your implementation should dismiss the viewController, e.g. via
 `dismissViewControllerAnimated:completion:`

 @param driver         The payment driver
 @param viewController The view controller to be dismissed
*/
- (void)paymentDriver:(id)driver requestsDismissalOfViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
