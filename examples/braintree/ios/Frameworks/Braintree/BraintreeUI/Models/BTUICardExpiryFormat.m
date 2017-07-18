#import "BTUICardExpiryFormat.h"
#import "BTUIUtil.h"

@implementation BTUICardExpiryFormat

- (void)formattedValue:(NSString *__autoreleasing *)value cursorLocation:(NSUInteger *)cursorLocation {
    if (value == NULL || cursorLocation == NULL) {
        return;
    }

    NSMutableString *s = [NSMutableString stringWithString:self.value];
    *cursorLocation = self.cursorLocation;

    if (s.length == 0) {
        *value = s;
        return;
    }

    if (*cursorLocation == 1 && s.length == 1 && [s characterAtIndex:0] > '1' && [s characterAtIndex:0] <= '9') {
        [s insertString:@"0" atIndex:0];
        *cursorLocation += 1;
    }

    if (self.backspace) {
        if (*cursorLocation == 2 && s.length == 2) {
            [s deleteCharactersInRange:NSMakeRange(1, 1)];
            *cursorLocation -= 1;
        }
    } else {

        NSUInteger slashLocation = [s rangeOfString:@"/"].location;
        if (slashLocation != NSNotFound) {
            if (slashLocation > 2) {
                s = [NSMutableString stringWithString:[BTUIUtil stripNonDigits:s]];
                [s insertString:@"/" atIndex:2];
                *cursorLocation += 1;
            }
        } else {
            if (s.length >= 2) {
                [s insertString:@"/" atIndex:2];
                if (*cursorLocation >= 2) {
                    *cursorLocation += 1;
                }
            }
        }
    }

    *value = s;
}

@end
