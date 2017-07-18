#import "BTUICardCvvField.h"
#import "BTUIFormField_Protected.h"
#import "BTUICardHint.h"
#import "BTUIUtil.h"
#import "BTUIViewUtil.h"
#import "BTUILocalizedString.h"

#define kMinimumCvvLength 3
#define kMaximumCvvLength 4

@interface BTUICardCvvField ()<UITextFieldDelegate>
@property (nonatomic, readonly) NSUInteger validLength;
@property (nonatomic, strong) BTUICardHint *hint;
@end

@implementation BTUICardCvvField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setThemedPlaceholder:BTUILocalizedString(CVV_FIELD_PLACEHOLDER)];
        self.textField.accessibilityLabel = BTUILocalizedString(CVV_FIELD_PLACEHOLDER);
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.delegate = self;

        self.hint = [BTUICardHint new];
        self.hint.displayMode = BTCardHintDisplayModeCVVHint;
        self.accessoryView = self.hint;
        self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.accessoryView];
    }
    return self;
}

- (void)setCardType:(BTUICardType *)cardType {
    _cardType = cardType;
    self.displayAsValid = [self.textField isFirstResponder] || self.textField.text.length == 0 || self.valid;
    BTUIPaymentOptionType type = [BTUIViewUtil paymentMethodTypeForCardType:cardType];
    [self.hint setCardType:type animated:YES];

    if (type == BTUIPaymentOptionTypeUnionPay) {
        [self setThemedPlaceholder:@"CVVM"];
    } else {
        [self setThemedPlaceholder:BTUILocalizedString(CVV_FIELD_PLACEHOLDER)];
    }
    
    [self updateAppearance];
}

- (BOOL)valid {
    BOOL noCardTypeOKLength = (self.cardType == nil && self.cvv.length <= kMaximumCvvLength && self.cvv.length >= kMinimumCvvLength);
    BOOL validLengthForCardType = (self.cardType != nil && self.cvv.length == self.cardType.validCvvLength);
    return noCardTypeOKLength || validLengthForCardType;
}


- (BOOL)entryComplete {
    NSUInteger index = [self.textField offsetFromPosition:self.textField.beginningOfDocument toPosition:self.textField.selectedTextRange.start];
    BOOL cursorAtEnd = (index == self.textField.text.length);

    if (self.cardType == nil) {
        return cursorAtEnd && self.cvv.length == kMaximumCvvLength;
    } else {
        return self.valid;
    }
}

- (BOOL)textField:(__unused UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return string.length + range.location <= self.validLength;
}

- (NSUInteger)validLength {
    return self.cardType == nil ? kMaximumCvvLength : self.cardType.validCvvLength;
}

- (void)setCvv:(NSString *)cvv {
    _cvv = cvv;
    self.text = cvv;
}

#pragma mark - Handlers

- (void)fieldContentDidChange {
    self.displayAsValid = YES;
    _cvv = [BTUIUtil stripNonDigits:self.textField.text];
    [self.delegate formFieldDidChange:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    self.displayAsValid = YES;
    [self.hint setHighlighted:YES animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    self.displayAsValid = self.textField.text.length == 0 || self.valid;
    [self.hint setHighlighted:NO animated:YES];
}


@end
