#import "BTUIFormField_Protected.h"
#import "BTUIViewUtil.h"
#import "BTUITextField.h"
#import "BTUIFloatLabel.h"

@import QuartzCore;

static const CGFloat formFieldTopMargin = 7;
static const CGFloat formFieldLabelHeight = 15;
static const CGFloat formFieldVerticalSpace = 1;
static const CGFloat formFieldTextFieldHeight = 20;
static const CGFloat formFieldBottomMargin = 11;

@interface BTUIFormField ()<BTUITextFieldEditDelegate>

@property (nonatomic, strong) BTUIFloatLabel *floatLabel;
@property (nonatomic, copy) NSString *previousTextFieldText;
@property (nonatomic, strong) NSMutableArray *layoutConstraints;

@end

@implementation BTUIFormField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.displayAsValid = YES;
        BTUITextField *textField = [BTUITextField new];
        textField.editDelegate = self;
        _textField = textField;
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.opaque = NO;
        self.textField.adjustsFontSizeToFitWidth = YES;
        self.textField.returnKeyType = UIReturnKeyNext;

        self.floatLabel = [[BTUIFloatLabel alloc] init];
        self.floatLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.floatLabel hideWithAnimation:NO];

        self.accessoryView = [[UIView alloc] init];
        self.accessoryView.backgroundColor = [UIColor clearColor];
        self.accessoryView.hidden = YES;

        [self.textField addTarget:self action:@selector(fieldContentDidChange) forControlEvents:UIControlEventEditingChanged];
        [self.textField addTarget:self action:@selector(editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
        [self.textField addTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];

        self.textField.delegate = self;

        [self addSubview:self.textField];
        [self addSubview:self.floatLabel];
        [self addSubview:self.accessoryView];

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedField)]];

        [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.opaque = NO;

        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChange)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGFloat height = formFieldTopMargin + formFieldLabelHeight + formFieldVerticalSpace + formFieldTextFieldHeight + formFieldBottomMargin;
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

- (void)setAccessoryView:(UIView *)accessoryView {
    _accessoryView = accessoryView;
    self.accessoryView.userInteractionEnabled = NO;
    self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setDisplayAsValid:(BOOL)displayAsValid {
    if (self.vibrateOnInvalidInput && self.textField.isFirstResponder && _displayAsValid && !displayAsValid) {
        [BTUIViewUtil vibrate];
    }

    _displayAsValid = displayAsValid;
    [self updateAppearance];
    [self setNeedsDisplay];
}

- (void)orientationChange {
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Validity "abstract" methods

- (BOOL)valid {
    return YES;
}

- (BOOL)entryComplete {
    NSUInteger index = [self.textField offsetFromPosition:self.textField.beginningOfDocument toPosition:self.textField.selectedTextRange.start];
    return index == self.textField.text.length && self.valid;
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [super resignFirstResponder] || [self.textField resignFirstResponder];
}

#pragma mark - Theme

- (void)setTheme:(BTUI *)theme {
    [super setTheme:theme];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:self.theme.textFieldTextAttributes];
    d[NSKernAttributeName] = @0;
    self.textField.defaultTextAttributes = self.theme.textFieldTextAttributes;
    self.floatLabel.theme = theme;
}

- (void)setThemedPlaceholder:(NSString *)placeholder {
    self.floatLabel.label.text = placeholder;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder ?: @""
                                                                           attributes:self.theme.textFieldPlaceholderAttributes];
}

- (void)setThemedAttributedPlaceholder:(NSAttributedString *)placeholder {
    NSMutableAttributedString *mutableFloatLabel = [[NSMutableAttributedString alloc] initWithAttributedString:placeholder];
    [mutableFloatLabel beginEditing];
    [mutableFloatLabel removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [mutableFloatLabel length])];
    [mutableFloatLabel removeAttribute:NSBackgroundColorAttributeName range:NSMakeRange(0, [mutableFloatLabel length])];
    [mutableFloatLabel removeAttribute:NSFontAttributeName range:NSMakeRange(0, [mutableFloatLabel length])];
    [mutableFloatLabel endEditing];
    self.floatLabel.label.attributedText = mutableFloatLabel;

    NSMutableAttributedString *mutablePlaceholder = [[NSMutableAttributedString alloc] initWithAttributedString:placeholder];
    [mutablePlaceholder beginEditing];
    [mutablePlaceholder addAttributes:self.theme.textFieldPlaceholderAttributes range:NSMakeRange(0, [mutablePlaceholder length])];
    [mutablePlaceholder endEditing];

    self.textField.attributedPlaceholder = mutablePlaceholder;
}

#pragma mark - Drawing

- (void)updateAppearance {
    UIColor *textColor;
    NSString *currentAccessibilityLabel = self.textField.accessibilityLabel;
    if (!self.displayAsValid){
        textColor = self.theme.errorForegroundColor;
        self.backgroundColor = self.theme.errorBackgroundColor;
        if (currentAccessibilityLabel != nil) {
            self.textField.accessibilityLabel = [self addInvalidAccessibilityToString:currentAccessibilityLabel];
        }
    } else {
        textColor = self.theme.textFieldTextColor;
        self.backgroundColor = [UIColor clearColor];
        if (currentAccessibilityLabel != nil) {
            self.textField.accessibilityLabel = [self stripInvalidAccessibilityFromString:currentAccessibilityLabel];
        }
    }

    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textField.attributedText];
    [mutableText addAttributes:@{NSForegroundColorAttributeName: textColor} range:NSMakeRange(0, mutableText.length)];

    UITextRange *currentRange = self.textField.selectedTextRange;

    self.textField.attributedText = mutableText;

    // Reassign current selection range, since it gets cleared after attributedText assignment
    self.textField.selectedTextRange = currentRange;
}

- (void)drawRect:(CGRect)rect {

    // Draw borders

    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!self.displayAsValid) {
        [self.theme.errorForegroundColor setFill];

        CGPathRef path = CGPathCreateWithRect(CGRectMake(rect.origin.x, CGRectGetMaxY(rect) - 0.5f, rect.size.width, 0.5f), NULL);
        CGContextAddPath(context, path);
        CGPathRelease(path);

        path = CGPathCreateWithRect(CGRectMake(rect.origin.x, 0, rect.size.width, 0.5f), NULL);
        CGContextAddPath(context, path);

        CGContextDrawPath(context, kCGPathFill);
        CGPathRelease(path);
    } else if (self.bottomBorder) {
        CGFloat horizontalMargin = [self.theme horizontalMargin];
        CGPathRef path = CGPathCreateWithRect(CGRectMake(rect.origin.x + horizontalMargin, CGRectGetMaxY(rect) - 0.5f, rect.size.width - horizontalMargin, 0.5f), NULL);
        CGContextAddPath(context, path);
        [self.theme.borderColor setFill];
        CGContextDrawPath(context, kCGPathFill);
        CGPathRelease(path);
    }
}

- (void)setBottomBorder:(BOOL)bottomBorder {
    _bottomBorder = bottomBorder;
    [self setNeedsDisplay];
}

- (void)updateConstraints {

    NSDictionary *metrics = @{@"horizontalMargin": @([self.theme horizontalMargin]),
                              @"accessoryViewWidth": @44,
                              @"formFieldTopMargin": @(formFieldTopMargin),
                              @"formFieldLabelHeight": @(formFieldLabelHeight),
                              @"formFieldVerticalSpace": @(formFieldVerticalSpace),
                              @"formFieldTextFieldHeight": @(formFieldTextFieldHeight),
                              @"formFieldBottomMargin": @(formFieldBottomMargin)
                              };
    NSDictionary *views = @{ @"textField": self.textField,
                             @"floatLabel": self.floatLabel,
                             @"accessoryView": self.accessoryView };

    if (self.layoutConstraints != nil) {
        [self removeConstraints:self.layoutConstraints];
    }
    self.layoutConstraints = [NSMutableArray array];

    // Pin accessory view to right with constant width

    [self.layoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[accessoryView]-(horizontalMargin)-|"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:metrics
                                                                                views:views]];


    // Horizontally Pin Float Label and accessory view
    [self.layoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(horizontalMargin)-[floatLabel]-(horizontalMargin)-[accessoryView]-(horizontalMargin)-|" options:0 metrics:metrics views:views]];

    // Horizontally Pin text field and accessory view
    [self.layoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(horizontalMargin)-[textField]-(horizontalMargin)-[accessoryView]-(horizontalMargin)-|" options:0 metrics:metrics views:views]];

    [self.layoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[accessoryView(==accessoryViewWidth)]" options:0 metrics:metrics views:views]];

    [self.layoutConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(formFieldTopMargin)-[floatLabel(==formFieldLabelHeight)]-(formFieldVerticalSpace)-[textField(==formFieldTextFieldHeight)]-(formFieldBottomMargin)-|" options:0 metrics:metrics views:views]];
    [self.layoutConstraints addObject:[NSLayoutConstraint constraintWithItem:self.accessoryView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0f
                                                                    constant:0]];
    NSArray *contraintsToAdd = [self.layoutConstraints copy];
    [self addConstraints:contraintsToAdd];
    [super updateConstraints];

}

- (void)didDeleteBackward {
    if (self.previousTextFieldText.length == 0 && self.textField.text.length == 0) {
        [self.delegate formFieldDidDeleteWhileEmpty:self];
    }
}


- (void)updateFloatLabelTextColor {
    if ([self.textField isFirstResponder]) {
        self.floatLabel.label.textColor = self.tintColor;
    } else {
        self.floatLabel.label.textColor = self.theme.textFieldFloatLabelTextColor;
    }
}

- (void)tintColorDidChange {
    [self updateFloatLabelTextColor];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(__unused UITextField *)textField {
    [self updateFloatLabelTextColor];
    if ([self.delegate respondsToSelector:@selector(formFieldDidBeginEditing:)]) {
        [self.delegate formFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(__unused UITextField *)textField {
    [self updateFloatLabelTextColor];
    if ([self.delegate respondsToSelector:@selector(formFieldDidEndEditing:)]) {
        [self.delegate formFieldDidEndEditing:self];
    }
}

#pragma mark - BTUITextFieldEditDelegate methods

- (void)textFieldWillDeleteBackward:(__unused BTUITextField *)textField {
    // _backspace indicates that the backspace key was typed.
    _backspace = YES;

}

- (void)textFieldDidDeleteBackward:(BTUITextField *)textField originalText:(__unused NSString *)originalText {
    if (originalText.length == 0) {
        [self.delegate formFieldDidDeleteWhileEmpty:self];
    }

    if (textField.text.length == 0) {
        [self.floatLabel hideWithAnimation:YES];
    }
}

- (void)textField:(__unused BTUITextField *)textField willInsertText:(__unused NSString *)text {
    _backspace = NO;
}

- (void)textField:(BTUITextField *)textField didInsertText:(__unused NSString *)text {
    if (textField.text.length > 0) {
        [self.floatLabel showWithAnimation:YES];
    }
}

- (void)setAccessoryHighlighted:(BOOL)highlight {
    if (self.accessoryView) {
        if ([self.accessoryView respondsToSelector:@selector(setHighlighted:animated:)]) {
            SEL selector = @selector(setHighlighted:animated:);
            BOOL animated = YES;
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self.accessoryView methodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:self.accessoryView];
            [invocation setArgument:&highlight atIndex:2];
            [invocation setArgument:&animated atIndex:3];
            [invocation invoke];
        }
    }
}

#pragma mark - Custom accessors

- (void)setText:(NSString *)text {
    BOOL shouldChange = [self.textField.delegate textField:self.textField
                             shouldChangeCharactersInRange:NSMakeRange(0, self.textField.text.length)
                                         replacementString:text];
    if (shouldChange) {
        [self.textField.delegate textFieldDidBeginEditing:self.textField];
        [self.textField.editDelegate textField:self.textField willInsertText:text];
        self.textField.text = text;
        [self fieldContentDidChange];
        [self.textField.editDelegate textField:self.textField didInsertText:text];
        [self.textField.delegate textFieldDidEndEditing:self.textField];

    }
}

- (NSString *)text {
    return self.textField.text;
}

#pragma mark - Delegate methods and handlers

- (void)fieldContentDidChange {
    // To be implemented by subclass
}

- (void)editingDidBegin {
    [self setAccessoryHighlighted:YES];
}

- (void)editingDidEnd {
    [self setAccessoryHighlighted:NO];
}


- (BOOL)textField:(__unused UITextField *)textField shouldChangeCharactersInRange:(__unused NSRange)range replacementString:(__unused NSString *)newText {
    // To be implemented by subclass
    return YES;
}

- (BOOL)textFieldShouldReturn:(__unused UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(formFieldShouldReturn:)]) {
        return [self.delegate formFieldShouldReturn:self];
    } else {
        return YES;
    }
}

- (void)tappedField {
    [self.textField becomeFirstResponder];
}

#pragma mark UIKeyInput

- (void)insertText:(NSString *)text {
    [self.textField insertText:text];
}

- (void)deleteBackward {
    [self.textField deleteBackward];
}

- (BOOL)hasText {
    return [self.textField hasText];
}

#pragma mark Accessibility Helpers

- (NSString *)stripInvalidAccessibilityFromString:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:@"Invalid: " withString:@""];
}

- (NSString *)addInvalidAccessibilityToString:(NSString *)str {
    return [NSString stringWithFormat:@"Invalid: %@", [self stripInvalidAccessibilityFromString:str]];
}

@end

