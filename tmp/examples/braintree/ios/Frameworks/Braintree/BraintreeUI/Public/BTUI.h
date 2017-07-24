#import <UIKit/UIKit.h>

#import "BTUIPaymentOptionType.h"
#import "BTUIVectorArtView.h"

/*!
 @brief BTUI represents a visual theme and can be applied to any `BTUIThemedView`.
*/
@interface BTUI : NSObject

/*!
 @brief Returns a default Braintree theme.

 @return the default Braintree theme.
*/
+ (BTUI *)braintreeTheme;

#pragma mark - Palette

- (UIColor *)idealGray;

#pragma mark - Colors

/*!
 @brief Tint color if none is set. Defaults to nil.
*/
- (UIColor *)defaultTintColor;

- (UIColor *)viewBackgroundColor;
- (UIColor *)callToActionColor;
- (UIColor *)callToActionColorHighlighted;
- (UIColor *)disabledButtonColor;

- (UIColor *)titleColor;
- (UIColor *)detailColor;
- (UIColor *)borderColor;

- (UIColor *)textFieldTextColor;
- (UIColor *)textFieldPlaceholderColor;

- (UIColor *)sectionHeaderTextColor;
- (UIColor *)textFieldFloatLabelTextColor;

- (UIColor *)cardHintBorderColor;

- (UIColor *)errorBackgroundColor;
- (UIColor *)errorForegroundColor;

#pragma mark Adjustments

- (CGFloat) highlightedBrightnessAdjustment;

#pragma mark PayPal Colors

- (UIColor *)payBlue;
- (UIColor *)palBlue;
- (UIColor *)payPalButtonBlue;
- (UIColor *)payPalButtonActiveBlue;

#pragma mark Venmo Color

- (UIColor *)venmoPrimaryBlue;

#pragma mark Coinbase Color

- (UIColor *)coinbasePrimaryBlue;

#pragma mark Typography

- (UIFont *)controlFont;
- (UIFont *)controlTitleFont;
- (UIFont *)controlDetailFont;
- (UIFont *)textFieldFont;
- (UIFont *)textFieldFloatLabelFont;
- (UIFont *)sectionHeaderFont;

#pragma mark Attributes

- (NSDictionary *)textFieldTextAttributes;
- (NSDictionary *)textFieldPlaceholderAttributes;

#pragma mark Visuals

- (CGFloat)borderWidth;
- (CGFloat)cornerRadius;
- (CGFloat)formattedEntryKerning;
- (CGFloat)horizontalMargin;
- (CGFloat)paymentButtonMinHeight;
- (CGFloat)paymentButtonMaxHeight;
- (CGFloat)paymentButtonWordMarkHeight DEPRECATED_ATTRIBUTE;

#pragma mark Transitions

- (CGFloat)quickTransitionDuration;
- (CGFloat)transitionDuration;
- (CGFloat)minimumVisibilityTime;



#pragma mark Icons

- (BTUIVectorArtView *)vectorArtViewForPaymentInfoType:(NSString *)typeString;
- (BTUIVectorArtView *)vectorArtViewForPaymentOptionType:(BTUIPaymentOptionType)type;

#pragma mark Utilities

+ (BTUIPaymentOptionType)paymentOptionTypeForPaymentInfoType:(NSString *)typeString;
+ (UIActivityIndicatorViewStyle)activityIndicatorViewStyleForBarTintColor:(UIColor *)color;

@end
