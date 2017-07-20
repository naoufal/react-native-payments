#import "UIColor+BTUI.h"

@implementation UIColor (BTUI)

+ (instancetype)bt_colorWithBytesR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(NSInteger)a {
    return [[self class] colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}

+ (instancetype)bt_colorWithBytesR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b {
    return [[self class] bt_colorWithBytesR:r G:g B:b A:255.0f];
}

- (instancetype)bt_adjustedBrightness:(CGFloat)adjustment {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        CGFloat newB = MAX(0.0f, MIN(1.0f, adjustment * b));
        return [[self class] colorWithHue:h saturation:s brightness:newB alpha:a];
    } else {
        return nil;
    }
}

+ (instancetype)bt_colorFromHex:(NSString *)hex alpha:(CGFloat)alpha {
    uint value = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&value];
    return [UIColor colorWithRed:((value >> 16) & 255) / 255.0f
                           green:((value >> 8) & 255) / 255.0f
                            blue:(value & 255) / 255.0f
                           alpha:alpha];
}

@end
