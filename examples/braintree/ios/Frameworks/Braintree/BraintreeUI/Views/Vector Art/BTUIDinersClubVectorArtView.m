#import "BTUIDinersClubVectorArtView.h"

@implementation BTUIDinersClubVectorArtView

- (void)drawArt {
    //// Color Declarations
    UIColor* color1 = [UIColor colorWithRed: 0.019 green: 0.213 blue: 0.52 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];

    //// Page-1
    {
        //// Diners-Club
        {
            //// Shape
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(46, 44)];
                [bezierPath addCurveToPoint: CGPointMake(64, 28) controlPoint1: CGPointMake(55.5, 44.04) controlPoint2: CGPointMake(64, 36.64)];
                [bezierPath addCurveToPoint: CGPointMake(46, 11) controlPoint1: CGPointMake(64, 17.8) controlPoint2: CGPointMake(55.5, 11)];
                [bezierPath addLineToPoint: CGPointMake(38, 11)];
                [bezierPath addCurveToPoint: CGPointMake(21, 28) controlPoint1: CGPointMake(28.76, 11) controlPoint2: CGPointMake(21, 17.8)];
                [bezierPath addCurveToPoint: CGPointMake(38, 44) controlPoint1: CGPointMake(21, 36.65) controlPoint2: CGPointMake(28.76, 44.04)];
                [bezierPath addLineToPoint: CGPointMake(46, 44)];
                [bezierPath addLineToPoint: CGPointMake(46, 44)];
                [bezierPath addLineToPoint: CGPointMake(46, 44)];
                [bezierPath addLineToPoint: CGPointMake(46, 44)];
                [bezierPath closePath];
                bezierPath.miterLimit = 4;

                bezierPath.usesEvenOddFillRule = YES;

                [color1 setFill];
                [bezierPath fill];


                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                [bezier2Path moveToPoint: CGPointMake(40.6, 36.8)];
                [bezier2Path addLineToPoint: CGPointMake(40.6, 18.2)];
                [bezier2Path addCurveToPoint: CGPointMake(46.8, 27.5) controlPoint1: CGPointMake(44.22, 19.63) controlPoint2: CGPointMake(46.79, 23.25)];
                [bezier2Path addCurveToPoint: CGPointMake(40.6, 36.8) controlPoint1: CGPointMake(46.79, 31.75) controlPoint2: CGPointMake(44.22, 35.36)];
                [bezier2Path closePath];
                [bezier2Path moveToPoint: CGPointMake(27.17, 27.5)];
                [bezier2Path addCurveToPoint: CGPointMake(33.37, 18.2) controlPoint1: CGPointMake(27.18, 23.26) controlPoint2: CGPointMake(29.74, 19.64)];
                [bezier2Path addLineToPoint: CGPointMake(33.37, 36.8)];
                [bezier2Path addCurveToPoint: CGPointMake(27.17, 27.5) controlPoint1: CGPointMake(29.74, 35.36) controlPoint2: CGPointMake(27.18, 31.75)];
                [bezier2Path closePath];
                [bezier2Path moveToPoint: CGPointMake(37.5, 12)];
                [bezier2Path addCurveToPoint: CGPointMake(22, 27.5) controlPoint1: CGPointMake(28.94, 12) controlPoint2: CGPointMake(22, 18.94)];
                [bezier2Path addCurveToPoint: CGPointMake(37.5, 43) controlPoint1: CGPointMake(22, 36.06) controlPoint2: CGPointMake(28.94, 43)];
                [bezier2Path addCurveToPoint: CGPointMake(53, 27.5) controlPoint1: CGPointMake(46.06, 43) controlPoint2: CGPointMake(53, 36.06)];
                [bezier2Path addCurveToPoint: CGPointMake(37.5, 12) controlPoint1: CGPointMake(53, 18.94) controlPoint2: CGPointMake(46.06, 12)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;
                
                bezier2Path.usesEvenOddFillRule = YES;
                
                [color2 setFill];
                [bezier2Path fill];
            }
        }
    }
}

@end
