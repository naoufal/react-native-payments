#import "BTUICardExpiryField.h"
#import "BTUIFormField_Protected.h"
#import "BTUIUtil.h"
#import "BTUICardExpirationValidator.h"
#import "BTUICardExpiryFormat.h"
#import "BTUILocalizedString.h"

#define BTUICardExpiryFieldYYYYPrefix @"20"
#define BTUICardExpiryFieldComponentSeparator @"/"

#define BTUICardExpiryPlaceholderFourDigitYear BTUILocalizedString(EXPIRY_PLACEHOLDER_FOUR_DIGIT_YEAR)
#define BTUICardExpiryPlaceholderTwoDigitYear BTUILocalizedString(EXPIRY_PLACEHOLDER_TWO_DIGIT_YEAR)

@interface BTUICardExpiryField () <UITextFieldDelegate>
@end

@implementation BTUICardExpiryField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self updatePlaceholder];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.delegate = self;
    }
    return self;
}

- (BOOL)valid {
    if (!self.expirationYear || !self.expirationMonth) {
        return NO;
    }
    return [BTUICardExpirationValidator month:self.expirationMonth.intValue year:self.expirationYear.intValue validForDate:[NSDate date]];
}

- (void)setExpirationDate:(NSString *)expirationDate {
    [self setText:expirationDate];
 }

- (NSString *)expirationDate {
    if (!self.expirationMonth || !self.expirationYear) return nil;

    return [NSString stringWithFormat:@"%@%@", self.expirationMonth, self.expirationYear];
}

#pragma mark - Handlers

- (void)fieldContentDidChange {
    _expirationMonth = nil;
    _expirationYear = nil;

    NSString *formattedValue;
    NSUInteger formattedCursorLocation;

    BTUICardExpiryFormat *format = [[BTUICardExpiryFormat alloc] init];
    format.value = self.textField.text;
    format.cursorLocation = [self.textField offsetFromPosition:self.textField.beginningOfDocument toPosition:self.textField.selectedTextRange.start];
    format.backspace = self.backspace;
    [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

    // Important: Reset the state of self.backspace.
    // Otherwise, the user won't be able to do the following:
    // Enter "11/16", then backspace to
    //       "1", and then type e.g. "2". Instead of showing:
    //       "12/" (as it should), the form would instead remain stuck at
    //       "1".
    self.backspace = NO;
    // This is because UIControlEventEditingChanged is *not* sent after the "/" is removed.
    // We can't trigger UIControlEventEditingChanged here (after removing a "/") because that would cause an infinite loop.

    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:formattedValue attributes:self.theme.textFieldTextAttributes];
    [self kernExpiration:result];
    self.textField.attributedText = result;

    UITextPosition *newPosition = [self.textField positionFromPosition:self.textField.beginningOfDocument offset:formattedCursorLocation];
    UITextRange *newRange = [self.textField textRangeFromPosition:newPosition toPosition:newPosition];
    self.textField.selectedTextRange = newRange;

    NSArray *expirationComponents = [self expirationComponents:self.textField.text];
    if(expirationComponents.count == 2 && (self.textField.text.length == 5 || self.textField.text.length == 7)) {
        _expirationMonth = expirationComponents[0];
        _expirationYear = expirationComponents[1];
    }

    [self updatePlaceholder];

    self.displayAsValid = ((self.textField.text.length != 5 && self.textField.text.length != 7) || self.valid);

    [self.delegate formFieldDidChange:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    self.displayAsValid = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    self.displayAsValid = self.textField.text.length == 0 || self.valid;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)newText {
    NSString *numericNewText = [BTUIUtil stripNonDigits:newText];
    if (![numericNewText isEqualToString:newText]) {
        return NO;
    }
    NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:numericNewText];

    return [self dateIsValid:updatedText];
}

- (BOOL)entryComplete {
    return [super entryComplete] && ![self.expirationYear isEqualToString:BTUICardExpiryFieldYYYYPrefix];
}

#pragma mark Helper

- (void)updatePlaceholder {
    NSString *placeholder = [self dateCouldEndWithFourDigitYear:self.textField.text] ? BTUILocalizedString(EXPIRY_PLACEHOLDER_FOUR_DIGIT_YEAR) : BTUILocalizedString(EXPIRY_PLACEHOLDER_TWO_DIGIT_YEAR);
    [self setThemedPlaceholder:placeholder];
    self.textField.accessibilityLabel = placeholder;
}

- (void)setThemedPlaceholder:(NSString *)placeholder {
    NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder ?: @""
                                                                                              attributes:self.theme.textFieldPlaceholderAttributes];
        [self kernExpiration:attributedPlaceholder];
        [self setThemedAttributedPlaceholder:attributedPlaceholder];
}

- (BOOL)dateCouldEndWithFourDigitYear:(NSString *)expirationDate {
    NSArray *expirationComponents = [self expirationComponents:expirationDate];
    NSString *yearComponent = [expirationComponents count] >= 2 ? expirationComponents[1] : nil;
    return (yearComponent && yearComponent.length >= 2 && [[yearComponent substringToIndex:2] isEqualToString:BTUICardExpiryFieldYYYYPrefix]);
}

- (NSArray *)expirationComponents:(NSString *)expirationDate {
    return [expirationDate componentsSeparatedByString:BTUICardExpiryFieldComponentSeparator];
}

- (void)kernExpiration:(NSMutableAttributedString *)input {
    [input removeAttribute:NSKernAttributeName range:NSMakeRange(0, input.length)];

    [input beginEditing];
    if (input.length > 2) {
        [input addAttribute:NSKernAttributeName value:@(self.theme.formattedEntryKerning/2) range:NSMakeRange(1, 1)];
        if (input.length > 3) {
            [input addAttribute:NSKernAttributeName value:@(self.theme.formattedEntryKerning/2) range:NSMakeRange(2, 1)];
        }
    }
    [input endEditing];
}

// Returns YES if date is either a valid date or can have digits appended to make one. It does not contain any expiration
// date validation.
- (BOOL)dateIsValid:(NSString *)date {
    NSArray *dateComponents = [date componentsSeparatedByString:BTUICardExpiryFieldComponentSeparator];

    NSString *yearComponent;
    if (dateComponents.count >= 2) {
        yearComponent = dateComponents[1];
    } else {
        yearComponent = date.length >= 4 ? [date substringWithRange:NSMakeRange(2, date.length - 2)] : nil;
    }

    BOOL couldEndWithFourDigitYear = yearComponent && yearComponent.length >= 2 && [[yearComponent substringToIndex:2] isEqualToString:BTUICardExpiryFieldYYYYPrefix];
    if (couldEndWithFourDigitYear ? date.length > 7 : date.length > 5) {
        return NO;
    }

    NSString *updatedNumberText = [BTUIUtil stripNonDigits:date];

    NSString *monthStr = [updatedNumberText substringToIndex:MIN((NSUInteger)2, updatedNumberText.length)];
    if (monthStr.length > 0) {
        NSInteger month = [monthStr integerValue];
        if(month < 0 || 12 < month) {
            return NO;
        }
        if(monthStr.length >= 2 && month == 0) {
            return NO;
        }
    }

    return YES;
}


@end
