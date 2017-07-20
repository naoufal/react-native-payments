#import "BTUIDiscoverVectorArtView.h"

@implementation BTUIDiscoverVectorArtView

- (void)drawArt {
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.879 green: 0.425 blue: 0.167 alpha: 1];
    UIColor* color1 = [UIColor colorWithRed: 0.042 green: 0.053 blue: 0.066 alpha: 1];

    //// Page-1
    {
        //// Discover
        {
            //// Group 4
            {
                //// Group 5
                {
                    //// Bezier Drawing
                    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                    [bezierPath moveToPoint: CGPointMake(13.13, 22)];
                    [bezierPath addLineToPoint: CGPointMake(10, 22)];
                    [bezierPath addLineToPoint: CGPointMake(10, 33)];
                    [bezierPath addLineToPoint: CGPointMake(13.12, 33)];
                    [bezierPath addCurveToPoint: CGPointMake(17.02, 31.73) controlPoint1: CGPointMake(14.77, 33) controlPoint2: CGPointMake(15.97, 32.61)];
                    [bezierPath addCurveToPoint: CGPointMake(19, 27.51) controlPoint1: CGPointMake(18.26, 30.69) controlPoint2: CGPointMake(19, 29.12)];
                    [bezierPath addCurveToPoint: CGPointMake(13.13, 22) controlPoint1: CGPointMake(19, 24.26) controlPoint2: CGPointMake(16.59, 22)];
                    [bezierPath addLineToPoint: CGPointMake(13.13, 22)];
                    [bezierPath addLineToPoint: CGPointMake(13.13, 22)];
                    [bezierPath addLineToPoint: CGPointMake(13.13, 22)];
                    [bezierPath closePath];
                    [bezierPath moveToPoint: CGPointMake(15.74, 30.16)];
                    [bezierPath addCurveToPoint: CGPointMake(12.61, 31) controlPoint1: CGPointMake(15.02, 30.75) controlPoint2: CGPointMake(14.09, 31)];
                    [bezierPath addLineToPoint: CGPointMake(12, 31)];
                    [bezierPath addLineToPoint: CGPointMake(12, 24)];
                    [bezierPath addLineToPoint: CGPointMake(12.61, 24)];
                    [bezierPath addCurveToPoint: CGPointMake(15.74, 24.86) controlPoint1: CGPointMake(14.09, 24) controlPoint2: CGPointMake(14.98, 24.24)];
                    [bezierPath addCurveToPoint: CGPointMake(17, 27.49) controlPoint1: CGPointMake(16.53, 25.49) controlPoint2: CGPointMake(17, 26.47)];
                    [bezierPath addCurveToPoint: CGPointMake(15.74, 30.16) controlPoint1: CGPointMake(17, 28.51) controlPoint2: CGPointMake(16.53, 29.52)];
                    [bezierPath addLineToPoint: CGPointMake(15.74, 30.16)];
                    [bezierPath closePath];
                    bezierPath.miterLimit = 4;

                    bezierPath.usesEvenOddFillRule = YES;

                    [color1 setFill];
                    [bezierPath fill];


                    //// Bezier 2 Drawing
                    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                    [bezier2Path moveToPoint: CGPointMake(20, 22)];
                    [bezier2Path addLineToPoint: CGPointMake(22, 22)];
                    [bezier2Path addLineToPoint: CGPointMake(22, 33)];
                    [bezier2Path addLineToPoint: CGPointMake(20, 33)];
                    [bezier2Path addLineToPoint: CGPointMake(20, 33)];
                    [bezier2Path addLineToPoint: CGPointMake(20, 22)];
                    [bezier2Path addLineToPoint: CGPointMake(20, 22)];
                    [bezier2Path closePath];
                    bezier2Path.miterLimit = 4;

                    bezier2Path.usesEvenOddFillRule = YES;

                    [color1 setFill];
                    [bezier2Path fill];


                    //// Bezier 3 Drawing
                    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
                    [bezier3Path moveToPoint: CGPointMake(27.09, 26.23)];
                    [bezier3Path addCurveToPoint: CGPointMake(25.55, 24.9) controlPoint1: CGPointMake(25.9, 25.77) controlPoint2: CGPointMake(25.55, 25.47)];
                    [bezier3Path addCurveToPoint: CGPointMake(27.02, 23.73) controlPoint1: CGPointMake(25.55, 24.23) controlPoint2: CGPointMake(26.17, 23.73)];
                    [bezier3Path addCurveToPoint: CGPointMake(28.62, 24.58) controlPoint1: CGPointMake(27.62, 23.73) controlPoint2: CGPointMake(28.1, 23.98)];
                    [bezier3Path addLineToPoint: CGPointMake(29.65, 23.17)];
                    [bezier3Path addCurveToPoint: CGPointMake(26.67, 22) controlPoint1: CGPointMake(28.8, 22.4) controlPoint2: CGPointMake(27.78, 22)];
                    [bezier3Path addCurveToPoint: CGPointMake(23.52, 25.03) controlPoint1: CGPointMake(24.88, 22) controlPoint2: CGPointMake(23.52, 23.3)];
                    [bezier3Path addCurveToPoint: CGPointMake(26.01, 27.93) controlPoint1: CGPointMake(23.52, 26.48) controlPoint2: CGPointMake(24.15, 27.23)];
                    [bezier3Path addCurveToPoint: CGPointMake(27.37, 28.53) controlPoint1: CGPointMake(26.78, 28.21) controlPoint2: CGPointMake(27.17, 28.4)];
                    [bezier3Path addCurveToPoint: CGPointMake(27.97, 29.62) controlPoint1: CGPointMake(27.77, 28.8) controlPoint2: CGPointMake(27.97, 29.18)];
                    [bezier3Path addCurveToPoint: CGPointMake(26.43, 31.11) controlPoint1: CGPointMake(27.97, 30.48) controlPoint2: CGPointMake(27.31, 31.11)];
                    [bezier3Path addCurveToPoint: CGPointMake(24.27, 29.7) controlPoint1: CGPointMake(25.49, 31.11) controlPoint2: CGPointMake(24.73, 30.62)];
                    [bezier3Path addLineToPoint: CGPointMake(23, 30.99)];
                    [bezier3Path addCurveToPoint: CGPointMake(26.51, 33) controlPoint1: CGPointMake(23.91, 32.38) controlPoint2: CGPointMake(25, 33)];
                    [bezier3Path addCurveToPoint: CGPointMake(30, 29.53) controlPoint1: CGPointMake(28.56, 33) controlPoint2: CGPointMake(30, 31.57)];
                    [bezier3Path addCurveToPoint: CGPointMake(27.09, 26.23) controlPoint1: CGPointMake(30, 27.85) controlPoint2: CGPointMake(29.33, 27.09)];
                    [bezier3Path closePath];
                    bezier3Path.miterLimit = 4;

                    bezier3Path.usesEvenOddFillRule = YES;

                    [color1 setFill];
                    [bezier3Path fill];


                    //// Bezier 4 Drawing
                    UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
                    [bezier4Path moveToPoint: CGPointMake(31, 27.51)];
                    [bezier4Path addCurveToPoint: CGPointMake(36.47, 33) controlPoint1: CGPointMake(31, 30.6) controlPoint2: CGPointMake(33.39, 33)];
                    [bezier4Path addCurveToPoint: CGPointMake(39, 32.39) controlPoint1: CGPointMake(37.34, 33) controlPoint2: CGPointMake(38.08, 32.83)];
                    [bezier4Path addLineToPoint: CGPointMake(39, 29.97)];
                    [bezier4Path addCurveToPoint: CGPointMake(36.56, 31.12) controlPoint1: CGPointMake(38.19, 30.79) controlPoint2: CGPointMake(37.48, 31.12)];
                    [bezier4Path addCurveToPoint: CGPointMake(33.08, 27.49) controlPoint1: CGPointMake(34.53, 31.12) controlPoint2: CGPointMake(33.08, 29.62)];
                    [bezier4Path addCurveToPoint: CGPointMake(36.47, 23.88) controlPoint1: CGPointMake(33.08, 25.47) controlPoint2: CGPointMake(34.57, 23.88)];
                    [bezier4Path addCurveToPoint: CGPointMake(39, 25.06) controlPoint1: CGPointMake(37.43, 23.88) controlPoint2: CGPointMake(38.16, 24.22)];
                    [bezier4Path addLineToPoint: CGPointMake(39, 22.64)];
                    [bezier4Path addCurveToPoint: CGPointMake(36.51, 22) controlPoint1: CGPointMake(38.11, 22.19) controlPoint2: CGPointMake(37.38, 22)];
                    [bezier4Path addCurveToPoint: CGPointMake(31, 27.51) controlPoint1: CGPointMake(33.45, 22) controlPoint2: CGPointMake(31, 24.45)];
                    [bezier4Path closePath];
                    bezier4Path.miterLimit = 4;

                    bezier4Path.usesEvenOddFillRule = YES;

                    [color1 setFill];
                    [bezier4Path fill];


                    //// Bezier 5 Drawing
                    UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
                    [bezier5Path moveToPoint: CGPointMake(55.99, 29.2)];
                    [bezier5Path addLineToPoint: CGPointMake(53.22, 22)];
                    [bezier5Path addLineToPoint: CGPointMake(51, 22)];
                    [bezier5Path addLineToPoint: CGPointMake(55.42, 33)];
                    [bezier5Path addLineToPoint: CGPointMake(56.51, 33)];
                    [bezier5Path addLineToPoint: CGPointMake(61, 22)];
                    [bezier5Path addLineToPoint: CGPointMake(58.8, 22)];
                    [bezier5Path addLineToPoint: CGPointMake(55.99, 29.2)];
                    [bezier5Path closePath];
                    bezier5Path.miterLimit = 4;

                    bezier5Path.usesEvenOddFillRule = YES;

                    [color1 setFill];
                    [bezier5Path fill];


                    //// Bezier 6 Drawing
                    UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
                    [bezier6Path moveToPoint: CGPointMake(62, 33)];
                    [bezier6Path addLineToPoint: CGPointMake(68, 33)];
                    [bezier6Path addLineToPoint: CGPointMake(68, 31.14)];
                    [bezier6Path addLineToPoint: CGPointMake(64.11, 31.14)];
                    [bezier6Path addLineToPoint: CGPointMake(64.11, 28.17)];
                    [bezier6Path addLineToPoint: CGPointMake(67.85, 28.17)];
                    [bezier6Path addLineToPoint: CGPointMake(67.85, 26.3)];
                    [bezier6Path addLineToPoint: CGPointMake(64.11, 26.3)];
                    [bezier6Path addLineToPoint: CGPointMake(64.11, 23.86)];
                    [bezier6Path addLineToPoint: CGPointMake(68, 23.86)];
                    [bezier6Path addLineToPoint: CGPointMake(68, 22)];
                    [bezier6Path addLineToPoint: CGPointMake(62, 22)];
                    [bezier6Path addLineToPoint: CGPointMake(62, 33)];
                    [bezier6Path closePath];
                    bezier6Path.miterLimit = 4;

                    bezier6Path.usesEvenOddFillRule = YES;

                    [color1 setFill];
                    [bezier6Path fill];


                    //// Bezier 7 Drawing
                    UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
                    [bezier7Path moveToPoint: CGPointMake(77.05, 25.25)];
                    [bezier7Path addCurveToPoint: CGPointMake(73.17, 22) controlPoint1: CGPointMake(77.05, 23.19) controlPoint2: CGPointMake(75.64, 22)];
                    [bezier7Path addLineToPoint: CGPointMake(70, 22)];
                    [bezier7Path addLineToPoint: CGPointMake(70, 33)];
                    [bezier7Path addLineToPoint: CGPointMake(72.14, 33)];
                    [bezier7Path addLineToPoint: CGPointMake(72.14, 28.58)];
                    [bezier7Path addLineToPoint: CGPointMake(72.42, 28.58)];
                    [bezier7Path addLineToPoint: CGPointMake(75.37, 33)];
                    [bezier7Path addLineToPoint: CGPointMake(78, 33)];
                    [bezier7Path addLineToPoint: CGPointMake(74.55, 28.37)];
                    [bezier7Path addCurveToPoint: CGPointMake(77.05, 25.25) controlPoint1: CGPointMake(76.16, 28.04) controlPoint2: CGPointMake(77.05, 26.93)];
                    [bezier7Path addCurveToPoint: CGPointMake(77.05, 25.25) controlPoint1: CGPointMake(77.05, 25.25) controlPoint2: CGPointMake(77.05, 26.93)];
                    [bezier7Path addLineToPoint: CGPointMake(77.05, 25.25)];
                    [bezier7Path addLineToPoint: CGPointMake(77.05, 25.25)];
                    [bezier7Path closePath];
                    [bezier7Path moveToPoint: CGPointMake(72.69, 27)];
                    [bezier7Path addLineToPoint: CGPointMake(72, 27)];
                    [bezier7Path addLineToPoint: CGPointMake(72, 24)];
                    [bezier7Path addLineToPoint: CGPointMake(72.73, 24)];
                    [bezier7Path addCurveToPoint: CGPointMake(75, 25.47) controlPoint1: CGPointMake(74.2, 24) controlPoint2: CGPointMake(75, 24.51)];
                    [bezier7Path addCurveToPoint: CGPointMake(72.69, 27) controlPoint1: CGPointMake(75, 26.46) controlPoint2: CGPointMake(74.2, 27)];
                    [bezier7Path addLineToPoint: CGPointMake(72.69, 27)];
                    [bezier7Path closePath];
                    bezier7Path.miterLimit = 4;

                    bezier7Path.usesEvenOddFillRule = YES;

                    [color1 setFill];
                    [bezier7Path fill];


                    //// Bezier 8 Drawing
                    UIBezierPath* bezier8Path = [UIBezierPath bezierPath];
                    [bezier8Path moveToPoint: CGPointMake(45.5, 33)];
                    [bezier8Path addCurveToPoint: CGPointMake(51, 27.5) controlPoint1: CGPointMake(48.54, 33) controlPoint2: CGPointMake(51, 30.54)];
                    [bezier8Path addCurveToPoint: CGPointMake(45.5, 22) controlPoint1: CGPointMake(51, 24.46) controlPoint2: CGPointMake(48.54, 22)];
                    [bezier8Path addCurveToPoint: CGPointMake(40, 27.5) controlPoint1: CGPointMake(42.46, 22) controlPoint2: CGPointMake(40, 24.46)];
                    [bezier8Path addCurveToPoint: CGPointMake(45.5, 33) controlPoint1: CGPointMake(40, 30.54) controlPoint2: CGPointMake(42.46, 33)];
                    [bezier8Path closePath];
                    bezier8Path.miterLimit = 4;

                    bezier8Path.usesEvenOddFillRule = YES;

                    [color2 setFill];
                    [bezier8Path fill];
                }
            }
        }
    }


}
@end
