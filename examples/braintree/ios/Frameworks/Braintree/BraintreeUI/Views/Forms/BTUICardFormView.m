#import "BTUICardFormView.h"
#import "BTUICardNumberField.h"
#import "BTUICardExpiryField.h"
#import "BTUICardCvvField.h"
#import "BTUICardPhoneNumberField.h"
#import "BTUICardPostalCodeField.h"
#import "BTUI.h"
#import "BTUILocalizedString.h"
#import "BTUIViewUtil.h"

@interface BTUICardFormView ()<BTUIFormFieldDelegate>

@property (nonatomic, strong) BTUICardNumberField *numberField;
@property (nonatomic, strong) BTUICardExpiryField *expiryField;
@property (nonatomic, strong) BTUICardCvvField *cvvField;
@property (nonatomic, strong) BTUICardPostalCodeField *postalCodeField;
@property (nonatomic, strong) BTUICardPhoneNumberField *phoneNumberField;

@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) NSArray *dynamicConstraints;
@property (nonatomic, assign, readwrite) BOOL valid;
@property (nonatomic, assign) BTUIPaymentOptionType lastPaymentMethodType;

@end

@implementation BTUICardFormView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGFloat height = 0;
    for (BTUIFormField *field in self.fields) {
        height += field.intrinsicContentSize.height;
    }
     // subtract (number of field adjacencies) * (number of pixels overlap per adjacency)
    height -= (self.fields.count - 1) * 1;

    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

#pragma mark - Getters/setters

- (void)showErrorForField:(__unused BTUICardFormField)field {
    switch (field) {
        case BTUICardFormFieldNumber:
            self.numberField.displayAsValid = NO;
            break;
        case BTUICardFormFieldExpiration:
            self.expiryField.displayAsValid = NO;
            break;
        case BTUICardFormFieldCvv:
            self.cvvField.displayAsValid = NO;
            break;
        case BTUICardFormFieldPostalCode:
            self.postalCodeField.displayAsValid = NO;
            break;
        case BTUICardFormFieldPhoneNumber:
            self.phoneNumberField.displayAsValid = NO;
            break;
    }
}

- (void)showTopLevelError:(NSString *)message {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *localizedOK = BTUILocalizedString(TOP_LEVEL_ERROR_ALERT_VIEW_OK_BUTTON_TEXT);
    [[[UIAlertView alloc] initWithTitle:message
                                message:nil
                               delegate:nil
                      cancelButtonTitle:localizedOK
                      otherButtonTitles:nil] show];
#pragma clang diagnostic pop
}

- (void)setAlphaNumericPostalCode:(BOOL)alphaNumericPostalCode {
    _alphaNumericPostalCode = alphaNumericPostalCode;
    self.postalCodeField.nonDigitsSupported = alphaNumericPostalCode;
}

- (void)setOptionalFields:(BTUICardFormOptionalFields)optionalFields {
    _optionalFields = optionalFields;
    
    NSArray *defaultFields = @[self.numberField, self.expiryField];
    NSMutableArray *fields = [defaultFields mutableCopy];

    self.cvvField.hidden = self.postalCodeField.hidden = self.phoneNumberField.hidden = YES;
    if (optionalFields & BTUICardFormOptionalFieldsPostalCode) {
        [fields addObject:self.postalCodeField];
        self.postalCodeField.hidden = NO;
    }
    if (optionalFields & BTUICardFormOptionalFieldsCvv) {
        [fields addObject:self.cvvField];
        self.cvvField.hidden = NO;
    }
    if (optionalFields & BTUICardFormOptionalFieldsPhoneNumber) {
        [fields addObject:self.phoneNumberField];
        self.phoneNumberField.hidden = NO;
    }

    // Set bottom border for fields
    for (NSUInteger i = 0; i < fields.count - 1; i++) {
        [fields[i] setBottomBorder:YES];
    }
    [[fields lastObject] setBottomBorder:NO];

    self.fields = fields;

    [self invalidateIntrinsicContentSize];
}

- (void)setExpirationDate:(NSDate *)expirationDate {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        // The expiry field only allows digit chars to be entered
        dateFormatter.dateFormat = @"MMyyyy";
    }

    NSString *expirationDateString = [dateFormatter stringFromDate:expirationDate];
    [self.expiryField setText:expirationDateString];
}

- (void)setExpirationMonth:(NSInteger)expirationMonth year:(NSInteger)expirationYear {
    NSString *expirationMonthString = expirationMonth < 10 ? [NSString stringWithFormat:@"0%ld", (long)expirationMonth] : [NSString stringWithFormat:@"%ld", (long)expirationMonth];
    NSString *expirationYearString = expirationYear < 100 ? [NSString stringWithFormat:@"20%ld", (long)expirationYear] : [NSString stringWithFormat:@"%ld", (long)expirationYear];
    self.expiryField.text = [NSString stringWithFormat:@"%@%@", expirationMonthString, expirationYearString];
}

- (NSString *)phoneNumber {
    return self.phoneNumberField.text.length > 0 ? self.phoneNumberField.text : nil;
}

- (void)setup {
    self.opaque = NO;
    self.backgroundColor = [UIColor whiteColor];

    self.dynamicConstraints = @[];

    _numberField = [[BTUICardNumberField alloc] init];
    self.numberField.translatesAutoresizingMaskIntoConstraints = NO;
    self.numberField.delegate = self;
    [self addSubview:self.numberField];

    _expiryField = [[BTUICardExpiryField alloc] init];
    self.expiryField.translatesAutoresizingMaskIntoConstraints = NO;
    self.expiryField.delegate = self;
    [self addSubview:self.expiryField];

    _cvvField = [[BTUICardCvvField alloc] init];
    self.cvvField.translatesAutoresizingMaskIntoConstraints = NO;
    self.cvvField.delegate = self;
    [self addSubview:self.cvvField];

    _postalCodeField = [[BTUICardPostalCodeField alloc] init];
    self.postalCodeField.translatesAutoresizingMaskIntoConstraints = NO;
    self.postalCodeField.delegate = self;
    [self addSubview:self.postalCodeField];
    [self setAlphaNumericPostalCode:YES];
    
    self.phoneNumberField = [[BTUICardPhoneNumberField alloc] init];
    self.phoneNumberField.translatesAutoresizingMaskIntoConstraints = NO;
    self.phoneNumberField.delegate = self;
    [self addSubview:self.phoneNumberField];

    self.vibrate = YES;
    self.optionalFields = BTUICardFormOptionalFieldsAll;

    for (UIView *v in self.fields) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:@{} views:@{@"v": v}]];
    }


    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]"
                                                                 options:0
                                                                 metrics:0
                                                                   views:@{@"v": self.numberField}]];

}

- (void)updateConstraints {
    [self removeConstraints:self.dynamicConstraints];

    NSMutableArray *newContraints = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.fields.count - 1; i++) {
        BTUIFormField *fieldAbove = self.fields[i];
        BTUIFormField *fieldBelow = self.fields[i+1];
        [newContraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[v]-(-1)-[v2]"
                                                                                   options:0
                                                                                   metrics:0
                                                                                     views:@{@"v": fieldAbove, @"v2": fieldBelow }]];
    }

    self.dynamicConstraints = newContraints;
    [self addConstraints:self.dynamicConstraints];

    [super updateConstraints];

}

#pragma mark - Theme

- (void)setTheme:(BTUI *)theme {
  [super setTheme:theme];
  
  _numberField.theme = theme;
  _expiryField.theme = theme;
  _cvvField.theme = theme;
  _postalCodeField.theme = theme;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.theme.borderColor setFill];

    // Top
    CGPathRef path = CGPathCreateWithRect(CGRectMake(rect.origin.x, 0, rect.size.width, 0.5f), NULL);
    CGContextAddPath(context, path);
    CGPathRelease(path);

    // Bottom
    path = CGPathCreateWithRect(CGRectMake(rect.origin.x, CGRectGetMaxY(rect) - 0.5f, rect.size.width, 0.5f), NULL);
    CGContextAddPath(context, path);

    CGContextDrawPath(context, kCGPathFill);
    CGPathRelease(path);
}

#pragma mark - Validity

- (BOOL)valid {
    _valid = YES;
    for (BTUIFormField *f in self.fields) {
        if (!f.valid) {
            _valid = NO;
        }
    }
    return _valid;
}

- (void)setVibrate:(BOOL)vibrate {
    _vibrate = vibrate;
    for (BTUIFormField *f in self.fields) {
        f.vibrateOnInvalidInput = vibrate;
    }
}

#pragma mark - Value getters

- (NSString *)number {
    return self.numberField.number;
}

- (void)setNumber:(NSString *)number {
  self.numberField.number = number;
}

- (NSString *)expirationMonth {
    return self.expiryField.expirationMonth;
}

- (NSString *)expirationYear {
    return self.expiryField.expirationYear;
}

- (NSString *)cvv {
    return self.optionalFields & BTUICardFormOptionalFieldsCvv ? self.cvvField.cvv : nil;
}

- (void)setCvv:(NSString *)cvv {
    self.cvvField.cvv = cvv;
}

- (NSString *)postalCode {
    return self.optionalFields & BTUICardFormOptionalFieldsPostalCode ? self.postalCodeField.postalCode : nil;
}

- (void)setPostalCode:(NSString *)postalCode {
    self.postalCodeField.postalCode = postalCode;
}

#pragma mark - Field delegate implementations

- (void)formFieldDidChange:(BTUIFormField *)field {
    if (field == self.numberField) {
        self.cvvField.cardType = self.numberField.cardType;
    }
    [self advanceToNextInvalidFieldFrom:field];
    // Trigger KVO
    self.valid = self.valid;
    if ([self.delegate respondsToSelector:@selector(cardFormViewDidChange:)]) {
        [self.delegate cardFormViewDidChange:self];
    }
}

- (void)formFieldDidBeginEditing:(__unused BTUIFormField *)field {
    if ([self.delegate respondsToSelector:@selector(cardFormViewDidBeginEditing:)]) {
        [self.delegate cardFormViewDidBeginEditing:self];
    }
}

- (void)formFieldDidEndEditing:(__unused BTUIFormField *)field {
    if ([self.delegate respondsToSelector:@selector(cardFormViewDidEndEditing:)]) {
        [self.delegate cardFormViewDidEndEditing:self];
    }
}

- (void)formFieldDidDeleteWhileEmpty:(BTUIFormField *)formField {
    [self switchToPreviousField:formField];
}

- (BOOL)formFieldShouldReturn:(BTUIFormField *)formField {
    [formField resignFirstResponder];
    return NO;
}

#pragma mark - Auto-advancing

- (void)advanceToNextInvalidFieldFrom:(BTUIFormField *)field {
    if (field.entryComplete) {
        NSUInteger fieldIndex = [self.fields indexOfObject:field];
        NSUInteger startIndex = (fieldIndex + 1) % self.fields.count;

        for (NSUInteger i = startIndex ; i != fieldIndex; i = (i + 1) % self.fields.count) {
            BTUIFormField *ithField = self.fields[i];
            if (!ithField.valid) {
                [ithField becomeFirstResponder];
                break;
            }
        }
    }
}

- (void)switchToPreviousField:(BTUIFormField *)field {
    NSUInteger fieldIndex = [self.fields indexOfObject:field];
    if (fieldIndex == 0) {
        return;
    }
    NSInteger previousIndex = (fieldIndex - 1);
    if (previousIndex < 0) {
        return;
    }
    BTUIFormField *previousField = self.fields[previousIndex];
    [previousField becomeFirstResponder];
    if (previousField.text.length > 0) {
        [previousField deleteBackward];
    }
}


@end
