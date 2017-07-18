#import "BTUICardPhoneNumberField.h"
#import "BTUIFormField_Protected.h"
#import "BTUILocalizedString.h"
@import Contacts;

@implementation BTUICardPhoneNumberField

#define MAX_PHONE_NUMBER_DIGITS 11

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setThemedPlaceholder:BTUILocalizedString(PHONE_NUMBER_PLACEHOLDER)];
        self.textField.accessibilityLabel = BTUILocalizedString(PHONE_NUMBER_PLACEHOLDER);
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}

- (BOOL)valid {
    return self.textField.text.length == MAX_PHONE_NUMBER_DIGITS;
}

- (NSString *)phoneNumber {
    return self.textField.text;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    self.textField.text = phoneNumber;
}

- (void)fieldContentDidChange {
    if ([self.delegate respondsToSelector:@selector(formFieldDidChange:)]) {
        [self.delegate formFieldDidChange:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    return newLength <= MAX_PHONE_NUMBER_DIGITS;
}

@end
