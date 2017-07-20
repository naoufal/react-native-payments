#import "BTUIJCBVectorArtView.h"

@implementation BTUIJCBVectorArtView

- (void)drawArt {
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor* color1 = [UIColor colorWithRed: 0.262 green: 0.646 blue: 0.146 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.279 green: 0.659 blue: 0.143 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 0.041 green: 0.33 blue: 0.659 alpha: 1];
    UIColor* color4 = [UIColor colorWithRed: 0.041 green: 0.341 blue: 0.673 alpha: 1];
    UIColor* color5 = [UIColor colorWithRed: 0.833 green: 0 blue: 0.166 alpha: 1];
    UIColor* color6 = [UIColor colorWithRed: 0.852 green: 0 blue: 0.169 alpha: 1];

    //// Gradient Declarations
    NSArray* linearGradient3Colors = [NSArray arrayWithObjects:
                                      (id)color5.CGColor,
                                      (id)color6.CGColor, nil];
    CGFloat linearGradient3Locations[] = {0, 1};
    CGGradientRef linearGradient3 = CGGradientCreateWithColors(colorSpace, (CFArrayRef)linearGradient3Colors, linearGradient3Locations);
    NSArray* linearGradient1Colors = [NSArray arrayWithObjects:
                                      (id)color1.CGColor,
                                      (id)color2.CGColor, nil];
    CGFloat linearGradient1Locations[] = {0, 1};
    CGGradientRef linearGradient1 = CGGradientCreateWithColors(colorSpace, (CFArrayRef)linearGradient1Colors, linearGradient1Locations);
    NSArray* linearGradient2Colors = [NSArray arrayWithObjects:
                                      (id)color3.CGColor,
                                      (id)color4.CGColor, nil];
    CGFloat linearGradient2Locations[] = {0, 1};
    CGGradientRef linearGradient2 = CGGradientCreateWithColors(colorSpace, (CFArrayRef)linearGradient2Colors, linearGradient2Locations);



    //// Page-1
    {
        //// JCB
        {
            //// Bezier Drawing
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(55.66, 28.16)];
            [bezierPath addCurveToPoint: CGPointMake(58.73, 28.16) controlPoint1: CGPointMake(56.68, 28.16) controlPoint2: CGPointMake(57.71, 28.16)];
            [bezierPath addCurveToPoint: CGPointMake(59.1, 28.16) controlPoint1: CGPointMake(58.82, 28.16) controlPoint2: CGPointMake(59.01, 28.16)];
            [bezierPath addLineToPoint: CGPointMake(59.1, 28.16)];
            [bezierPath addCurveToPoint: CGPointMake(59.1, 31.02) controlPoint1: CGPointMake(60.5, 28.45) controlPoint2: CGPointMake(60.5, 30.63)];
            [bezierPath addLineToPoint: CGPointMake(59.1, 31.02)];
            [bezierPath addCurveToPoint: CGPointMake(58.73, 31.02) controlPoint1: CGPointMake(59.01, 31.02) controlPoint2: CGPointMake(58.92, 31.02)];
            [bezierPath addCurveToPoint: CGPointMake(55.66, 31.02) controlPoint1: CGPointMake(57.71, 31.02) controlPoint2: CGPointMake(56.68, 31.02)];
            [bezierPath addLineToPoint: CGPointMake(55.66, 28.16)];
            [bezierPath addLineToPoint: CGPointMake(55.66, 28.16)];
            [bezierPath addLineToPoint: CGPointMake(55.66, 28.16)];
            [bezierPath addLineToPoint: CGPointMake(55.66, 28.16)];
            [bezierPath closePath];
            [bezierPath moveToPoint: CGPointMake(59.75, 24.79)];
            [bezierPath addCurveToPoint: CGPointMake(58.73, 26.47) controlPoint1: CGPointMake(59.94, 25.58) controlPoint2: CGPointMake(59.47, 26.28)];
            [bezierPath addCurveToPoint: CGPointMake(58.45, 26.47) controlPoint1: CGPointMake(58.64, 26.47) controlPoint2: CGPointMake(58.54, 26.47)];
            [bezierPath addCurveToPoint: CGPointMake(55.66, 26.47) controlPoint1: CGPointMake(57.52, 26.47) controlPoint2: CGPointMake(56.59, 26.47)];
            [bezierPath addLineToPoint: CGPointMake(55.66, 23.8)];
            [bezierPath addCurveToPoint: CGPointMake(58.45, 23.8) controlPoint1: CGPointMake(56.59, 23.8) controlPoint2: CGPointMake(57.52, 23.8)];
            [bezierPath addLineToPoint: CGPointMake(58.45, 23.8)];
            [bezierPath addCurveToPoint: CGPointMake(58.73, 23.8) controlPoint1: CGPointMake(58.54, 23.8) controlPoint2: CGPointMake(58.64, 23.8)];
            [bezierPath addLineToPoint: CGPointMake(58.73, 23.8)];
            [bezierPath addCurveToPoint: CGPointMake(59.75, 24.79) controlPoint1: CGPointMake(59.19, 23.9) controlPoint2: CGPointMake(59.66, 24.3)];
            [bezierPath addLineToPoint: CGPointMake(59.75, 24.79)];
            [bezierPath addLineToPoint: CGPointMake(59.75, 24.79)];
            [bezierPath addLineToPoint: CGPointMake(59.75, 24.79)];
            [bezierPath closePath];
            [bezierPath moveToPoint: CGPointMake(66.54, 38.54)];
            [bezierPath addCurveToPoint: CGPointMake(61.98, 43.89) controlPoint1: CGPointMake(66.54, 41.12) controlPoint2: CGPointMake(64.31, 43.29)];
            [bezierPath addCurveToPoint: CGPointMake(52.59, 43.99) controlPoint1: CGPointMake(60.87, 44.18) controlPoint2: CGPointMake(52.59, 43.99)];
            [bezierPath addLineToPoint: CGPointMake(52.59, 33.1)];
            [bezierPath addCurveToPoint: CGPointMake(58.82, 33.1) controlPoint1: CGPointMake(52.59, 33.1) controlPoint2: CGPointMake(56.87, 33.1)];
            [bezierPath addCurveToPoint: CGPointMake(64.49, 30.93) controlPoint1: CGPointMake(60.68, 33.1) controlPoint2: CGPointMake(63.66, 33.2)];
            [bezierPath addCurveToPoint: CGPointMake(61.61, 27.36) controlPoint1: CGPointMake(65.24, 28.75) controlPoint2: CGPointMake(63.29, 27.46)];
            [bezierPath addLineToPoint: CGPointMake(61.61, 27.26)];
            [bezierPath addCurveToPoint: CGPointMake(63.84, 23.9) controlPoint1: CGPointMake(63.1, 27.07) controlPoint2: CGPointMake(64.49, 25.68)];
            [bezierPath addCurveToPoint: CGPointMake(61.15, 22.22) controlPoint1: CGPointMake(63.47, 22.71) controlPoint2: CGPointMake(62.26, 22.32)];
            [bezierPath addCurveToPoint: CGPointMake(52.5, 22.22) controlPoint1: CGPointMake(59.47, 22.02) controlPoint2: CGPointMake(52.5, 22.22)];
            [bezierPath addLineToPoint: CGPointMake(52.5, 16.48)];
            [bezierPath addCurveToPoint: CGPointMake(52.59, 15.39) controlPoint1: CGPointMake(52.5, 16.08) controlPoint2: CGPointMake(52.5, 15.69)];
            [bezierPath addCurveToPoint: CGPointMake(57.99, 10.54) controlPoint1: CGPointMake(53.06, 12.92) controlPoint2: CGPointMake(55.66, 10.64)];
            [bezierPath addCurveToPoint: CGPointMake(66.35, 10.54) controlPoint1: CGPointMake(59.66, 10.45) controlPoint2: CGPointMake(66.35, 10.54)];
            [bezierPath addLineToPoint: CGPointMake(66.54, 38.54)];
            [bezierPath closePath];
            bezierPath.miterLimit = 4;

            bezierPath.usesEvenOddFillRule = YES;

            CGContextSaveGState(context);
            [bezierPath addClip];
            CGContextDrawLinearGradient(context, linearGradient1,
                                        CGPointMake(52.5, 27.28),
                                        CGPointMake(66.54, 27.28),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);


            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
            [bezier2Path moveToPoint: CGPointMake(20.6, 30.23)];
            [bezier2Path addCurveToPoint: CGPointMake(20.5, 30.13) controlPoint1: CGPointMake(20.6, 30.23) controlPoint2: CGPointMake(20.5, 30.23)];
            [bezier2Path addLineToPoint: CGPointMake(20.5, 16.55)];
            [bezier2Path addCurveToPoint: CGPointMake(25.41, 10.54) controlPoint1: CGPointMake(20.5, 13.59) controlPoint2: CGPointMake(22.51, 10.74)];
            [bezier2Path addCurveToPoint: CGPointMake(34.54, 10.54) controlPoint1: CGPointMake(27.22, 10.45) controlPoint2: CGPointMake(34.54, 10.54)];
            [bezier2Path addLineToPoint: CGPointMake(34.54, 38.59)];
            [bezier2Path addCurveToPoint: CGPointMake(28.62, 44.01) controlPoint1: CGPointMake(34.54, 41.55) controlPoint2: CGPointMake(31.53, 43.91)];
            [bezier2Path addCurveToPoint: CGPointMake(20.5, 44.01) controlPoint1: CGPointMake(26.82, 44.1) controlPoint2: CGPointMake(20.5, 44.01)];
            [bezier2Path addLineToPoint: CGPointMake(20.5, 32.49)];
            [bezier2Path addCurveToPoint: CGPointMake(30.13, 32.59) controlPoint1: CGPointMake(23.61, 33.28) controlPoint2: CGPointMake(27.12, 33.67)];
            [bezier2Path addCurveToPoint: CGPointMake(32.53, 28.75) controlPoint1: CGPointMake(31.83, 31.9) controlPoint2: CGPointMake(32.53, 30.62)];
            [bezier2Path addLineToPoint: CGPointMake(32.53, 22.35)];
            [bezier2Path addCurveToPoint: CGPointMake(27.52, 22.35) controlPoint1: CGPointMake(30.93, 22.35) controlPoint2: CGPointMake(29.12, 22.35)];
            [bezier2Path addLineToPoint: CGPointMake(27.52, 28.75)];
            [bezier2Path addCurveToPoint: CGPointMake(22.41, 31.01) controlPoint1: CGPointMake(27.52, 32.1) controlPoint2: CGPointMake(24.51, 31.7)];
            [bezier2Path addCurveToPoint: CGPointMake(20.6, 30.23) controlPoint1: CGPointMake(21.8, 30.72) controlPoint2: CGPointMake(21.2, 30.42)];
            [bezier2Path addLineToPoint: CGPointMake(20.6, 30.23)];
            [bezier2Path addLineToPoint: CGPointMake(20.6, 30.23)];
            [bezier2Path addLineToPoint: CGPointMake(20.6, 30.23)];
            [bezier2Path addLineToPoint: CGPointMake(20.6, 30.23)];
            [bezier2Path closePath];
            bezier2Path.miterLimit = 4;

            bezier2Path.usesEvenOddFillRule = YES;

            CGContextSaveGState(context);
            [bezier2Path addClip];
            CGContextDrawLinearGradient(context, linearGradient2,
                                        CGPointMake(20.5, 27.28),
                                        CGPointMake(34.54, 27.28),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);

            //// Bezier 3 Drawing
            UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
            [bezier3Path moveToPoint: CGPointMake(36.5, 23.72)];
            [bezier3Path addLineToPoint: CGPointMake(36.5, 16.53)];
            [bezier3Path addCurveToPoint: CGPointMake(41.37, 10.62) controlPoint1: CGPointMake(36.5, 13.87) controlPoint2: CGPointMake(38.84, 11.12)];
            [bezier3Path addCurveToPoint: CGPointMake(50.54, 10.52) controlPoint1: CGPointMake(42.49, 10.43) controlPoint2: CGPointMake(50.54, 10.52)];
            [bezier3Path addLineToPoint: CGPointMake(50.54, 38.59)];
            [bezier3Path addCurveToPoint: CGPointMake(45.02, 44.01) controlPoint1: CGPointMake(50.54, 41.54) controlPoint2: CGPointMake(47.83, 43.81)];
            [bezier3Path addCurveToPoint: CGPointMake(36.5, 44.01) controlPoint1: CGPointMake(43.33, 44.1) controlPoint2: CGPointMake(36.5, 44.01)];
            [bezier3Path addLineToPoint: CGPointMake(36.5, 31.3)];
            [bezier3Path addCurveToPoint: CGPointMake(46.05, 32.88) controlPoint1: CGPointMake(38.84, 33.37) controlPoint2: CGPointMake(43.15, 33.27)];
            [bezier3Path addCurveToPoint: CGPointMake(48.57, 32.39) controlPoint1: CGPointMake(46.89, 32.78) controlPoint2: CGPointMake(47.73, 32.58)];
            [bezier3Path addLineToPoint: CGPointMake(48.57, 30.02)];
            [bezier3Path addCurveToPoint: CGPointMake(41.84, 30.81) controlPoint1: CGPointMake(46.61, 31.01) controlPoint2: CGPointMake(43.89, 31.89)];
            [bezier3Path addCurveToPoint: CGPointMake(39.96, 27.95) controlPoint1: CGPointMake(40.71, 30.22) controlPoint2: CGPointMake(40.06, 29.14)];
            [bezier3Path addCurveToPoint: CGPointMake(39.96, 26.97) controlPoint1: CGPointMake(39.96, 27.66) controlPoint2: CGPointMake(39.96, 27.36)];
            [bezier3Path addCurveToPoint: CGPointMake(46.7, 24.02) controlPoint1: CGPointMake(40.24, 23.33) controlPoint2: CGPointMake(44.18, 23.23)];
            [bezier3Path addCurveToPoint: CGPointMake(48.57, 24.8) controlPoint1: CGPointMake(47.36, 24.21) controlPoint2: CGPointMake(48.01, 24.51)];
            [bezier3Path addLineToPoint: CGPointMake(48.57, 22.44)];
            [bezier3Path addCurveToPoint: CGPointMake(39.5, 22.24) controlPoint1: CGPointMake(45.67, 21.75) controlPoint2: CGPointMake(42.49, 21.36)];
            [bezier3Path addCurveToPoint: CGPointMake(36.5, 23.72) controlPoint1: CGPointMake(38.65, 22.64) controlPoint2: CGPointMake(37.25, 23.03)];
            [bezier3Path closePath];
            bezier3Path.miterLimit = 4;
            
            bezier3Path.usesEvenOddFillRule = YES;

            CGContextSaveGState(context);
            [bezier3Path addClip];
            CGContextDrawLinearGradient(context, linearGradient3,
                                        CGPointMake(36.5, 27.28),
                                        CGPointMake(50.54, 27.28),
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
        }
    }
    
    //// Cleanup
    CGGradientRelease(linearGradient3);
    CGGradientRelease(linearGradient1);
    CGGradientRelease(linearGradient2);
    CGColorSpaceRelease(colorSpace);
}


@end
