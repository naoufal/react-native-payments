#import "BTUIPayPalWordmarkCompactVectorArtView.h"
#import "BTUI.h"

@interface BTUIPayPalWordmarkCompactVectorArtView ()
@property (nonatomic, assign) BOOL includePadding;
@end

@implementation BTUIPayPalWordmarkCompactVectorArtView

- (instancetype)initWithPadding {
    self = [super init];
    if (self) {
        self.includePadding = YES;
        [self setupWithArtDimensions:CGSizeMake(158, 88)];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupWithArtDimensions:CGSizeMake(284.0f, 80.0f)];
    }
    return self;
}

- (void)setupWithArtDimensions:(CGSize)artDimensions {
    self.artDimensions = artDimensions;
    self.opaque = NO;
    self.theme = [BTUI braintreeTheme];
}

- (void)drawArt
{
    if (self.includePadding) {
        //// Color Declarations
        UIColor* payColor = [self.theme payBlue]; //[UIColor colorWithRed: 0.005 green: 0.123 blue: 0.454 alpha: 1];
        UIColor* palColor = [self.theme palBlue]; //[UIColor colorWithRed: 0.066 green: 0.536 blue: 0.839 alpha: 1];

        //// Assets
        {
            //// button-paypal
            {
                //// Rectangle Drawing


                //// logo/paypal
                {
                    //// Bezier Drawing
                    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                    [bezierPath moveToPoint: CGPointMake(102.29, 34.76)];
                    [bezierPath addCurveToPoint: CGPointMake(96.25, 38.4) controlPoint1: CGPointMake(101.73, 38.4) controlPoint2: CGPointMake(98.95, 38.4)];
                    [bezierPath addLineToPoint: CGPointMake(94.72, 38.4)];
                    [bezierPath addLineToPoint: CGPointMake(95.8, 31.6)];
                    [bezierPath addCurveToPoint: CGPointMake(96.63, 30.89) controlPoint1: CGPointMake(95.86, 31.19) controlPoint2: CGPointMake(96.22, 30.89)];
                    [bezierPath addLineToPoint: CGPointMake(97.33, 30.89)];
                    [bezierPath addCurveToPoint: CGPointMake(101.79, 31.93) controlPoint1: CGPointMake(99.17, 30.89) controlPoint2: CGPointMake(100.9, 30.89)];
                    [bezierPath addCurveToPoint: CGPointMake(102.29, 34.76) controlPoint1: CGPointMake(102.33, 32.55) controlPoint2: CGPointMake(102.49, 33.48)];
                    [bezierPath addLineToPoint: CGPointMake(102.29, 34.76)];
                    [bezierPath closePath];
                    [bezierPath moveToPoint: CGPointMake(91, 25)];
                    [bezierPath addCurveToPoint: CGPointMake(89.56, 26.45) controlPoint1: CGPointMake(90.31, 25) controlPoint2: CGPointMake(89.67, 25.76)];
                    [bezierPath addLineToPoint: CGPointMake(85.5, 53)];
                    [bezierPath addCurveToPoint: CGPointMake(86.5, 54) controlPoint1: CGPointMake(85.42, 53.51) controlPoint2: CGPointMake(85.98, 54)];
                    [bezierPath addLineToPoint: CGPointMake(91.5, 54)];
                    [bezierPath addCurveToPoint: CGPointMake(92.5, 53) controlPoint1: CGPointMake(91.99, 54) controlPoint2: CGPointMake(92.42, 53.48)];
                    [bezierPath addLineToPoint: CGPointMake(93.64, 45.22)];
                    [bezierPath addCurveToPoint: CGPointMake(95.04, 44.03) controlPoint1: CGPointMake(93.75, 44.54) controlPoint2: CGPointMake(94.34, 44.03)];
                    [bezierPath addLineToPoint: CGPointMake(98.25, 44.03)];
                    [bezierPath addCurveToPoint: CGPointMake(109.81, 34.4) controlPoint1: CGPointMake(104.94, 44.03) controlPoint2: CGPointMake(108.8, 40.8)];
                    [bezierPath addCurveToPoint: CGPointMake(108.52, 27.85) controlPoint1: CGPointMake(110.27, 31.59) controlPoint2: CGPointMake(109.83, 29.39)];
                    [bezierPath addCurveToPoint: CGPointMake(101, 25) controlPoint1: CGPointMake(107.07, 26.16) controlPoint2: CGPointMake(104.4, 25)];
                    [bezierPath addLineToPoint: CGPointMake(91, 25)];
                    [bezierPath closePath];
                    [bezierPath moveToPoint: CGPointMake(123.7, 44.09)];
                    [bezierPath addCurveToPoint: CGPointMake(118.21, 48.73) controlPoint1: CGPointMake(123.22, 46.87) controlPoint2: CGPointMake(121.02, 48.73)];
                    [bezierPath addCurveToPoint: CGPointMake(114.94, 47.42) controlPoint1: CGPointMake(116.79, 48.73) controlPoint2: CGPointMake(115.67, 48.28)];
                    [bezierPath addCurveToPoint: CGPointMake(114.18, 44.01) controlPoint1: CGPointMake(114.22, 46.57) controlPoint2: CGPointMake(113.95, 45.36)];
                    [bezierPath addCurveToPoint: CGPointMake(119.63, 39.33) controlPoint1: CGPointMake(114.61, 41.26) controlPoint2: CGPointMake(116.86, 39.33)];
                    [bezierPath addCurveToPoint: CGPointMake(122.87, 40.66) controlPoint1: CGPointMake(121.01, 39.33) controlPoint2: CGPointMake(122.13, 39.79)];
                    [bezierPath addCurveToPoint: CGPointMake(123.7, 44.09) controlPoint1: CGPointMake(123.62, 41.53) controlPoint2: CGPointMake(123.91, 42.75)];
                    [bezierPath closePath];
                    [bezierPath moveToPoint: CGPointMake(131.15, 34.46)];
                    [bezierPath addLineToPoint: CGPointMake(126.25, 34.46)];
                    [bezierPath addCurveToPoint: CGPointMake(125.41, 35.19) controlPoint1: CGPointMake(125.83, 34.46) controlPoint2: CGPointMake(125.48, 34.77)];
                    [bezierPath addLineToPoint: CGPointMake(125.2, 36.57)];
                    [bezierPath addLineToPoint: CGPointMake(124.85, 36.07)];
                    [bezierPath addCurveToPoint: CGPointMake(119.07, 34) controlPoint1: CGPointMake(123.79, 34.52) controlPoint2: CGPointMake(121.43, 34)];
                    [bezierPath addCurveToPoint: CGPointMake(108.15, 43.92) controlPoint1: CGPointMake(113.67, 34) controlPoint2: CGPointMake(109.05, 38.13)];
                    [bezierPath addCurveToPoint: CGPointMake(109.97, 51.49) controlPoint1: CGPointMake(107.68, 46.81) controlPoint2: CGPointMake(108.34, 49.57)];
                    [bezierPath addCurveToPoint: CGPointMake(116.13, 54) controlPoint1: CGPointMake(111.46, 53.26) controlPoint2: CGPointMake(113.59, 54)];
                    [bezierPath addCurveToPoint: CGPointMake(122.91, 51.18) controlPoint1: CGPointMake(120.49, 54) controlPoint2: CGPointMake(122.91, 51.18)];
                    [bezierPath addLineToPoint: CGPointMake(122.69, 52.55)];
                    [bezierPath addCurveToPoint: CGPointMake(123.53, 53.54) controlPoint1: CGPointMake(122.61, 53.07) controlPoint2: CGPointMake(123.01, 53.54)];
                    [bezierPath addLineToPoint: CGPointMake(127.94, 53.54)];
                    [bezierPath addCurveToPoint: CGPointMake(129.34, 52.33) controlPoint1: CGPointMake(128.64, 53.54) controlPoint2: CGPointMake(129.23, 53.03)];
                    [bezierPath addLineToPoint: CGPointMake(131.99, 35.46)];
                    [bezierPath addCurveToPoint: CGPointMake(131.15, 34.46) controlPoint1: CGPointMake(132.07, 34.94) controlPoint2: CGPointMake(131.67, 34.46)];
                    [bezierPath closePath];
                    [bezierPath moveToPoint: CGPointMake(137, 27)];
                    [bezierPath addLineToPoint: CGPointMake(133, 53)];
                    [bezierPath addCurveToPoint: CGPointMake(134, 54) controlPoint1: CGPointMake(132.93, 53.54) controlPoint2: CGPointMake(133.34, 54)];
                    [bezierPath addLineToPoint: CGPointMake(138, 54)];
                    [bezierPath addCurveToPoint: CGPointMake(140, 53) controlPoint1: CGPointMake(138.98, 54) controlPoint2: CGPointMake(139.59, 53.5)];
                    [bezierPath addLineToPoint: CGPointMake(144, 27)];
                    [bezierPath addCurveToPoint: CGPointMake(143, 26) controlPoint1: CGPointMake(144.07, 26.46) controlPoint2: CGPointMake(143.66, 26)];
                    [bezierPath addLineToPoint: CGPointMake(138, 26)];
                    [bezierPath addCurveToPoint: CGPointMake(137, 27) controlPoint1: CGPointMake(137.79, 26) controlPoint2: CGPointMake(137.42, 26.3)];
                    [bezierPath closePath];
                    bezierPath.miterLimit = 4;

                    bezierPath.usesEvenOddFillRule = YES;

                    [palColor setFill];
                    [bezierPath fill];


                    //// Bezier 2 Drawing
                    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                    [bezier2Path moveToPoint: CGPointMake(29.84, 34.76)];
                    [bezier2Path addCurveToPoint: CGPointMake(23.81, 38.4) controlPoint1: CGPointMake(29.29, 38.4) controlPoint2: CGPointMake(26.5, 38.4)];
                    [bezier2Path addLineToPoint: CGPointMake(22.28, 38.4)];
                    [bezier2Path addLineToPoint: CGPointMake(23.35, 31.6)];
                    [bezier2Path addCurveToPoint: CGPointMake(24.19, 30.89) controlPoint1: CGPointMake(23.42, 31.19) controlPoint2: CGPointMake(23.77, 30.89)];
                    [bezier2Path addLineToPoint: CGPointMake(24.89, 30.89)];
                    [bezier2Path addCurveToPoint: CGPointMake(29.35, 31.93) controlPoint1: CGPointMake(26.72, 30.89) controlPoint2: CGPointMake(28.45, 30.89)];
                    [bezier2Path addCurveToPoint: CGPointMake(29.84, 34.76) controlPoint1: CGPointMake(29.88, 32.55) controlPoint2: CGPointMake(30.04, 33.48)];
                    [bezier2Path addLineToPoint: CGPointMake(29.84, 34.76)];
                    [bezier2Path closePath];
                    [bezier2Path moveToPoint: CGPointMake(18.5, 25)];
                    [bezier2Path addCurveToPoint: CGPointMake(17, 26.5) controlPoint1: CGPointMake(17.81, 25) controlPoint2: CGPointMake(17.11, 25.82)];
                    [bezier2Path addLineToPoint: CGPointMake(13, 53)];
                    [bezier2Path addCurveToPoint: CGPointMake(14, 54) controlPoint1: CGPointMake(12.92, 53.51) controlPoint2: CGPointMake(13.48, 54)];
                    [bezier2Path addLineToPoint: CGPointMake(18.5, 54)];
                    [bezier2Path addCurveToPoint: CGPointMake(20, 52.5) controlPoint1: CGPointMake(19.19, 54) controlPoint2: CGPointMake(19.89, 53.18)];
                    [bezier2Path addLineToPoint: CGPointMake(21.2, 45.22)];
                    [bezier2Path addCurveToPoint: CGPointMake(22.59, 44.03) controlPoint1: CGPointMake(21.31, 44.54) controlPoint2: CGPointMake(21.9, 44.03)];
                    [bezier2Path addLineToPoint: CGPointMake(25.81, 44.03)];
                    [bezier2Path addCurveToPoint: CGPointMake(37.37, 34.4) controlPoint1: CGPointMake(32.5, 44.03) controlPoint2: CGPointMake(36.36, 40.8)];
                    [bezier2Path addCurveToPoint: CGPointMake(36.07, 27.85) controlPoint1: CGPointMake(37.82, 31.59) controlPoint2: CGPointMake(37.39, 29.39)];
                    [bezier2Path addCurveToPoint: CGPointMake(28.5, 25) controlPoint1: CGPointMake(34.63, 26.16) controlPoint2: CGPointMake(31.9, 25)];
                    [bezier2Path addLineToPoint: CGPointMake(18.5, 25)];
                    [bezier2Path closePath];
                    [bezier2Path moveToPoint: CGPointMake(52.25, 44.09)];
                    [bezier2Path addCurveToPoint: CGPointMake(46.76, 48.73) controlPoint1: CGPointMake(51.78, 46.87) controlPoint2: CGPointMake(49.57, 48.73)];
                    [bezier2Path addCurveToPoint: CGPointMake(43.49, 47.42) controlPoint1: CGPointMake(45.35, 48.73) controlPoint2: CGPointMake(44.22, 48.28)];
                    [bezier2Path addCurveToPoint: CGPointMake(42.73, 44.01) controlPoint1: CGPointMake(42.77, 46.57) controlPoint2: CGPointMake(42.5, 45.36)];
                    [bezier2Path addCurveToPoint: CGPointMake(48.18, 39.33) controlPoint1: CGPointMake(43.17, 41.26) controlPoint2: CGPointMake(45.41, 39.33)];
                    [bezier2Path addCurveToPoint: CGPointMake(51.42, 40.66) controlPoint1: CGPointMake(49.56, 39.33) controlPoint2: CGPointMake(50.69, 39.79)];
                    [bezier2Path addCurveToPoint: CGPointMake(52.25, 44.09) controlPoint1: CGPointMake(52.17, 41.53) controlPoint2: CGPointMake(52.46, 42.75)];
                    [bezier2Path closePath];
                    [bezier2Path moveToPoint: CGPointMake(54.5, 34)];
                    [bezier2Path addCurveToPoint: CGPointMake(53.5, 35) controlPoint1: CGPointMake(54.08, 34) controlPoint2: CGPointMake(53.56, 34.58)];
                    [bezier2Path addLineToPoint: CGPointMake(53.2, 36.57)];
                    [bezier2Path addLineToPoint: CGPointMake(52.85, 36.07)];
                    [bezier2Path addCurveToPoint: CGPointMake(47.07, 34) controlPoint1: CGPointMake(51.79, 34.52) controlPoint2: CGPointMake(49.43, 34)];
                    [bezier2Path addCurveToPoint: CGPointMake(36.15, 43.92) controlPoint1: CGPointMake(41.67, 34) controlPoint2: CGPointMake(37.05, 38.13)];
                    [bezier2Path addCurveToPoint: CGPointMake(37.97, 51.49) controlPoint1: CGPointMake(35.68, 46.81) controlPoint2: CGPointMake(36.34, 49.57)];
                    [bezier2Path addCurveToPoint: CGPointMake(44.13, 54) controlPoint1: CGPointMake(39.46, 53.26) controlPoint2: CGPointMake(41.59, 54)];
                    [bezier2Path addCurveToPoint: CGPointMake(50.91, 51.18) controlPoint1: CGPointMake(48.49, 54) controlPoint2: CGPointMake(50.91, 51.18)];
                    [bezier2Path addLineToPoint: CGPointMake(50.5, 53)];
                    [bezier2Path addCurveToPoint: CGPointMake(51.5, 54) controlPoint1: CGPointMake(50.42, 53.52) controlPoint2: CGPointMake(50.98, 54)];
                    [bezier2Path addLineToPoint: CGPointMake(56, 54)];
                    [bezier2Path addCurveToPoint: CGPointMake(57.5, 52.5) controlPoint1: CGPointMake(56.7, 54) controlPoint2: CGPointMake(57.39, 53.2)];
                    [bezier2Path addLineToPoint: CGPointMake(60, 35)];
                    [bezier2Path addCurveToPoint: CGPointMake(59, 34) controlPoint1: CGPointMake(60.08, 34.48) controlPoint2: CGPointMake(59.52, 34)];
                    [bezier2Path addLineToPoint: CGPointMake(54.5, 34)];
                    [bezier2Path closePath];
                    [bezier2Path moveToPoint: CGPointMake(80, 34)];
                    [bezier2Path addCurveToPoint: CGPointMake(79, 35.04) controlPoint1: CGPointMake(79.67, 34) controlPoint2: CGPointMake(79.22, 34.24)];
                    [bezier2Path addLineToPoint: CGPointMake(72, 44.4)];
                    [bezier2Path addLineToPoint: CGPointMake(69, 35.04)];
                    [bezier2Path addCurveToPoint: CGPointMake(68, 34) controlPoint1: CGPointMake(68.97, 34.42) controlPoint2: CGPointMake(68.41, 34)];
                    [bezier2Path addLineToPoint: CGPointMake(63, 34)];
                    [bezier2Path addCurveToPoint: CGPointMake(62, 35.04) controlPoint1: CGPointMake(62.27, 34) controlPoint2: CGPointMake(61.86, 34.58)];
                    [bezier2Path addLineToPoint: CGPointMake(68, 51.68)];
                    [bezier2Path addLineToPoint: CGPointMake(62, 58.96)];
                    [bezier2Path addCurveToPoint: CGPointMake(63, 60) controlPoint1: CGPointMake(61.97, 59.21) controlPoint2: CGPointMake(62.38, 60)];
                    [bezier2Path addLineToPoint: CGPointMake(68, 60)];
                    [bezier2Path addCurveToPoint: CGPointMake(69, 58.96) controlPoint1: CGPointMake(68.54, 60) controlPoint2: CGPointMake(68.98, 59.77)];
                    [bezier2Path addLineToPoint: CGPointMake(86, 35.04)];
                    [bezier2Path addCurveToPoint: CGPointMake(85, 34) controlPoint1: CGPointMake(86.24, 34.79) controlPoint2: CGPointMake(85.83, 34)];
                    [bezier2Path addLineToPoint: CGPointMake(80, 34)];
                    [bezier2Path closePath];
                    bezier2Path.miterLimit = 4;

                    bezier2Path.usesEvenOddFillRule = YES;

                    [payColor setFill];
                    [bezier2Path fill];
                }
            }
        }
    } else {
        //// Color Declarations
        UIColor* color0 = [self.theme palBlue];
        UIColor* color1 = [self.theme payBlue];

        //// PayPal
        {
            //// Group 2
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(189.07, 1.49)];
                [bezierPath addLineToPoint: CGPointMake(167.92, 1.49)];
                [bezierPath addCurveToPoint: CGPointMake(165.02, 3.97) controlPoint1: CGPointMake(166.48, 1.49) controlPoint2: CGPointMake(165.24, 2.54)];
                [bezierPath addLineToPoint: CGPointMake(156.47, 58.2)];
                [bezierPath addCurveToPoint: CGPointMake(158.21, 60.24) controlPoint1: CGPointMake(156.3, 59.27) controlPoint2: CGPointMake(157.12, 60.24)];
                [bezierPath addLineToPoint: CGPointMake(169.06, 60.24)];
                [bezierPath addCurveToPoint: CGPointMake(171.09, 58.5) controlPoint1: CGPointMake(170.07, 60.24) controlPoint2: CGPointMake(170.93, 59.5)];
                [bezierPath addLineToPoint: CGPointMake(173.52, 43.13)];
                [bezierPath addCurveToPoint: CGPointMake(176.42, 40.65) controlPoint1: CGPointMake(173.74, 41.7) controlPoint2: CGPointMake(174.97, 40.65)];
                [bezierPath addLineToPoint: CGPointMake(183.11, 40.65)];
                [bezierPath addCurveToPoint: CGPointMake(207.18, 20.54) controlPoint1: CGPointMake(197.04, 40.65) controlPoint2: CGPointMake(205.08, 33.91)];
                [bezierPath addCurveToPoint: CGPointMake(204.49, 6.89) controlPoint1: CGPointMake(208.13, 14.7) controlPoint2: CGPointMake(207.22, 10.11)];
                [bezierPath addCurveToPoint: CGPointMake(189.07, 1.49) controlPoint1: CGPointMake(201.48, 3.36) controlPoint2: CGPointMake(196.15, 1.49)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(191.51, 21.3)];
                [bezierPath addCurveToPoint: CGPointMake(178.95, 28.89) controlPoint1: CGPointMake(190.36, 28.89) controlPoint2: CGPointMake(184.56, 28.89)];
                [bezierPath addLineToPoint: CGPointMake(175.76, 28.89)];
                [bezierPath addLineToPoint: CGPointMake(178, 14.71)];
                [bezierPath addCurveToPoint: CGPointMake(179.74, 13.23) controlPoint1: CGPointMake(178.13, 13.86) controlPoint2: CGPointMake(178.87, 13.23)];
                [bezierPath addLineToPoint: CGPointMake(181.2, 13.23)];
                [bezierPath addCurveToPoint: CGPointMake(190.48, 15.4) controlPoint1: CGPointMake(185.02, 13.23) controlPoint2: CGPointMake(188.62, 13.23)];
                [bezierPath addCurveToPoint: CGPointMake(191.51, 21.3) controlPoint1: CGPointMake(191.6, 16.7) controlPoint2: CGPointMake(191.93, 18.63)];
                [bezierPath closePath];
                bezierPath.miterLimit = 4;

                [color0 setFill];
                [bezierPath fill];


                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                [bezier2Path moveToPoint: CGPointMake(38.22, 1.49)];
                [bezier2Path addLineToPoint: CGPointMake(17.07, 1.49)];
                [bezier2Path addCurveToPoint: CGPointMake(14.17, 3.97) controlPoint1: CGPointMake(15.62, 1.49) controlPoint2: CGPointMake(14.39, 2.54)];
                [bezier2Path addLineToPoint: CGPointMake(5.61, 58.2)];
                [bezier2Path addCurveToPoint: CGPointMake(7.36, 60.24) controlPoint1: CGPointMake(5.45, 59.27) controlPoint2: CGPointMake(6.27, 60.24)];
                [bezier2Path addLineToPoint: CGPointMake(17.45, 60.24)];
                [bezier2Path addCurveToPoint: CGPointMake(20.36, 57.76) controlPoint1: CGPointMake(18.9, 60.24) controlPoint2: CGPointMake(20.13, 59.19)];
                [bezier2Path addLineToPoint: CGPointMake(22.67, 43.13)];
                [bezier2Path addCurveToPoint: CGPointMake(25.57, 40.65) controlPoint1: CGPointMake(22.89, 41.7) controlPoint2: CGPointMake(24.12, 40.65)];
                [bezier2Path addLineToPoint: CGPointMake(32.26, 40.65)];
                [bezier2Path addCurveToPoint: CGPointMake(56.33, 20.54) controlPoint1: CGPointMake(46.19, 40.65) controlPoint2: CGPointMake(54.23, 33.91)];
                [bezier2Path addCurveToPoint: CGPointMake(53.64, 6.89) controlPoint1: CGPointMake(57.28, 14.7) controlPoint2: CGPointMake(56.37, 10.11)];
                [bezier2Path addCurveToPoint: CGPointMake(38.22, 1.49) controlPoint1: CGPointMake(50.63, 3.36) controlPoint2: CGPointMake(45.3, 1.49)];
                [bezier2Path closePath];
                [bezier2Path moveToPoint: CGPointMake(40.66, 21.3)];
                [bezier2Path addCurveToPoint: CGPointMake(28.1, 28.89) controlPoint1: CGPointMake(39.51, 28.89) controlPoint2: CGPointMake(33.71, 28.89)];
                [bezier2Path addLineToPoint: CGPointMake(24.91, 28.89)];
                [bezier2Path addLineToPoint: CGPointMake(27.15, 14.71)];
                [bezier2Path addCurveToPoint: CGPointMake(28.89, 13.23) controlPoint1: CGPointMake(27.28, 13.86) controlPoint2: CGPointMake(28.02, 13.23)];
                [bezier2Path addLineToPoint: CGPointMake(30.35, 13.23)];
                [bezier2Path addCurveToPoint: CGPointMake(39.63, 15.4) controlPoint1: CGPointMake(34.17, 13.23) controlPoint2: CGPointMake(37.77, 13.23)];
                [bezier2Path addCurveToPoint: CGPointMake(40.66, 21.3) controlPoint1: CGPointMake(40.74, 16.7) controlPoint2: CGPointMake(41.08, 18.63)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;

                [color1 setFill];
                [bezier2Path fill];


                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
                [bezier3Path moveToPoint: CGPointMake(101.44, 21.06)];
                [bezier3Path addLineToPoint: CGPointMake(91.31, 21.06)];
                [bezier3Path addCurveToPoint: CGPointMake(89.57, 22.54) controlPoint1: CGPointMake(90.44, 21.06) controlPoint2: CGPointMake(89.7, 21.69)];
                [bezier3Path addLineToPoint: CGPointMake(89.12, 25.38)];
                [bezier3Path addLineToPoint: CGPointMake(88.41, 24.35)];
                [bezier3Path addCurveToPoint: CGPointMake(76.45, 20.1) controlPoint1: CGPointMake(86.22, 21.17) controlPoint2: CGPointMake(81.33, 20.1)];
                [bezier3Path addCurveToPoint: CGPointMake(53.85, 40.47) controlPoint1: CGPointMake(65.26, 20.1) controlPoint2: CGPointMake(55.71, 28.58)];
                [bezier3Path addCurveToPoint: CGPointMake(57.62, 56.03) controlPoint1: CGPointMake(52.88, 46.41) controlPoint2: CGPointMake(54.25, 52.08)];
                [bezier3Path addCurveToPoint: CGPointMake(70.37, 61.18) controlPoint1: CGPointMake(60.71, 59.67) controlPoint2: CGPointMake(65.12, 61.18)];
                [bezier3Path addCurveToPoint: CGPointMake(84.39, 55.39) controlPoint1: CGPointMake(79.39, 61.18) controlPoint2: CGPointMake(84.39, 55.39)];
                [bezier3Path addLineToPoint: CGPointMake(83.94, 58.2)];
                [bezier3Path addCurveToPoint: CGPointMake(85.68, 60.24) controlPoint1: CGPointMake(83.77, 59.27) controlPoint2: CGPointMake(84.6, 60.24)];
                [bezier3Path addLineToPoint: CGPointMake(94.8, 60.24)];
                [bezier3Path addCurveToPoint: CGPointMake(97.7, 57.76) controlPoint1: CGPointMake(96.25, 60.24) controlPoint2: CGPointMake(97.48, 59.19)];
                [bezier3Path addLineToPoint: CGPointMake(103.18, 23.09)];
                [bezier3Path addCurveToPoint: CGPointMake(101.44, 21.06) controlPoint1: CGPointMake(103.35, 22.02) controlPoint2: CGPointMake(102.52, 21.06)];
                [bezier3Path closePath];
                [bezier3Path moveToPoint: CGPointMake(87.32, 40.77)];
                [bezier3Path addCurveToPoint: CGPointMake(75.89, 50.44) controlPoint1: CGPointMake(86.34, 46.55) controlPoint2: CGPointMake(81.75, 50.44)];
                [bezier3Path addCurveToPoint: CGPointMake(69.09, 47.71) controlPoint1: CGPointMake(72.95, 50.44) controlPoint2: CGPointMake(70.6, 49.49)];
                [bezier3Path addCurveToPoint: CGPointMake(67.5, 40.59) controlPoint1: CGPointMake(67.59, 45.93) controlPoint2: CGPointMake(67.03, 43.4)];
                [bezier3Path addCurveToPoint: CGPointMake(78.85, 30.85) controlPoint1: CGPointMake(68.42, 34.86) controlPoint2: CGPointMake(73.08, 30.85)];
                [bezier3Path addCurveToPoint: CGPointMake(85.61, 33.61) controlPoint1: CGPointMake(81.73, 30.85) controlPoint2: CGPointMake(84.07, 31.8)];
                [bezier3Path addCurveToPoint: CGPointMake(87.32, 40.77) controlPoint1: CGPointMake(87.16, 35.42) controlPoint2: CGPointMake(87.77, 37.97)];
                [bezier3Path closePath];
                bezier3Path.miterLimit = 4;

                [color1 setFill];
                [bezier3Path fill];


                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
                [bezier4Path moveToPoint: CGPointMake(252.29, 21.06)];
                [bezier4Path addLineToPoint: CGPointMake(242.16, 21.06)];
                [bezier4Path addCurveToPoint: CGPointMake(240.42, 22.54) controlPoint1: CGPointMake(241.29, 21.06) controlPoint2: CGPointMake(240.55, 21.69)];
                [bezier4Path addLineToPoint: CGPointMake(239.97, 25.38)];
                [bezier4Path addLineToPoint: CGPointMake(239.27, 24.35)];
                [bezier4Path addCurveToPoint: CGPointMake(227.3, 20.1) controlPoint1: CGPointMake(237.07, 21.17) controlPoint2: CGPointMake(232.18, 20.1)];
                [bezier4Path addCurveToPoint: CGPointMake(204.7, 40.47) controlPoint1: CGPointMake(216.12, 20.1) controlPoint2: CGPointMake(206.56, 28.58)];
                [bezier4Path addCurveToPoint: CGPointMake(208.47, 56.03) controlPoint1: CGPointMake(203.73, 46.41) controlPoint2: CGPointMake(205.1, 52.08)];
                [bezier4Path addCurveToPoint: CGPointMake(221.22, 61.18) controlPoint1: CGPointMake(211.56, 59.67) controlPoint2: CGPointMake(215.97, 61.18)];
                [bezier4Path addCurveToPoint: CGPointMake(235.24, 55.39) controlPoint1: CGPointMake(230.24, 61.18) controlPoint2: CGPointMake(235.24, 55.39)];
                [bezier4Path addLineToPoint: CGPointMake(234.79, 58.2)];
                [bezier4Path addCurveToPoint: CGPointMake(236.53, 60.24) controlPoint1: CGPointMake(234.62, 59.27) controlPoint2: CGPointMake(235.45, 60.24)];
                [bezier4Path addLineToPoint: CGPointMake(245.65, 60.24)];
                [bezier4Path addCurveToPoint: CGPointMake(248.56, 57.76) controlPoint1: CGPointMake(247.1, 60.24) controlPoint2: CGPointMake(248.33, 59.19)];
                [bezier4Path addLineToPoint: CGPointMake(254.03, 23.09)];
                [bezier4Path addCurveToPoint: CGPointMake(252.29, 21.06) controlPoint1: CGPointMake(254.2, 22.02) controlPoint2: CGPointMake(253.37, 21.06)];
                [bezier4Path closePath];
                [bezier4Path moveToPoint: CGPointMake(238.17, 40.77)];
                [bezier4Path addCurveToPoint: CGPointMake(226.74, 50.44) controlPoint1: CGPointMake(237.19, 46.55) controlPoint2: CGPointMake(232.6, 50.44)];
                [bezier4Path addCurveToPoint: CGPointMake(219.94, 47.71) controlPoint1: CGPointMake(223.8, 50.44) controlPoint2: CGPointMake(221.45, 49.49)];
                [bezier4Path addCurveToPoint: CGPointMake(218.35, 40.59) controlPoint1: CGPointMake(218.44, 45.93) controlPoint2: CGPointMake(217.88, 43.4)];
                [bezier4Path addCurveToPoint: CGPointMake(229.7, 30.85) controlPoint1: CGPointMake(219.26, 34.86) controlPoint2: CGPointMake(223.93, 30.85)];
                [bezier4Path addCurveToPoint: CGPointMake(236.46, 33.61) controlPoint1: CGPointMake(232.58, 30.85) controlPoint2: CGPointMake(234.91, 31.8)];
                [bezier4Path addCurveToPoint: CGPointMake(238.17, 40.77) controlPoint1: CGPointMake(238.01, 35.42) controlPoint2: CGPointMake(238.62, 37.97)];
                [bezier4Path closePath];
                bezier4Path.miterLimit = 4;

                [color0 setFill];
                [bezier4Path fill];


                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
                [bezier5Path moveToPoint: CGPointMake(155.38, 21.06)];
                [bezier5Path addLineToPoint: CGPointMake(145.2, 21.06)];
                [bezier5Path addCurveToPoint: CGPointMake(142.76, 22.34) controlPoint1: CGPointMake(144.22, 21.06) controlPoint2: CGPointMake(143.31, 21.54)];
                [bezier5Path addLineToPoint: CGPointMake(128.72, 43.02)];
                [bezier5Path addLineToPoint: CGPointMake(122.77, 23.15)];
                [bezier5Path addCurveToPoint: CGPointMake(119.96, 21.06) controlPoint1: CGPointMake(122.4, 21.91) controlPoint2: CGPointMake(121.26, 21.06)];
                [bezier5Path addLineToPoint: CGPointMake(109.95, 21.06)];
                [bezier5Path addCurveToPoint: CGPointMake(108.28, 23.39) controlPoint1: CGPointMake(108.74, 21.06) controlPoint2: CGPointMake(107.89, 22.24)];
                [bezier5Path addLineToPoint: CGPointMake(119.49, 56.29)];
                [bezier5Path addLineToPoint: CGPointMake(108.95, 71.16)];
                [bezier5Path addCurveToPoint: CGPointMake(110.39, 73.95) controlPoint1: CGPointMake(108.12, 72.33) controlPoint2: CGPointMake(108.96, 73.95)];
                [bezier5Path addLineToPoint: CGPointMake(120.56, 73.95)];
                [bezier5Path addCurveToPoint: CGPointMake(122.97, 72.68) controlPoint1: CGPointMake(121.52, 73.95) controlPoint2: CGPointMake(122.42, 73.47)];
                [bezier5Path addLineToPoint: CGPointMake(156.82, 23.82)];
                [bezier5Path addCurveToPoint: CGPointMake(155.38, 21.06) controlPoint1: CGPointMake(157.63, 22.65) controlPoint2: CGPointMake(156.8, 21.06)];
                [bezier5Path closePath];
                bezier5Path.miterLimit = 4;

                [color1 setFill];
                [bezier5Path fill];


                //// Bezier 6 Drawing
                UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
                [bezier6Path moveToPoint: CGPointMake(264.22, 2.98)];
                [bezier6Path addLineToPoint: CGPointMake(255.54, 58.21)];
                [bezier6Path addCurveToPoint: CGPointMake(257.29, 60.24) controlPoint1: CGPointMake(255.38, 59.27) controlPoint2: CGPointMake(256.2, 60.24)];
                [bezier6Path addLineToPoint: CGPointMake(266.01, 60.24)];
                [bezier6Path addCurveToPoint: CGPointMake(268.92, 57.76) controlPoint1: CGPointMake(267.46, 60.24) controlPoint2: CGPointMake(268.69, 59.19)];
                [bezier6Path addLineToPoint: CGPointMake(277.48, 3.53)];
                [bezier6Path addCurveToPoint: CGPointMake(275.73, 1.49) controlPoint1: CGPointMake(277.64, 2.46) controlPoint2: CGPointMake(276.82, 1.49)];
                [bezier6Path addLineToPoint: CGPointMake(265.96, 1.49)];
                [bezier6Path addCurveToPoint: CGPointMake(264.22, 2.98) controlPoint1: CGPointMake(265.1, 1.49) controlPoint2: CGPointMake(264.36, 2.12)];
                [bezier6Path closePath];
                bezier6Path.miterLimit = 4;

                [color0 setFill];
                [bezier6Path fill];
            }
        }
    }
}

- (void)updateConstraints {
    NSLayoutConstraint *aspectRatioConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeHeight
                                                                            multiplier:(self.artDimensions.width / self.artDimensions.height)
                                                                              constant:0.0f];
    aspectRatioConstraint.priority = UILayoutPriorityRequired;

    [self addConstraint:aspectRatioConstraint];

    [super updateConstraints];
}

- (UILayoutPriority)contentCompressionResistancePriorityForAxis:(__unused UILayoutConstraintAxis)axis {
    return UILayoutPriorityRequired;
}

@end
