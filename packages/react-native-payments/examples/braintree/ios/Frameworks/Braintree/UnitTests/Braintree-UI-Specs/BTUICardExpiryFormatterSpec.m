#import <UIKit/UIKit.h>
#import "BTSpecDependencies.h"
#import "BTUICardExpiryFormat.h"

SpecBegin(BTUICardExpiryFormatter)

describe(@"formattedValue", ^{

    __block  BTUICardExpiryFormat *format;
    beforeEach(^{
        format = [[BTUICardExpiryFormat alloc] init];
    });

    describe(@"backspace", ^{
        beforeEach(^{
            format.backspace = YES;
        });

        it(@"is a no-op when the value is empty", ^{
            format.value = @"";
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

            expect(formattedValue).to.equal(@"");
            expect(formattedCursorLocation).to.equal(0);
        });

        it(@"maintains the slash when deleting the first year digit", ^{
            format.value = @"12/";
            format.cursorLocation = 3;
            format.backspace = YES;
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

            expect(formattedValue).to.equal(@"12/");
            expect(formattedCursorLocation).to.equal(3);
        });

        it(@"deletes the second month digit when backspacing the slash", ^{
            format.value = @"12";
            format.cursorLocation = 2;
            format.backspace = YES;
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

            expect(formattedValue).to.equal(@"1");
            expect(formattedCursorLocation).to.equal(1);
        });
    });

    describe(@"insertion", ^{
        it(@"is a no-op when the value is empty", ^{
            format.value = @"";
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

            expect(formattedValue).to.equal(@"");
            expect(formattedCursorLocation).to.equal(0);
        });

        it(@"prepends 0 and appends / if one digit >1 is entered", ^{
            format.value = @"2";
            format.cursorLocation = 1;
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

            expect(formattedValue).to.equal(@"02/");
            expect(formattedCursorLocation).to.equal(3);
        });

        it(@"does not insert a slash when appending the first month digit", ^{
            format.value = @"1";
            format.cursorLocation = 1;
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

            expect(formattedValue).to.equal(@"1");
            expect(formattedCursorLocation).to.equal(1);
        });

        it(@"inserts a slash when appending the second digit of the month", ^{
            format.value = @"12";
            format.cursorLocation = 2;
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

            expect(formattedValue).to.equal(@"12/");
            expect(formattedCursorLocation).to.equal(3);
        });

        it(@"maintains the slash when inserting a digit before", ^{
            format.value = @"012/";
            format.cursorLocation = 3;
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

            expect(formattedValue).to.equal(@"01/2");
            expect(formattedCursorLocation).to.equal(4);
        });

        it(@"maintains the slash when inserting two digits before", ^{
            format.value = @"0123/";
            format.cursorLocation = 4;
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];

            expect(formattedValue).to.equal(@"01/23");
            expect(formattedCursorLocation).to.equal(5);
        });

        it(@"inserts the slash when pasting in a non-slash date", ^{
            format.value = @"0123";
            format.cursorLocation = 4;
            NSString *formattedValue;
            NSUInteger formattedCursorLocation;
            [format formattedValue:&formattedValue cursorLocation:&formattedCursorLocation];
            
            expect(formattedValue).to.equal(@"01/23");
            expect(formattedCursorLocation).to.equal(5);
        });
    });
});

SpecEnd
