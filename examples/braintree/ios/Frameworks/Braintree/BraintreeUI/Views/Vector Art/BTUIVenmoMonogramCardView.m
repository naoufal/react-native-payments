#import "BTUIVenmoMonogramCardView.h"

@implementation BTUIVenmoMonogramCardView

- (void)drawArt {
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.201 green: 0.463 blue: 0.682 alpha: 1];
    
    //// Page-1
    {
        //// Artboard-1
        {
            //// Fill-1 Drawing
            UIBezierPath* fill1Path = [UIBezierPath bezierPath];
            [fill1Path moveToPoint: CGPointMake(59.25, 9)];
            [fill1Path addCurveToPoint: CGPointMake(61.25, 16.65) controlPoint1: CGPointMake(60.63, 11.3) controlPoint2: CGPointMake(61.25, 13.66)];
            [fill1Path addCurveToPoint: CGPointMake(46.66, 47.26) controlPoint1: CGPointMake(61.25, 26.18) controlPoint2: CGPointMake(53.2, 38.57)];
            [fill1Path addLineToPoint: CGPointMake(31.74, 47.26)];
            [fill1Path addLineToPoint: CGPointMake(25.75, 11.09)];
            [fill1Path addLineToPoint: CGPointMake(38.82, 9.83)];
            [fill1Path addLineToPoint: CGPointMake(41.98, 35.57)];
            [fill1Path addCurveToPoint: CGPointMake(48.59, 17.84) controlPoint1: CGPointMake(44.94, 30.7) controlPoint2: CGPointMake(48.59, 23.05)];
            [fill1Path addCurveToPoint: CGPointMake(47.35, 11.43) controlPoint1: CGPointMake(48.59, 14.98) controlPoint2: CGPointMake(48.11, 13.04)];
            [fill1Path addLineToPoint: CGPointMake(59.25, 9)];
            [fill1Path closePath];
            fill1Path.miterLimit = 4;
            
            fill1Path.usesEvenOddFillRule = YES;
            
            [fillColor setFill];
            [fill1Path fill];
        }
    }
}

@end
