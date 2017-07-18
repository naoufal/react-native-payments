#import <UIKit/UIKit.h>

#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

#import "BTUI.h"

@protocol BTDropInSelectPaymentMethodViewControllerDelegate;

/*!
 @class BTDropInSelectPaymentMethodViewController
 @brief Drop In's payment method selection flow.
*/
@interface BTDropInSelectPaymentMethodViewController : UITableViewController

@property (nonatomic, strong) BTAPIClient *client;
@property (nonatomic, weak) id<BTDropInSelectPaymentMethodViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *paymentMethodNonces;

@property (nonatomic, assign) NSInteger selectedPaymentMethodIndex;

@property (nonatomic, strong) BTUI *theme;

@end

@protocol BTDropInSelectPaymentMethodViewControllerDelegate

- (void)selectPaymentMethodViewController:(BTDropInSelectPaymentMethodViewController *)viewController
            didSelectPaymentMethodAtIndex:(NSUInteger)index;

- (void)selectPaymentMethodViewControllerDidRequestNew:(BTDropInSelectPaymentMethodViewController *)viewController;

@end
