#import <UIKit/UIKit.h>
#import "BTUIVectorArtView.h"

@class BTUI;

@interface BTUIPayPalWordmarkVectorArtView : BTUIVectorArtView

@property (nonatomic, strong) BTUI *theme;

/*!
 @brief Initializes a PayPal Wordmark with padding

 @discussion This view includes built-in padding to ensure consistent typographical baseline alignment with Venmo and Coinbase wordmarks.

 @return A PayPal Wordmark with padding
*/
- (instancetype)initWithPadding;

/*!
 @brief Initializes a PayPal Wordmark

 @discusion This view does not include built-in padding.

 @return A PayPal Wordmark
*/
- (instancetype)init;

@end
