#import "BTUITextField.h"

@interface BTUITextField () <UITextFieldDelegate>
@property (nonatomic, copy) NSString *previousText;
@end

@implementation BTUITextField

- (instancetype)init {
    if (self = [super init]) {
        if ([UIDevice currentDevice].systemVersion.intValue == 9) {
            [self addTarget:self action:@selector(iOS9_changed) forControlEvents:UIControlEventEditingChanged];
            self.delegate = self;
        }
    }
    return self;
}

- (void)iOS9_changed {
    // We only want to notify when this text field's text length has increased
    if (self.previousText.length >= self.text.length) {
        self.previousText = self.text;
        return;
    }
    self.previousText = self.text;
    
    NSString *insertedText = [self.text substringWithRange:NSMakeRange(self.previousText.length, self.text.length - self.previousText.length)];
    
    if ([self.editDelegate respondsToSelector:@selector(textField:willInsertText:)]) {
        // Sets _backspace = NO; in the BTUIFormField or BTUIFormField subclass
        [self.editDelegate textField:self willInsertText:insertedText];
    }

    self.previousText = self.text;
    
    if ([self.editDelegate respondsToSelector:@selector(textField:didInsertText:)]) {
        [self.editDelegate textField:self didInsertText:insertedText];
    }
}

- (BOOL)keyboardInputShouldDelete:(__unused UITextField *)textField {
    if ([self.editDelegate respondsToSelector:@selector(textFieldWillDeleteBackward:)]) {
        [self.editDelegate textFieldWillDeleteBackward:self];
    }

    BOOL shouldDelete = YES;

    if ([UITextField instancesRespondToSelector:_cmd]) {
        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextField *) = (BOOL (*)(id, SEL, UITextField *))[UITextField instanceMethodForSelector:_cmd];

        if (keyboardInputShouldDelete) {
            shouldDelete = keyboardInputShouldDelete(self, _cmd, textField);
        }
    }

    BOOL isIos8 = ([[[UIDevice currentDevice] systemVersion] intValue] == 8);
    BOOL isLessThanIos8_3 = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.3f);

    // iOS 8.0-8.2 has a bug where deleteBackward is not called even when this method returns YES and the character is deleted
    // As a result, we do so manually but return NO in order to prevent UITextField from double-calling the delegate method
    // (textFieldDidDeleteBackwards:originalText:)
    if (isIos8 && isLessThanIos8_3) {
        [self deleteBackward];
        shouldDelete = NO;
    }
    
    return shouldDelete;
}

- (void)deleteBackward
{
    BOOL shouldDismiss = [self.text length] == 0;
    NSString *originalText = self.text;

    [super deleteBackward];

    if (shouldDismiss) {
        if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
        }
    }

    if ([self.editDelegate respondsToSelector:@selector(textFieldDidDeleteBackward:originalText:)]) {
        [self.editDelegate textFieldDidDeleteBackward:self originalText:originalText];
    }
}

- (void)insertText:(NSString *)text {
    if ([self.editDelegate respondsToSelector:@selector(textField:willInsertText:)]) {
        [self.editDelegate textField:self willInsertText:text];
    }

    [super insertText:text];

    if ([self.editDelegate respondsToSelector:@selector(textField:didInsertText:)]) {
        [self.editDelegate textField:self didInsertText:text];
    }
}

@end
