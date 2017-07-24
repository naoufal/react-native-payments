#import <UIKit/UIKit.h>
#import "BTUIThemedView.h"

/*!
 @brief Informational view that displays a summary of the shopping cart or other relevant data for checkout experience that user is agreing too.
*/
 @interface BTUISummaryView : BTUIThemedView

/*!
 @brief The text to display as the primary description of the purchase.
*/
@property (nonatomic, copy) NSString *slug;

/*!
 @brief The text to display as the secondary summary of the purchase.
*/
@property (nonatomic, copy) NSString *summary;

/*!
 @brief The textual representation of the dollar amount for the purchase including the currency symbol
*/
@property (nonatomic, copy) NSString *amount;

@end
