#import <UIKit/UIKit.h>

@class BTUI;

NS_ASSUME_NONNULL_BEGIN

/*!
 @class BTUICTAControl
 @discussion The Call To Action control is a button that is intended to be used as the submit button
 on the bottom of a payment form. As a UIControl subclass, typical target-action event
 listeners are available.
*/
@interface BTUICTAControl : UIControl

/*!
 @brief The amount, including a currency symbol, to be displayed.
*/
@property (nonatomic, copy, nullable) NSString *displayAmount;

/*!
 @brief The call to action verb, such as "Subscribe" or "Buy".
*/
@property (nonatomic, copy) NSString *callToAction;

- (void)showLoadingState:(BOOL)loadingState;

@property (nonatomic, strong) BTUI *theme;

@end

NS_ASSUME_NONNULL_END
