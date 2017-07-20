#import "BTUICardPostalCodeField.h"
#import "BTUIFormField_Protected.h"
#import "BTUILocalizedString.h"
#import "BTUIUtil.h"

@implementation BTUICardPostalCodeField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setThemedPlaceholder:BTUILocalizedString(POSTAL_CODE_PLACEHOLDER)];
        self.textField.accessibilityLabel = BTUILocalizedString(POSTAL_CODE_PLACEHOLDER);
        self.nonDigitsSupported = NO;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.textField.returnKeyType = UIReturnKeyDone;
    }
    return self;
}

- (void)setPostalCode:(NSString *)postalCode {
    if (!self.nonDigitsSupported) {
        NSString *numericPostalCode = [BTUIUtil stripNonDigits:postalCode];
        if (![numericPostalCode isEqualToString:postalCode]) return;
    }
    _postalCode = postalCode;
    self.text = postalCode;
}

- (void)setNonDigitsSupported:(BOOL)nonDigitsSupported {
    _nonDigitsSupported = nonDigitsSupported;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.textField.keyboardType = _nonDigitsSupported ? UIKeyboardTypeNumbersAndPunctuation : UIKeyboardTypeNumberPad;
}

- (BOOL)entryComplete {
    // Never allow auto-advancing out of postal code field since there is no way to know that the
    // input value constitutes a complete postal code.
    return NO;
}

- (BOOL)valid {
    return self.postalCode.length > 0;
}

- (void)fieldContentDidChange {
    _postalCode = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.displayAsValid = YES;
    [super fieldContentDidChange];
    [self.delegate formFieldDidChange:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.displayAsValid = YES;
    [super textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.displayAsValid = YES;
    [super textFieldDidEndEditing:textField];
}

@end
