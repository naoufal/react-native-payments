#import <UIKit/UIKit.h>
#import "BTUIThemedView.h"

@protocol BTUIFormFieldDelegate;

/*!
 @class BTUIFormField
 @brief A form field is a UI component for entering a text value

 @discussion This is the parent class of all card form fields,
 and handles display but not formatting, validation, or
 relaying of events

 @see BTUIFormField()
*/
@interface BTUIFormField : BTUIThemedView <UITextFieldDelegate, UIKeyInput>

- (void)updateAppearance;

@property (nonatomic, weak) id<BTUIFormFieldDelegate> delegate;
@property (nonatomic, assign) BOOL vibrateOnInvalidInput;
@property (nonatomic, assign, readonly) BOOL valid;
@property (nonatomic, assign, readonly) BOOL entryComplete;
@property (nonatomic, assign) BOOL displayAsValid;
@property (nonatomic, assign) BOOL bottomBorder;
@property (nonatomic, assign, readwrite) BOOL backspace;

/*!
 @brief The text displayed by the field
*/
@property (nonatomic, copy) NSString *text;

@end


@protocol BTUIFormFieldDelegate <NSObject>

- (void)formFieldDidChange:(BTUIFormField *)formField;
- (void)formFieldDidDeleteWhileEmpty:(BTUIFormField *)formField;

@optional
- (BOOL)formFieldShouldReturn:(BTUIFormField *)formField;
- (void)formFieldDidBeginEditing:(BTUIFormField *)formField;
- (void)formFieldDidEndEditing:(BTUIFormField *)formField;

@end
