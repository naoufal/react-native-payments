#import "BTUIUtil.h"

@implementation BTUIUtil

#pragma mark - Class Method Utils

+ (BOOL)luhnValid:(NSString *)cardNumber {
    // http://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#Objective-C
    const char *digitChars = [cardNumber UTF8String];
    BOOL isOdd = YES;
	NSInteger oddSum = 0;
	NSInteger evenSum = 0;
	for (NSInteger i = [cardNumber length] - 1; i >= 0; i--) {
		NSInteger digit = digitChars[i] - '0';
		if (isOdd) {
			oddSum += digit;
        } else {
			evenSum += digit/5 + (2*digit) % 10;
        }
		isOdd = !isOdd;
	}

	return ((oddSum + evenSum) % 10 == 0);
}

+ (NSString *)stripNonDigits:(NSString *)input {
    return [self stripPattern:@"[^0-9]" input:input];
}

+ (NSString *)stripNonExpiry:(NSString *)input {
    return [self stripPattern:@"[^0-9/]" input:input];
}

+ (NSString *)stripPattern:(NSString *)pattern input:(NSString *)input {
    if (!input) return nil;

    NSError *error;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                        options:0
                                                                          error:&error];

    return [re stringByReplacingMatchesInString:input
                                        options:0
                                          range:NSMakeRange(0, input.length)
                                   withTemplate:@""];
}

@end
