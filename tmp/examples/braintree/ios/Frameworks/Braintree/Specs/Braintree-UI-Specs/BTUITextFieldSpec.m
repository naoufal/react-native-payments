#import "BTUITextField.h"
#import <PureLayout/PureLayout.h>

/// A custom mock outside of OCMock for spying on the BTUITextField text value at various
/// points in the editDelegate lifecycle
@interface BTUITextFieldSpecMockEditDelegate : NSObject <BTUITextFieldEditDelegate>
@property (copy, nonatomic) NSString *textAtTimeOfWillInsertText;
@property (copy, nonatomic) NSString *textAtTimeOfDidInsertText;
@property (copy, nonatomic) NSString *textAtTimeOfWillDeleteBackward;
@property (copy, nonatomic) NSString *textAtTimeOfDidDeleteBackward;
@end

@implementation BTUITextFieldSpecMockEditDelegate

- (void)textField:(BTUITextField *)textField willInsertText:(NSString *)text {
    self.textAtTimeOfWillInsertText = textField.text;
}
- (void)textField:(BTUITextField *)textField didInsertText:(NSString *)text {
    self.textAtTimeOfDidInsertText = textField.text;
}
- (void)textFieldWillDeleteBackward:(BTUITextField *)textField {
    self.textAtTimeOfWillDeleteBackward = textField.text;
}
- (void)textFieldDidDeleteBackward:(BTUITextField *)textField originalText:(NSString *)originalText {
    self.textAtTimeOfDidDeleteBackward = textField.text;
}

@end

SpecBegin(BTUITextField)

describe(@"text field behavior", ^{
    it(@"can accept user input", ^{
        BTUITextField *textField = [[BTUITextField alloc] init];
        textField.backgroundColor = [UIColor whiteColor];
        textField.accessibilityLabel = @"Some Field";
        [system presentView:textField];
        // The text field's initial frame is based on the intrinsic size. We want the view to be
        // big enough to see.
        [textField autoSetDimension:ALDimensionWidth toSize:300];
        [textField autoSetDimension:ALDimensionHeight toSize:44];
        [tester tapViewWithAccessibilityLabel:@"Some Field"];
        [tester enterTextIntoCurrentFirstResponder:@"Hello, World!"];

        expect(textField.text).to.equal(@"Hello, World!");
    });
});

describe(@"editDelegate", ^{
    __block BTUITextField *textField;
    __block BTUITextFieldSpecMockEditDelegate<BTUITextFieldEditDelegate> *editDelegate;

    beforeEach(^{
        editDelegate = OCMPartialMock([[BTUITextFieldSpecMockEditDelegate alloc] init]);
        textField = [[BTUITextField alloc] init];
        textField.editDelegate = editDelegate;
        textField.backgroundColor = [UIColor whiteColor];
        textField.text = @"Some text";
        textField.accessibilityLabel = @"Some Field";
        [system presentView:textField];
        [tester tapViewWithAccessibilityLabel:@"Some Field"];
        [tester waitForTimeInterval:2];
    });

    describe(@"delegate method protocol", ^{
        it(@"textField:willInsertText: and textField:didInsertText: are called when user enters text", ^{
            [(OCMockObject *)editDelegate setExpectationOrderMatters:YES];
            OCMExpect([editDelegate textField:textField willInsertText:@"a"]).andForwardToRealObject();
            OCMExpect([editDelegate textField:textField didInsertText:@"a"]).andForwardToRealObject();

            [tester enterTextIntoCurrentFirstResponder:@"a"];

            OCMVerify(editDelegate);
            // Note: the behavior of `insertText:` in iOS 9 is buggy. We have implemented
            // a workaround that makes the card expiry field functional, but the workaround
            // causes willInsertText to be called *after* the text has already been inserted.
            if ([UIDevice currentDevice].systemVersion.intValue < 9) {
                expect(editDelegate.textAtTimeOfWillInsertText).to.equal(@"Some text");
            } else {
                expect(editDelegate.textAtTimeOfWillInsertText).to.equal(@"Some texta");
            }
            expect(editDelegate.textAtTimeOfDidInsertText).to.equal(@"Some texta");
        });

        it(@"textField:willDeleteBackward: and textField:didDeleteBackward:originalText: are called when user backspaces", ^{
            [(OCMockObject *)editDelegate setExpectationOrderMatters:YES];
            OCMExpect([editDelegate textFieldWillDeleteBackward:textField]).andForwardToRealObject();
            OCMExpect([editDelegate textFieldDidDeleteBackward:textField originalText:@"Some text"]).andForwardToRealObject();

            [tester enterTextIntoCurrentFirstResponder:@"\b"];

            OCMVerify(editDelegate);
            expect(editDelegate.textAtTimeOfWillDeleteBackward).to.equal(@"Some text");
            expect(editDelegate.textAtTimeOfDidDeleteBackward).to.equal(@"Some tex");
        });

        it(@"textField:willDeleteBackward: and textField:didDeleteBackward:originalText: are called when user backspaces beyond the first character", ^{
            textField.text = @"AB";

            [(OCMockObject *)editDelegate setExpectationOrderMatters:YES];
            OCMExpect([editDelegate textFieldWillDeleteBackward:textField]).andForwardToRealObject();
            OCMExpect([editDelegate textFieldDidDeleteBackward:textField originalText:@"AB"]).andForwardToRealObject();

            // Delete "B"
            [tester enterTextIntoCurrentFirstResponder:@"\b"];

            OCMVerify(editDelegate);
            expect(editDelegate.textAtTimeOfWillDeleteBackward).to.equal(@"AB");

            // Reduce likelihood of failure: expected: A, got: nil/null
            [tester waitForTimeInterval:0.1];

            expect(editDelegate.textAtTimeOfDidDeleteBackward).to.equal(@"A");

            // Delete "A"
            [tester enterTextIntoCurrentFirstResponder:@"\b"];

            OCMExpect([editDelegate textFieldWillDeleteBackward:textField]).andForwardToRealObject();
            OCMExpect([editDelegate textFieldDidDeleteBackward:textField originalText:@""]).andForwardToRealObject();

            // Backspace, nothing to delete
            [tester enterTextIntoCurrentFirstResponder:@"\b"];

            OCMVerify(editDelegate);
            expect(editDelegate.textAtTimeOfWillDeleteBackward).to.equal(@"");
            expect(editDelegate.textAtTimeOfDidDeleteBackward).to.equal(@"");
        });
    });
});

SpecEnd
