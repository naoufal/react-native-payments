#import "BTUIPayPalWordmarkVectorArtView.h"
#import "BTUI.h"

@interface BTUIPayPalWordmarkVectorArtView ()
@property (nonatomic, assign) BOOL includePadding;
@end

@implementation BTUIPayPalWordmarkVectorArtView

- (instancetype)initWithPadding {
    self = [super init];
    if (self) {
        self.includePadding = YES;
        [self setupWithArtDimensions:CGSizeMake(200, 50)];
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
    if (!self.includePadding) {
        [self drawWithoutPadding];
    } else {
        [self drawWithPadding];
    }
}

- (void)drawWithoutPadding {
}

- (void)drawWithPadding {
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.68];
    UIColor* color3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.7];
    UIColor* color1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];

    //// Page-1
    {
        //// paypal_monogram-wordmark-3d-copy
        {
            //// Group 4
            {
                //// logo
                {
                    //// wordmark
                    {
                        //// Bezier Drawing
                        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                        [bezierPath moveToPoint: CGPointMake(81.45, 22.34)];
                        [bezierPath addCurveToPoint: CGPointMake(78.78, 24) controlPoint1: CGPointMake(81.2, 24) controlPoint2: CGPointMake(79.97, 24)];
                        [bezierPath addLineToPoint: CGPointMake(78.1, 24)];
                        [bezierPath addLineToPoint: CGPointMake(78.58, 20.9)];
                        [bezierPath addCurveToPoint: CGPointMake(78.95, 20.57) controlPoint1: CGPointMake(78.61, 20.71) controlPoint2: CGPointMake(78.76, 20.57)];
                        [bezierPath addLineToPoint: CGPointMake(79.26, 20.57)];
                        [bezierPath addCurveToPoint: CGPointMake(81.23, 21.05) controlPoint1: CGPointMake(80.07, 20.57) controlPoint2: CGPointMake(80.83, 20.57)];
                        [bezierPath addCurveToPoint: CGPointMake(81.45, 22.34) controlPoint1: CGPointMake(81.46, 21.33) controlPoint2: CGPointMake(81.54, 21.75)];
                        [bezierPath closePath];
                        [bezierPath moveToPoint: CGPointMake(80.93, 18)];
                        [bezierPath addLineToPoint: CGPointMake(76.44, 18)];
                        [bezierPath addCurveToPoint: CGPointMake(75.82, 18.54) controlPoint1: CGPointMake(76.13, 18) controlPoint2: CGPointMake(75.87, 18.23)];
                        [bezierPath addLineToPoint: CGPointMake(74, 30.42)];
                        [bezierPath addCurveToPoint: CGPointMake(74.37, 30.87) controlPoint1: CGPointMake(73.97, 30.66) controlPoint2: CGPointMake(74.14, 30.87)];
                        [bezierPath addLineToPoint: CGPointMake(76.68, 30.87)];
                        [bezierPath addCurveToPoint: CGPointMake(77.11, 30.49) controlPoint1: CGPointMake(76.89, 30.87) controlPoint2: CGPointMake(77.08, 30.71)];
                        [bezierPath addLineToPoint: CGPointMake(77.63, 27.12)];
                        [bezierPath addCurveToPoint: CGPointMake(78.24, 26.58) controlPoint1: CGPointMake(77.67, 26.81) controlPoint2: CGPointMake(77.93, 26.58)];
                        [bezierPath addLineToPoint: CGPointMake(79.66, 26.58)];
                        [bezierPath addCurveToPoint: CGPointMake(84.77, 22.17) controlPoint1: CGPointMake(82.62, 26.58) controlPoint2: CGPointMake(84.33, 25.1)];
                        [bezierPath addCurveToPoint: CGPointMake(84.2, 19.18) controlPoint1: CGPointMake(84.98, 20.89) controlPoint2: CGPointMake(84.78, 19.89)];
                        [bezierPath addCurveToPoint: CGPointMake(80.93, 18) controlPoint1: CGPointMake(83.56, 18.41) controlPoint2: CGPointMake(82.43, 18)];
                        [bezierPath closePath];
                        bezierPath.miterLimit = 4;

                        bezierPath.usesEvenOddFillRule = YES;

                        [color1 setFill];
                        [bezierPath fill];


                        //// Bezier 2 Drawing
                        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                        [bezier2Path moveToPoint: CGPointMake(49.45, 22.34)];
                        [bezier2Path addCurveToPoint: CGPointMake(46.78, 24) controlPoint1: CGPointMake(49.2, 24) controlPoint2: CGPointMake(47.97, 24)];
                        [bezier2Path addLineToPoint: CGPointMake(46.1, 24)];
                        [bezier2Path addLineToPoint: CGPointMake(46.58, 20.9)];
                        [bezier2Path addCurveToPoint: CGPointMake(46.95, 20.57) controlPoint1: CGPointMake(46.6, 20.71) controlPoint2: CGPointMake(46.76, 20.57)];
                        [bezier2Path addLineToPoint: CGPointMake(47.26, 20.57)];
                        [bezier2Path addCurveToPoint: CGPointMake(49.23, 21.05) controlPoint1: CGPointMake(48.07, 20.57) controlPoint2: CGPointMake(48.83, 20.57)];
                        [bezier2Path addCurveToPoint: CGPointMake(49.45, 22.34) controlPoint1: CGPointMake(49.46, 21.33) controlPoint2: CGPointMake(49.54, 21.75)];
                        [bezier2Path closePath];
                        [bezier2Path moveToPoint: CGPointMake(48.93, 18)];
                        [bezier2Path addLineToPoint: CGPointMake(44.44, 18)];
                        [bezier2Path addCurveToPoint: CGPointMake(43.82, 18.54) controlPoint1: CGPointMake(44.13, 18) controlPoint2: CGPointMake(43.87, 18.23)];
                        [bezier2Path addLineToPoint: CGPointMake(42, 30.42)];
                        [bezier2Path addCurveToPoint: CGPointMake(42.37, 30.87) controlPoint1: CGPointMake(41.97, 30.66) controlPoint2: CGPointMake(42.14, 30.87)];
                        [bezier2Path addLineToPoint: CGPointMake(44.52, 30.87)];
                        [bezier2Path addCurveToPoint: CGPointMake(45.13, 30.32) controlPoint1: CGPointMake(44.83, 30.87) controlPoint2: CGPointMake(45.09, 30.64)];
                        [bezier2Path addLineToPoint: CGPointMake(45.62, 27.12)];
                        [bezier2Path addCurveToPoint: CGPointMake(46.24, 26.58) controlPoint1: CGPointMake(45.67, 26.81) controlPoint2: CGPointMake(45.93, 26.58)];
                        [bezier2Path addLineToPoint: CGPointMake(47.66, 26.58)];
                        [bezier2Path addCurveToPoint: CGPointMake(52.77, 22.17) controlPoint1: CGPointMake(50.62, 26.58) controlPoint2: CGPointMake(52.33, 25.1)];
                        [bezier2Path addCurveToPoint: CGPointMake(52.2, 19.18) controlPoint1: CGPointMake(52.97, 20.89) controlPoint2: CGPointMake(52.78, 19.89)];
                        [bezier2Path addCurveToPoint: CGPointMake(48.93, 18) controlPoint1: CGPointMake(51.56, 18.41) controlPoint2: CGPointMake(50.43, 18)];
                        [bezier2Path closePath];
                        bezier2Path.miterLimit = 4;

                        bezier2Path.usesEvenOddFillRule = YES;

                        [color1 setFill];
                        [bezier2Path fill];


                        //// Bezier 3 Drawing
                        UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
                        [bezier3Path moveToPoint: CGPointMake(59.17, 26.53)];
                        [bezier3Path addCurveToPoint: CGPointMake(56.75, 28.64) controlPoint1: CGPointMake(58.97, 27.79) controlPoint2: CGPointMake(57.99, 28.64)];
                        [bezier3Path addCurveToPoint: CGPointMake(55.3, 28.05) controlPoint1: CGPointMake(56.12, 28.64) controlPoint2: CGPointMake(55.62, 28.44)];
                        [bezier3Path addCurveToPoint: CGPointMake(54.97, 26.49) controlPoint1: CGPointMake(54.98, 27.66) controlPoint2: CGPointMake(54.86, 27.1)];
                        [bezier3Path addCurveToPoint: CGPointMake(57.38, 24.35) controlPoint1: CGPointMake(55.16, 25.23) controlPoint2: CGPointMake(56.15, 24.35)];
                        [bezier3Path addCurveToPoint: CGPointMake(58.81, 24.96) controlPoint1: CGPointMake(57.99, 24.35) controlPoint2: CGPointMake(58.48, 24.56)];
                        [bezier3Path addCurveToPoint: CGPointMake(59.17, 26.53) controlPoint1: CGPointMake(59.14, 25.36) controlPoint2: CGPointMake(59.27, 25.91)];
                        [bezier3Path closePath];
                        [bezier3Path moveToPoint: CGPointMake(62.17, 22.21)];
                        [bezier3Path addLineToPoint: CGPointMake(60.02, 22.21)];
                        [bezier3Path addCurveToPoint: CGPointMake(59.65, 22.54) controlPoint1: CGPointMake(59.84, 22.21) controlPoint2: CGPointMake(59.68, 22.35)];
                        [bezier3Path addLineToPoint: CGPointMake(59.56, 23.15)];
                        [bezier3Path addLineToPoint: CGPointMake(59.41, 22.93)];
                        [bezier3Path addCurveToPoint: CGPointMake(56.87, 22) controlPoint1: CGPointMake(58.94, 22.23) controlPoint2: CGPointMake(57.9, 22)];
                        [bezier3Path addCurveToPoint: CGPointMake(52.06, 26.46) controlPoint1: CGPointMake(54.49, 22) controlPoint2: CGPointMake(52.46, 23.86)];
                        [bezier3Path addCurveToPoint: CGPointMake(52.87, 29.87) controlPoint1: CGPointMake(51.86, 27.76) controlPoint2: CGPointMake(52.15, 29)];
                        [bezier3Path addCurveToPoint: CGPointMake(55.57, 31) controlPoint1: CGPointMake(53.52, 30.67) controlPoint2: CGPointMake(54.46, 31)];
                        [bezier3Path addCurveToPoint: CGPointMake(58.55, 29.73) controlPoint1: CGPointMake(57.49, 31) controlPoint2: CGPointMake(58.55, 29.73)];
                        [bezier3Path addLineToPoint: CGPointMake(58.46, 30.34)];
                        [bezier3Path addCurveToPoint: CGPointMake(58.82, 30.79) controlPoint1: CGPointMake(58.42, 30.58) controlPoint2: CGPointMake(58.59, 30.79)];
                        [bezier3Path addLineToPoint: CGPointMake(60.76, 30.79)];
                        [bezier3Path addCurveToPoint: CGPointMake(61.38, 30.25) controlPoint1: CGPointMake(61.07, 30.79) controlPoint2: CGPointMake(61.33, 30.56)];
                        [bezier3Path addLineToPoint: CGPointMake(62.54, 22.65)];
                        [bezier3Path addCurveToPoint: CGPointMake(62.17, 22.21) controlPoint1: CGPointMake(62.58, 22.42) controlPoint2: CGPointMake(62.4, 22.21)];
                        [bezier3Path closePath];
                        bezier3Path.miterLimit = 4;

                        bezier3Path.usesEvenOddFillRule = YES;

                        [color1 setFill];
                        [bezier3Path fill];


                        //// Bezier 4 Drawing
                        UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
                        [bezier4Path moveToPoint: CGPointMake(91.18, 26.53)];
                        [bezier4Path addCurveToPoint: CGPointMake(88.75, 28.64) controlPoint1: CGPointMake(90.97, 27.79) controlPoint2: CGPointMake(89.99, 28.64)];
                        [bezier4Path addCurveToPoint: CGPointMake(87.3, 28.05) controlPoint1: CGPointMake(88.12, 28.64) controlPoint2: CGPointMake(87.62, 28.44)];
                        [bezier4Path addCurveToPoint: CGPointMake(86.97, 26.49) controlPoint1: CGPointMake(86.99, 27.66) controlPoint2: CGPointMake(86.87, 27.1)];
                        [bezier4Path addCurveToPoint: CGPointMake(89.38, 24.35) controlPoint1: CGPointMake(87.16, 25.23) controlPoint2: CGPointMake(88.15, 24.35)];
                        [bezier4Path addCurveToPoint: CGPointMake(90.81, 24.96) controlPoint1: CGPointMake(89.99, 24.35) controlPoint2: CGPointMake(90.48, 24.56)];
                        [bezier4Path addCurveToPoint: CGPointMake(91.18, 26.53) controlPoint1: CGPointMake(91.14, 25.36) controlPoint2: CGPointMake(91.27, 25.91)];
                        [bezier4Path closePath];
                        [bezier4Path moveToPoint: CGPointMake(94.18, 22.21)];
                        [bezier4Path addLineToPoint: CGPointMake(92.02, 22.21)];
                        [bezier4Path addCurveToPoint: CGPointMake(91.65, 22.54) controlPoint1: CGPointMake(91.84, 22.21) controlPoint2: CGPointMake(91.68, 22.35)];
                        [bezier4Path addLineToPoint: CGPointMake(91.56, 23.15)];
                        [bezier4Path addLineToPoint: CGPointMake(91.41, 22.93)];
                        [bezier4Path addCurveToPoint: CGPointMake(88.87, 22) controlPoint1: CGPointMake(90.94, 22.23) controlPoint2: CGPointMake(89.9, 22)];
                        [bezier4Path addCurveToPoint: CGPointMake(84.06, 26.46) controlPoint1: CGPointMake(86.49, 22) controlPoint2: CGPointMake(84.46, 23.86)];
                        [bezier4Path addCurveToPoint: CGPointMake(84.87, 29.87) controlPoint1: CGPointMake(83.86, 27.76) controlPoint2: CGPointMake(84.15, 29)];
                        [bezier4Path addCurveToPoint: CGPointMake(87.58, 31) controlPoint1: CGPointMake(85.52, 30.67) controlPoint2: CGPointMake(86.46, 31)];
                        [bezier4Path addCurveToPoint: CGPointMake(90.55, 29.73) controlPoint1: CGPointMake(89.49, 31) controlPoint2: CGPointMake(90.55, 29.73)];
                        [bezier4Path addLineToPoint: CGPointMake(90.46, 30.34)];
                        [bezier4Path addCurveToPoint: CGPointMake(90.83, 30.79) controlPoint1: CGPointMake(90.42, 30.58) controlPoint2: CGPointMake(90.6, 30.79)];
                        [bezier4Path addLineToPoint: CGPointMake(92.77, 30.79)];
                        [bezier4Path addCurveToPoint: CGPointMake(93.38, 30.25) controlPoint1: CGPointMake(93.07, 30.79) controlPoint2: CGPointMake(93.33, 30.56)];
                        [bezier4Path addLineToPoint: CGPointMake(94.55, 22.65)];
                        [bezier4Path addCurveToPoint: CGPointMake(94.18, 22.21) controlPoint1: CGPointMake(94.58, 22.42) controlPoint2: CGPointMake(94.41, 22.21)];
                        [bezier4Path closePath];
                        bezier4Path.miterLimit = 4;

                        bezier4Path.usesEvenOddFillRule = YES;

                        [color1 setFill];
                        [bezier4Path fill];


                        //// Bezier 5 Drawing
                        UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
                        [bezier5Path moveToPoint: CGPointMake(73.02, 22)];
                        [bezier5Path addLineToPoint: CGPointMake(70.86, 22)];
                        [bezier5Path addCurveToPoint: CGPointMake(70.35, 22.28) controlPoint1: CGPointMake(70.66, 22) controlPoint2: CGPointMake(70.46, 22.11)];
                        [bezier5Path addLineToPoint: CGPointMake(67.36, 26.81)];
                        [bezier5Path addLineToPoint: CGPointMake(66.1, 22.46)];
                        [bezier5Path addCurveToPoint: CGPointMake(65.5, 22) controlPoint1: CGPointMake(66.02, 22.19) controlPoint2: CGPointMake(65.78, 22)];
                        [bezier5Path addLineToPoint: CGPointMake(63.37, 22)];
                        [bezier5Path addCurveToPoint: CGPointMake(63.02, 22.51) controlPoint1: CGPointMake(63.12, 22) controlPoint2: CGPointMake(62.94, 22.26)];
                        [bezier5Path addLineToPoint: CGPointMake(65.4, 29.72)];
                        [bezier5Path addLineToPoint: CGPointMake(63.16, 32.97)];
                        [bezier5Path addCurveToPoint: CGPointMake(63.47, 33.58) controlPoint1: CGPointMake(62.99, 33.23) controlPoint2: CGPointMake(63.16, 33.58)];
                        [bezier5Path addLineToPoint: CGPointMake(65.63, 33.58)];
                        [bezier5Path addCurveToPoint: CGPointMake(66.14, 33.31) controlPoint1: CGPointMake(65.83, 33.58) controlPoint2: CGPointMake(66.02, 33.48)];
                        [bezier5Path addLineToPoint: CGPointMake(73.33, 22.61)];
                        [bezier5Path addCurveToPoint: CGPointMake(73.02, 22) controlPoint1: CGPointMake(73.5, 22.35) controlPoint2: CGPointMake(73.33, 22)];
                        [bezier5Path closePath];
                        bezier5Path.miterLimit = 4;

                        bezier5Path.usesEvenOddFillRule = YES;

                        [color1 setFill];
                        [bezier5Path fill];


                        //// Bezier 6 Drawing
                        UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
                        [bezier6Path moveToPoint: CGPointMake(96.85, 18.33)];
                        [bezier6Path addLineToPoint: CGPointMake(95, 30.42)];
                        [bezier6Path addCurveToPoint: CGPointMake(95.37, 30.87) controlPoint1: CGPointMake(94.97, 30.66) controlPoint2: CGPointMake(95.14, 30.87)];
                        [bezier6Path addLineToPoint: CGPointMake(97.23, 30.87)];
                        [bezier6Path addCurveToPoint: CGPointMake(97.84, 30.32) controlPoint1: CGPointMake(97.54, 30.87) controlPoint2: CGPointMake(97.8, 30.64)];
                        [bezier6Path addLineToPoint: CGPointMake(99.66, 18.45)];
                        [bezier6Path addCurveToPoint: CGPointMake(99.29, 18) controlPoint1: CGPointMake(99.7, 18.21) controlPoint2: CGPointMake(99.52, 18)];
                        [bezier6Path addLineToPoint: CGPointMake(97.22, 18)];
                        [bezier6Path addCurveToPoint: CGPointMake(96.85, 18.33) controlPoint1: CGPointMake(97.03, 18) controlPoint2: CGPointMake(96.88, 18.14)];
                        [bezier6Path closePath];
                        bezier6Path.miterLimit = 4;

                        bezier6Path.usesEvenOddFillRule = YES;

                        [color1 setFill];
                        [bezier6Path fill];
                    }


                    //// monogram
                    {
                        //// Bezier 7 Drawing
                        UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
                        [bezier7Path moveToPoint: CGPointMake(37.4, 24.5)];
                        [bezier7Path addCurveToPoint: CGPointMake(37.48, 22.4) controlPoint1: CGPointMake(37.55, 23.71) controlPoint2: CGPointMake(37.57, 23)];
                        [bezier7Path addCurveToPoint: CGPointMake(36.77, 20.78) controlPoint1: CGPointMake(37.38, 21.76) controlPoint2: CGPointMake(37.14, 21.22)];
                        [bezier7Path addCurveToPoint: CGPointMake(35.91, 20.1) controlPoint1: CGPointMake(36.54, 20.52) controlPoint2: CGPointMake(36.25, 20.29)];
                        [bezier7Path addCurveToPoint: CGPointMake(35.88, 18.08) controlPoint1: CGPointMake(36.02, 19.3) controlPoint2: CGPointMake(36.01, 18.64)];
                        [bezier7Path addCurveToPoint: CGPointMake(35.08, 16.52) controlPoint1: CGPointMake(35.75, 17.51) controlPoint2: CGPointMake(35.49, 17)];
                        [bezier7Path addCurveToPoint: CGPointMake(30.46, 15.02) controlPoint1: CGPointMake(34.23, 15.53) controlPoint2: CGPointMake(32.67, 15.02)];
                        [bezier7Path addLineToPoint: CGPointMake(24.39, 15.02)];
                        [bezier7Path addCurveToPoint: CGPointMake(23.55, 15.75) controlPoint1: CGPointMake(23.97, 15.02) controlPoint2: CGPointMake(23.62, 15.33)];
                        [bezier7Path addLineToPoint: CGPointMake(21.03, 32.18)];
                        [bezier7Path addCurveToPoint: CGPointMake(21.14, 32.6) controlPoint1: CGPointMake(21, 32.33) controlPoint2: CGPointMake(21.04, 32.48)];
                        [bezier7Path addCurveToPoint: CGPointMake(21.52, 32.78) controlPoint1: CGPointMake(21.24, 32.71) controlPoint2: CGPointMake(21.37, 32.78)];
                        [bezier7Path addLineToPoint: CGPointMake(25.29, 32.78)];
                        [bezier7Path addLineToPoint: CGPointMake(25.03, 34.48)];
                        [bezier7Path addCurveToPoint: CGPointMake(25.13, 34.84) controlPoint1: CGPointMake(25.01, 34.61) controlPoint2: CGPointMake(25.05, 34.74)];
                        [bezier7Path addCurveToPoint: CGPointMake(25.46, 35) controlPoint1: CGPointMake(25.21, 34.94) controlPoint2: CGPointMake(25.33, 35)];
                        [bezier7Path addLineToPoint: CGPointMake(28.62, 35)];
                        [bezier7Path addCurveToPoint: CGPointMake(29.35, 34.36) controlPoint1: CGPointMake(28.99, 35) controlPoint2: CGPointMake(29.29, 34.73)];
                        [bezier7Path addLineToPoint: CGPointMake(29.38, 34.19)];
                        [bezier7Path addLineToPoint: CGPointMake(29.98, 30.33)];
                        [bezier7Path addLineToPoint: CGPointMake(30.02, 30.11)];
                        [bezier7Path addCurveToPoint: CGPointMake(30.79, 29.44) controlPoint1: CGPointMake(30.08, 29.72) controlPoint2: CGPointMake(30.4, 29.44)];
                        [bezier7Path addLineToPoint: CGPointMake(31.26, 29.44)];
                        [bezier7Path addCurveToPoint: CGPointMake(35.21, 28.34) controlPoint1: CGPointMake(32.88, 29.44) controlPoint2: CGPointMake(34.21, 29.07)];
                        [bezier7Path addCurveToPoint: CGPointMake(36.57, 26.82) controlPoint1: CGPointMake(35.76, 27.95) controlPoint2: CGPointMake(36.21, 27.43)];
                        [bezier7Path addCurveToPoint: CGPointMake(37.4, 24.5) controlPoint1: CGPointMake(36.95, 26.17) controlPoint2: CGPointMake(37.23, 25.39)];
                        [bezier7Path closePath];
                        bezier7Path.miterLimit = 4;

                        bezier7Path.usesEvenOddFillRule = YES;

                        [color2 setFill];
                        [bezier7Path fill];


                        //// Bezier 8 Drawing
                        UIBezierPath* bezier8Path = [UIBezierPath bezierPath];
                        [bezier8Path moveToPoint: CGPointMake(27.34, 20.29)];
                        [bezier8Path addCurveToPoint: CGPointMake(27.91, 19.71) controlPoint1: CGPointMake(27.25, 19.81) controlPoint2: CGPointMake(27.41, 19.59)];
                        [bezier8Path addCurveToPoint: CGPointMake(27.91, 19.12) controlPoint1: CGPointMake(27.73, 19.44) controlPoint2: CGPointMake(27.84, 19.41)];
                        [bezier8Path addLineToPoint: CGPointMake(32.52, 19.12)];
                        [bezier8Path addCurveToPoint: CGPointMake(34.25, 19.71) controlPoint1: CGPointMake(33.27, 19.41) controlPoint2: CGPointMake(33.8, 19.45)];
                        [bezier8Path addCurveToPoint: CGPointMake(34.82, 19.71) controlPoint1: CGPointMake(34.41, 19.55) controlPoint2: CGPointMake(34.55, 19.58)];
                        [bezier8Path addCurveToPoint: CGPointMake(34.82, 19.71) controlPoint1: CGPointMake(34.8, 19.63) controlPoint2: CGPointMake(34.93, 19.67)];
                        [bezier8Path addCurveToPoint: CGPointMake(35.4, 19.71) controlPoint1: CGPointMake(35.11, 19.72) controlPoint2: CGPointMake(35.17, 19.74)];
                        [bezier8Path addCurveToPoint: CGPointMake(35.98, 20.29) controlPoint1: CGPointMake(35.47, 19.84) controlPoint2: CGPointMake(35.69, 19.93)];
                        [bezier8Path addCurveToPoint: CGPointMake(34.82, 16.76) controlPoint1: CGPointMake(36.13, 18.5) controlPoint2: CGPointMake(35.89, 17.45)];
                        [bezier8Path addCurveToPoint: CGPointMake(30.22, 15) controlPoint1: CGPointMake(34.16, 15.45) controlPoint2: CGPointMake(32.53, 15)];
                        [bezier8Path addLineToPoint: CGPointMake(24.46, 15)];
                        [bezier8Path addCurveToPoint: CGPointMake(23.3, 15.59) controlPoint1: CGPointMake(23.96, 15) controlPoint2: CGPointMake(23.6, 15.32)];
                        [bezier8Path addLineToPoint: CGPointMake(21, 32.06)];
                        [bezier8Path addCurveToPoint: CGPointMake(21.58, 32.65) controlPoint1: CGPointMake(20.96, 32.36) controlPoint2: CGPointMake(21.2, 32.65)];
                        [bezier8Path addLineToPoint: CGPointMake(25.03, 32.65)];
                        [bezier8Path addLineToPoint: CGPointMake(26.18, 26.76)];
                        [bezier8Path addLineToPoint: CGPointMake(27.34, 20.29)];
                        [bezier8Path closePath];
                        bezier8Path.miterLimit = 4;

                        bezier8Path.usesEvenOddFillRule = YES;

                        [color1 setFill];
                        [bezier8Path fill];


                        //// Bezier 9 Drawing
                        UIBezierPath* bezier9Path = [UIBezierPath bezierPath];
                        [bezier9Path moveToPoint: CGPointMake(35.4, 19.71)];
                        [bezier9Path addCurveToPoint: CGPointMake(34.82, 19.12) controlPoint1: CGPointMake(35.01, 19.38) controlPoint2: CGPointMake(34.88, 19.35)];
                        [bezier9Path addCurveToPoint: CGPointMake(34.25, 19.12) controlPoint1: CGPointMake(34.62, 19.29) controlPoint2: CGPointMake(34.49, 19.26)];
                        [bezier9Path addCurveToPoint: CGPointMake(32.52, 19.12) controlPoint1: CGPointMake(33.87, 19.16) controlPoint2: CGPointMake(33.34, 19.12)];
                        [bezier9Path addLineToPoint: CGPointMake(27.91, 19.12)];
                        [bezier9Path addCurveToPoint: CGPointMake(27.91, 19.12) controlPoint1: CGPointMake(27.87, 19.12) controlPoint2: CGPointMake(27.76, 19.15)];
                        [bezier9Path addCurveToPoint: CGPointMake(27.34, 19.71) controlPoint1: CGPointMake(27.43, 19.31) controlPoint2: CGPointMake(27.27, 19.53)];
                        [bezier9Path addLineToPoint: CGPointMake(26.18, 26.76)];
                        [bezier9Path addLineToPoint: CGPointMake(26.18, 26.76)];
                        [bezier9Path addCurveToPoint: CGPointMake(26.76, 26.18) controlPoint1: CGPointMake(26.25, 26.32) controlPoint2: CGPointMake(26.61, 25.99)];
                        [bezier9Path addLineToPoint: CGPointMake(29.06, 26.18)];
                        [bezier9Path addCurveToPoint: CGPointMake(35.98, 20.29) controlPoint1: CGPointMake(32.35, 25.99) controlPoint2: CGPointMake(35.11, 24.49)];
                        [bezier9Path addCurveToPoint: CGPointMake(35.98, 19.71) controlPoint1: CGPointMake(35.94, 20.02) controlPoint2: CGPointMake(35.96, 19.9)];
                        [bezier9Path addCurveToPoint: CGPointMake(35.4, 19.71) controlPoint1: CGPointMake(35.77, 19.66) controlPoint2: CGPointMake(35.55, 19.56)];
                        [bezier9Path addCurveToPoint: CGPointMake(35.4, 19.71) controlPoint1: CGPointMake(35.25, 19.46) controlPoint2: CGPointMake(35.19, 19.44)];
                        [bezier9Path closePath];
                        bezier9Path.miterLimit = 4;
                        
                        bezier9Path.usesEvenOddFillRule = YES;
                        
                        [color3 setFill];
                        [bezier9Path fill];
                    }
                }
                
                
                //// Rectangle Drawing
                CGRect rectangleRect = CGRectMake(106, 15, 79, 32);
                NSMutableParagraphStyle* rectangleStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                [rectangleStyle setAlignment: NSTextAlignmentLeft];
                
                NSDictionary* rectangleFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Bold" size: 16], NSForegroundColorAttributeName: color1, NSParagraphStyleAttributeName: rectangleStyle};
                
                [@"Check out" drawInRect: rectangleRect withAttributes: rectangleFontAttributes];
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
