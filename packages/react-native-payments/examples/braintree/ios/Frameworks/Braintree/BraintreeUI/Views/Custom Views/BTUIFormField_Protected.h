#import <UIKit/UIKit.h>
#import "BTUIFormField.h"
#import "BTUITextField.h"

/*!
 @brief Private class extension for implementors of BTUIFormField subclasses.
*/
@interface BTUIFormField () 

@property (nonatomic, strong, readonly) BTUITextField *textField;

@property (nonatomic, strong) UIView *accessoryView;

/*!
 @brief Override in your subclass to implement behavior on content change
*/
- (void)fieldContentDidChange;

/*!
 @brief Sets placeholder text with the appropriate theme style
*/
- (void)setThemedPlaceholder:(NSString *)placeholder;
- (void)setThemedAttributedPlaceholder:(NSAttributedString *)placeholder;

@end

