#import "BTUIPaymentOptionType.h"
#import "BTUIThemedView.h"
#import <UIKit/UIKit.h>

/*!
 @brief A view that indicates the currently selected payment method, be it a credit card or a PayPal account.
*/
@interface BTUIPaymentMethodView : BTUIThemedView

/*!
 @brief The type of payment method to display.
 */
@property (nonatomic, assign) BTUIPaymentOptionType type;

/*!
 @brief An optional string description of the payment method.
 @discussion For example, you could say "ending in 02" for a credit card.
 */
@property (nonatomic, copy) NSString *detailDescription;

/*!
 @brief When true, all content is hidden and a loading spinner is displayed.
 */
@property (nonatomic, assign, getter = isProcessing) BOOL processing;

@end
