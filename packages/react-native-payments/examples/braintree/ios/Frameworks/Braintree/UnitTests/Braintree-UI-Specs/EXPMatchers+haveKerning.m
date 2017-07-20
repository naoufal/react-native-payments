#import "EXPMatchers+haveKerning.h"
#import <UIKit/UIKit.h>

EXPMatcherImplementationBegin(haveKerning, (NSArray *expectedIndices)) {
    BOOL actualIsNil = (actual == nil);
    BOOL expectedIsNil = (expectedIndices == nil);

    prerequisite(^BOOL {
        return !(actualIsNil || expectedIsNil);
        // Return `NO` if matcher should fail whether or not the result is inverted
        // using `.Not`.
    });

    match(^BOOL {
        for (NSNumber *n in expectedIndices) {
            NSUInteger i = [n unsignedIntegerValue];
            NSDictionary *attributes = [actual attributesAtIndex:i effectiveRange:nil];
            NSNumber *v = [attributes objectForKey:NSKernAttributeName];
            if ([v floatValue] <= 0) {
                return NO;
            }
        }
        return YES;
    });

    failureMessageForTo(^NSString * {
        if (actualIsNil)
            return @"the actual value is nil/null";
        if (expectedIsNil)
            return @"the expected value is nil/null";
        return [NSString
                stringWithFormat:@"expected: %@"
                "got: an instance of %@ with non-matching kerning",
                expectedIndices, [actual class]];
        // Return the message to be displayed when the match function returns `YES`.
    });

    failureMessageForNotTo(^NSString * {
        return @"fail";
//        if (actualIsNil)
//            return @"the actual value is nil/null";
//        if (expectedIsNil)
//            return @"the expected value is nil/null";
//        return [NSString
//                stringWithFormat:@"expected: not a kind of %@, "
//                "got: an instance of %@, which is a kind of %@",
//                [expected class], [actual class], [expected class]];
//        // Return the message to be displayed when the match function returns `NO`.
    });
}
EXPMatcherImplementationEnd
