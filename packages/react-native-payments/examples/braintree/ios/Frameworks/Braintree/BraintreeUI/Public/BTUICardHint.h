#import <UIKit/UIKit.h>
#import "BTUIPaymentOptionType.h"
#import "BTUIThemedView.h"

/*!
 @brief `BTCardHint` has two display modes: one emphasizes the card type, and the second emphasizes the CVV location.
*/
typedef NS_ENUM(NSInteger, BTCardHintDisplayMode) {
    /// Emphasize the card's type.
    BTCardHintDisplayModeCardType,
    /// Emphasize the CVV's location.
    BTCardHintDisplayModeCVVHint,
};

/*!
 @class BTUICardHint
 @discussion A View that displays a card icon in order to provide users with a hint as to what card type
 has been detected or where the CVV can be found on that card.
*/
@interface BTUICardHint : BTUIThemedView

/*!
 @brief The card type to display.
*/
@property (nonatomic, assign) BTUIPaymentOptionType cardType;

/*!
 @brief Whether to emphasize the card type or the CVV.
*/
@property (nonatomic, assign) BTCardHintDisplayMode displayMode;

/*!
 @brief Whether it is highlighted with the tint color
*/
@property (nonatomic, assign) BOOL highlighted;

/*!
 @brief Set highlight with animation
*/
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

/*!
 @brief Update the current cardType with an optional visual animation
 @see cardType
*/
- (void)setCardType:(BTUIPaymentOptionType)cardType animated:(BOOL)animated;

/*!
 @brief Update the current displayMode with an optional visual animation
 @see displayMode
*/
- (void)setDisplayMode:(BTCardHintDisplayMode)displayMode animated:(BOOL)animated;

@end
