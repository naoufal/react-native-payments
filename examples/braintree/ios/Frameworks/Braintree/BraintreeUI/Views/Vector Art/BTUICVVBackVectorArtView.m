#import "BTUICVVBackVectorArtView.h"

@implementation BTUICVVBackVectorArtView

- (void)drawArt {

    //// Color Declarations
    UIColor* color1 = [UIColor colorWithRed: 0.124 green: 0.132 blue: 0.138 alpha: 0.1];
    UIColor* color2 = self.highlightColor ?: color1;
    UIColor* color3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];

    //// Page-1
    {
        //// CVV-Back
        {
            //// Rectangle Drawing
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 8, 87, 12)];
            [color1 setFill];
            [rectanglePath fill];


            //// Rounded Rectangle Drawing
            UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(53, 30, 26, 18) cornerRadius: 9];
            [color2 setFill];
            [roundedRectanglePath fill];


            //// Rectangle 2 Drawing
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(61, 36, 2, 6)];
            [color3 setFill];
            [rectangle2Path fill];


            //// Rectangle 3 Drawing
            UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(65, 36, 2, 6)];
            [color3 setFill];
            [rectangle3Path fill];


            //// Rectangle 4 Drawing
            UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(69, 36, 2, 6)];
            [color3 setFill];
            [rectangle4Path fill];
        }
    }
}

@end
