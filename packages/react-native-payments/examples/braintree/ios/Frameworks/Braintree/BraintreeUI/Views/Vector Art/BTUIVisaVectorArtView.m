#import "BTUIVisaVectorArtView.h"

@implementation BTUIVisaVectorArtView

- (void)drawArt {
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.914 green: 0.555 blue: 0.193 alpha: 1];
    UIColor* color1 = [UIColor colorWithRed: 0.033 green: 0.277 blue: 0.542 alpha: 1];

    //// Page-1
    {
        //// Visa
        {
            //// Group 3
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(37.45, 38.09)];
                [bezierPath addLineToPoint: CGPointMake(32.1, 38.09)];
                [bezierPath addLineToPoint: CGPointMake(35.45, 17)];
                [bezierPath addLineToPoint: CGPointMake(40.8, 17)];
                [bezierPath addLineToPoint: CGPointMake(37.45, 38.09)];
                [bezierPath closePath];
                bezierPath.miterLimit = 4;

                bezierPath.usesEvenOddFillRule = YES;

                [color1 setFill];
                [bezierPath fill];


                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                [bezier2Path moveToPoint: CGPointMake(27.58, 17)];
                [bezier2Path addLineToPoint: CGPointMake(22.48, 31.5)];
                [bezier2Path addLineToPoint: CGPointMake(21.88, 28.38)];
                [bezier2Path addLineToPoint: CGPointMake(21.88, 28.38)];
                [bezier2Path addLineToPoint: CGPointMake(20.07, 18.9)];
                [bezier2Path addCurveToPoint: CGPointMake(17.53, 17) controlPoint1: CGPointMake(20.07, 18.9) controlPoint2: CGPointMake(19.86, 17)];
                [bezier2Path addLineToPoint: CGPointMake(9.1, 17)];
                [bezier2Path addLineToPoint: CGPointMake(9, 17.36)];
                [bezier2Path addCurveToPoint: CGPointMake(14.6, 19.77) controlPoint1: CGPointMake(9, 17.36) controlPoint2: CGPointMake(11.58, 17.91)];
                [bezier2Path addLineToPoint: CGPointMake(19.25, 38.09)];
                [bezier2Path addLineToPoint: CGPointMake(24.83, 38.09)];
                [bezier2Path addLineToPoint: CGPointMake(33.34, 17)];
                [bezier2Path addLineToPoint: CGPointMake(27.58, 17)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;

                bezier2Path.usesEvenOddFillRule = YES;

                [color1 setFill];
                [bezier2Path fill];


                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
                [bezier3Path moveToPoint: CGPointMake(63.99, 30.63)];
                [bezier3Path addLineToPoint: CGPointMake(66.8, 22.74)];
                [bezier3Path addLineToPoint: CGPointMake(68.38, 30.63)];
                [bezier3Path addLineToPoint: CGPointMake(63.99, 30.63)];
                [bezier3Path addLineToPoint: CGPointMake(63.99, 30.63)];
                [bezier3Path addLineToPoint: CGPointMake(63.99, 30.63)];
                [bezier3Path addLineToPoint: CGPointMake(63.99, 30.63)];
                [bezier3Path closePath];
                [bezier3Path moveToPoint: CGPointMake(69.88, 38.09)];
                [bezier3Path addLineToPoint: CGPointMake(74.79, 38.09)];
                [bezier3Path addLineToPoint: CGPointMake(70.51, 17)];
                [bezier3Path addLineToPoint: CGPointMake(66.2, 17)];
                [bezier3Path addCurveToPoint: CGPointMake(63.73, 18.57) controlPoint1: CGPointMake(64.22, 17) controlPoint2: CGPointMake(63.73, 18.57)];
                [bezier3Path addLineToPoint: CGPointMake(55.75, 38.09)];
                [bezier3Path addLineToPoint: CGPointMake(61.33, 38.09)];
                [bezier3Path addLineToPoint: CGPointMake(62.45, 34.96)];
                [bezier3Path addLineToPoint: CGPointMake(69.25, 34.96)];
                [bezier3Path addLineToPoint: CGPointMake(69.88, 38.09)];
                [bezier3Path addLineToPoint: CGPointMake(69.88, 38.09)];
                [bezier3Path closePath];
                bezier3Path.miterLimit = 4;

                bezier3Path.usesEvenOddFillRule = YES;

                [color1 setFill];
                [bezier3Path fill];


                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
                [bezier4Path moveToPoint: CGPointMake(56.14, 22.45)];
                [bezier4Path addLineToPoint: CGPointMake(56.9, 17.92)];
                [bezier4Path addCurveToPoint: CGPointMake(52.09, 17) controlPoint1: CGPointMake(56.9, 17.92) controlPoint2: CGPointMake(54.55, 17)];
                [bezier4Path addCurveToPoint: CGPointMake(43.12, 23.98) controlPoint1: CGPointMake(49.43, 17) controlPoint2: CGPointMake(43.12, 18.19)];
                [bezier4Path addCurveToPoint: CGPointMake(50.53, 32.36) controlPoint1: CGPointMake(43.12, 29.43) controlPoint2: CGPointMake(50.53, 29.5)];
                [bezier4Path addCurveToPoint: CGPointMake(41.7, 32.9) controlPoint1: CGPointMake(50.53, 35.22) controlPoint2: CGPointMake(43.89, 34.71)];
                [bezier4Path addLineToPoint: CGPointMake(40.9, 37.64)];
                [bezier4Path addCurveToPoint: CGPointMake(46.94, 38.83) controlPoint1: CGPointMake(40.9, 37.64) controlPoint2: CGPointMake(43.29, 38.83)];
                [bezier4Path addCurveToPoint: CGPointMake(56.11, 31.61) controlPoint1: CGPointMake(50.6, 38.83) controlPoint2: CGPointMake(56.11, 36.89)];
                [bezier4Path addCurveToPoint: CGPointMake(48.64, 23.23) controlPoint1: CGPointMake(56.11, 26.13) controlPoint2: CGPointMake(48.64, 25.62)];
                [bezier4Path addCurveToPoint: CGPointMake(56.14, 22.45) controlPoint1: CGPointMake(48.64, 20.85) controlPoint2: CGPointMake(53.85, 21.15)];
                [bezier4Path closePath];
                bezier4Path.miterLimit = 4;

                bezier4Path.usesEvenOddFillRule = YES;

                [color1 setFill];
                [bezier4Path fill];


                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
                [bezier5Path moveToPoint: CGPointMake(21.88, 28.38)];
                [bezier5Path addLineToPoint: CGPointMake(20.07, 18.9)];
                [bezier5Path addCurveToPoint: CGPointMake(17.53, 17) controlPoint1: CGPointMake(20.07, 18.9) controlPoint2: CGPointMake(19.86, 17)];
                [bezier5Path addLineToPoint: CGPointMake(9.1, 17)];
                [bezier5Path addLineToPoint: CGPointMake(9, 17.36)];
                [bezier5Path addCurveToPoint: CGPointMake(16.95, 21.45) controlPoint1: CGPointMake(9, 17.36) controlPoint2: CGPointMake(13.06, 18.22)];
                [bezier5Path addCurveToPoint: CGPointMake(21.88, 28.38) controlPoint1: CGPointMake(20.66, 24.53) controlPoint2: CGPointMake(21.88, 28.38)];
                [bezier5Path closePath];
                bezier5Path.miterLimit = 4;
                
                bezier5Path.usesEvenOddFillRule = YES;
                
                [color2 setFill];
                [bezier5Path fill];
            }
        }
    }
}
@end
