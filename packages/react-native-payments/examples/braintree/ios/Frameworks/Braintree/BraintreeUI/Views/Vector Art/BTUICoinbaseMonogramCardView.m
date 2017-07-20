#import "BTUICoinbaseMonogramCardView.h"

@implementation BTUICoinbaseMonogramCardView

- (void)drawArt {
    //// Color Declarations
    UIColor* color1 = [UIColor colorWithRed: 0.053 green: 0.433 blue: 0.7 alpha: 1];

    //// Assets
    {
        //// icon-coinbase
        {
            //// Rectangle Drawing


            //// logo/coinbase-2
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(24, 27.45)];
                [bezierPath addCurveToPoint: CGPointMake(47.38, 0) controlPoint1: CGPointMake(24, 8.33) controlPoint2: CGPointMake(35.54, 0)];
                [bezierPath addCurveToPoint: CGPointMake(61, 3.63) controlPoint1: CGPointMake(53.21, 0) controlPoint2: CGPointMake(57.74, 1.47)];
                [bezierPath addLineToPoint: CGPointMake(57.45, 11.37)];
                [bezierPath addCurveToPoint: CGPointMake(48.77, 8.82) controlPoint1: CGPointMake(55.28, 9.8) controlPoint2: CGPointMake(52.02, 8.82)];
                [bezierPath addCurveToPoint: CGPointMake(34.57, 27.45) controlPoint1: CGPointMake(41.66, 8.82) controlPoint2: CGPointMake(34.57, 14.51)];
                [bezierPath addCurveToPoint: CGPointMake(48.77, 45.98) controlPoint1: CGPointMake(34.57, 40.39) controlPoint2: CGPointMake(41.86, 45.98)];
                [bezierPath addCurveToPoint: CGPointMake(57.45, 43.43) controlPoint1: CGPointMake(52.02, 45.98) controlPoint2: CGPointMake(55.28, 45)];
                [bezierPath addLineToPoint: CGPointMake(61, 51.37)];
                [bezierPath addCurveToPoint: CGPointMake(47.38, 55) controlPoint1: CGPointMake(57.65, 53.63) controlPoint2: CGPointMake(53.21, 55)];
                [bezierPath addCurveToPoint: CGPointMake(24, 27.45) controlPoint1: CGPointMake(35.54, 55) controlPoint2: CGPointMake(24, 46.57)];
                [bezierPath closePath];
                bezierPath.miterLimit = 4;

                bezierPath.usesEvenOddFillRule = YES;
                
                [color1 setFill];
                [bezierPath fill];
            }
        }
    }
}

@end
