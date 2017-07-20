#import "BTUIMaestroVectorArtView.h"

@implementation BTUIMaestroVectorArtView

- (void)drawArt {
    //// Color Declarations
    UIColor* color3 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* color1 = [UIColor colorWithRed: 0.067 green: 0.541 blue: 0.834 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.899 green: 0 blue: 0.139 alpha: 1];

    //// Page-1
    {
        //// Maestro
        {
            //// Shape
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(43.91, 40.1)];
                [bezierPath addCurveToPoint: CGPointMake(49.5, 27.5) controlPoint1: CGPointMake(47.34, 36.99) controlPoint2: CGPointMake(49.5, 32.5)];
                [bezierPath addCurveToPoint: CGPointMake(43.91, 14.9) controlPoint1: CGPointMake(49.5, 22.5) controlPoint2: CGPointMake(47.34, 18.01)];
                [bezierPath addCurveToPoint: CGPointMake(32.5, 10.5) controlPoint1: CGPointMake(40.89, 12.17) controlPoint2: CGPointMake(36.89, 10.5)];
                [bezierPath addCurveToPoint: CGPointMake(15.5, 27.5) controlPoint1: CGPointMake(23.11, 10.5) controlPoint2: CGPointMake(15.5, 18.11)];
                [bezierPath addCurveToPoint: CGPointMake(32.5, 44.5) controlPoint1: CGPointMake(15.5, 36.89) controlPoint2: CGPointMake(23.11, 44.5)];
                [bezierPath addCurveToPoint: CGPointMake(43.91, 40.1) controlPoint1: CGPointMake(36.89, 44.5) controlPoint2: CGPointMake(40.89, 42.83)];
                [bezierPath addLineToPoint: CGPointMake(43.91, 40.1)];
                [bezierPath addLineToPoint: CGPointMake(43.91, 40.1)];
                [bezierPath addLineToPoint: CGPointMake(43.91, 40.1)];
                [bezierPath addLineToPoint: CGPointMake(43.91, 40.1)];
                [bezierPath closePath];
                bezierPath.miterLimit = 4;

                bezierPath.usesEvenOddFillRule = YES;

                [color1 setFill];
                [bezierPath fill];


                //// Bezier 2 Drawing
                UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
                [bezier2Path moveToPoint: CGPointMake(54.81, 11)];
                [bezier2Path addCurveToPoint: CGPointMake(43.27, 15.4) controlPoint1: CGPointMake(50.36, 11) controlPoint2: CGPointMake(46.32, 12.67)];
                [bezier2Path addCurveToPoint: CGPointMake(41.53, 17.2) controlPoint1: CGPointMake(42.64, 15.96) controlPoint2: CGPointMake(42.06, 16.56)];
                [bezier2Path addLineToPoint: CGPointMake(45, 17.2)];
                [bezier2Path addCurveToPoint: CGPointMake(46.31, 19) controlPoint1: CGPointMake(45.48, 17.77) controlPoint2: CGPointMake(45.91, 18.37)];
                [bezier2Path addLineToPoint: CGPointMake(40.22, 19)];
                [bezier2Path addCurveToPoint: CGPointMake(39.23, 20.8) controlPoint1: CGPointMake(39.85, 19.58) controlPoint2: CGPointMake(39.52, 20.18)];
                [bezier2Path addLineToPoint: CGPointMake(47.3, 20.8)];
                [bezier2Path addCurveToPoint: CGPointMake(48.03, 22.6) controlPoint1: CGPointMake(47.58, 21.38) controlPoint2: CGPointMake(47.82, 21.98)];
                [bezier2Path addLineToPoint: CGPointMake(38.5, 22.6)];
                [bezier2Path addCurveToPoint: CGPointMake(38, 24.4) controlPoint1: CGPointMake(38.3, 23.19) controlPoint2: CGPointMake(38.13, 23.79)];
                [bezier2Path addLineToPoint: CGPointMake(48.53, 24.4)];
                [bezier2Path addCurveToPoint: CGPointMake(48.92, 28) controlPoint1: CGPointMake(48.78, 25.56) controlPoint2: CGPointMake(48.92, 26.76)];
                [bezier2Path addCurveToPoint: CGPointMake(48.03, 33.4) controlPoint1: CGPointMake(48.92, 29.89) controlPoint2: CGPointMake(48.61, 31.7)];
                [bezier2Path addLineToPoint: CGPointMake(38.5, 33.4)];
                [bezier2Path addCurveToPoint: CGPointMake(39.23, 35.2) controlPoint1: CGPointMake(38.71, 34.02) controlPoint2: CGPointMake(38.95, 34.62)];
                [bezier2Path addLineToPoint: CGPointMake(47.3, 35.2)];
                [bezier2Path addCurveToPoint: CGPointMake(46.31, 37) controlPoint1: CGPointMake(47.01, 35.82) controlPoint2: CGPointMake(46.68, 36.42)];
                [bezier2Path addLineToPoint: CGPointMake(40.22, 37)];
                [bezier2Path addCurveToPoint: CGPointMake(41.53, 38.8) controlPoint1: CGPointMake(40.62, 37.63) controlPoint2: CGPointMake(41.05, 38.23)];
                [bezier2Path addLineToPoint: CGPointMake(45, 38.8)];
                [bezier2Path addCurveToPoint: CGPointMake(43.27, 40.6) controlPoint1: CGPointMake(44.47, 39.44) controlPoint2: CGPointMake(43.89, 40.04)];
                [bezier2Path addCurveToPoint: CGPointMake(54.81, 45) controlPoint1: CGPointMake(46.32, 43.33) controlPoint2: CGPointMake(50.36, 45)];
                [bezier2Path addCurveToPoint: CGPointMake(72, 28) controlPoint1: CGPointMake(64.3, 45) controlPoint2: CGPointMake(72, 37.39)];
                [bezier2Path addCurveToPoint: CGPointMake(54.81, 11) controlPoint1: CGPointMake(72, 18.61) controlPoint2: CGPointMake(64.3, 11)];
                [bezier2Path addLineToPoint: CGPointMake(54.81, 11)];
                [bezier2Path addLineToPoint: CGPointMake(54.81, 11)];
                [bezier2Path addLineToPoint: CGPointMake(54.81, 11)];
                [bezier2Path addLineToPoint: CGPointMake(54.81, 11)];
                [bezier2Path closePath];
                bezier2Path.miterLimit = 4;

                bezier2Path.usesEvenOddFillRule = YES;

                [color2 setFill];
                [bezier2Path fill];


                //// Bezier 3 Drawing
                UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
                [bezier3Path moveToPoint: CGPointMake(30.6, 32.21)];
                [bezier3Path addLineToPoint: CGPointMake(28.45, 32.21)];
                [bezier3Path addLineToPoint: CGPointMake(29.73, 25.44)];
                [bezier3Path addLineToPoint: CGPointMake(26.79, 32.21)];
                [bezier3Path addLineToPoint: CGPointMake(24.83, 32.21)];
                [bezier3Path addLineToPoint: CGPointMake(24.47, 25.48)];
                [bezier3Path addLineToPoint: CGPointMake(23.19, 32.21)];
                [bezier3Path addLineToPoint: CGPointMake(21.24, 32.21)];
                [bezier3Path addLineToPoint: CGPointMake(22.91, 23.4)];
                [bezier3Path addLineToPoint: CGPointMake(26.26, 23.4)];
                [bezier3Path addLineToPoint: CGPointMake(26.44, 28.85)];
                [bezier3Path addLineToPoint: CGPointMake(28.8, 23.4)];
                [bezier3Path addLineToPoint: CGPointMake(32.29, 23.4)];
                [bezier3Path addLineToPoint: CGPointMake(30.6, 32.21)];
                [bezier3Path addLineToPoint: CGPointMake(30.6, 32.21)];
                [bezier3Path closePath];
                bezier3Path.miterLimit = 4;

                bezier3Path.usesEvenOddFillRule = YES;

                [color3 setFill];
                [bezier3Path fill];


                //// Bezier 4 Drawing
                UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
                [bezier4Path moveToPoint: CGPointMake(54.6, 32.12)];
                [bezier4Path addCurveToPoint: CGPointMake(53.06, 32.36) controlPoint1: CGPointMake(54.01, 32.29) controlPoint2: CGPointMake(53.55, 32.36)];
                [bezier4Path addCurveToPoint: CGPointMake(51.36, 30.78) controlPoint1: CGPointMake(51.96, 32.36) controlPoint2: CGPointMake(51.36, 31.8)];
                [bezier4Path addCurveToPoint: CGPointMake(51.42, 30.14) controlPoint1: CGPointMake(51.36, 30.58) controlPoint2: CGPointMake(51.38, 30.37)];
                [bezier4Path addLineToPoint: CGPointMake(51.55, 29.44)];
                [bezier4Path addLineToPoint: CGPointMake(51.65, 28.87)];
                [bezier4Path addLineToPoint: CGPointMake(52.65, 23.4)];
                [bezier4Path addLineToPoint: CGPointMake(54.78, 23.4)];
                [bezier4Path addLineToPoint: CGPointMake(54.47, 25.04)];
                [bezier4Path addLineToPoint: CGPointMake(55.57, 25.04)];
                [bezier4Path addLineToPoint: CGPointMake(55.27, 26.79)];
                [bezier4Path addLineToPoint: CGPointMake(54.17, 26.79)];
                [bezier4Path addLineToPoint: CGPointMake(53.61, 29.78)];
                [bezier4Path addCurveToPoint: CGPointMake(53.57, 30.07) controlPoint1: CGPointMake(53.58, 29.91) controlPoint2: CGPointMake(53.57, 30.01)];
                [bezier4Path addCurveToPoint: CGPointMake(54.3, 30.61) controlPoint1: CGPointMake(53.57, 30.44) controlPoint2: CGPointMake(53.79, 30.61)];
                [bezier4Path addCurveToPoint: CGPointMake(54.88, 30.54) controlPoint1: CGPointMake(54.55, 30.61) controlPoint2: CGPointMake(54.74, 30.58)];
                [bezier4Path addLineToPoint: CGPointMake(54.6, 32.12)];
                [bezier4Path addLineToPoint: CGPointMake(54.6, 32.12)];
                [bezier4Path addLineToPoint: CGPointMake(54.6, 32.12)];
                [bezier4Path addLineToPoint: CGPointMake(54.6, 32.12)];
                [bezier4Path closePath];
                bezier4Path.miterLimit = 4;

                bezier4Path.usesEvenOddFillRule = YES;

                [color3 setFill];
                [bezier4Path fill];


                //// Bezier 5 Drawing
                UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
                [bezier5Path moveToPoint: CGPointMake(60.87, 25.1)];
                [bezier5Path addCurveToPoint: CGPointMake(60.63, 25.03) controlPoint1: CGPointMake(60.69, 25.03) controlPoint2: CGPointMake(60.65, 25.03)];
                [bezier5Path addCurveToPoint: CGPointMake(60.44, 24.98) controlPoint1: CGPointMake(60.51, 25) controlPoint2: CGPointMake(60.45, 24.99)];
                [bezier5Path addCurveToPoint: CGPointMake(60.23, 24.97) controlPoint1: CGPointMake(60.38, 24.97) controlPoint2: CGPointMake(60.31, 24.97)];
                [bezier5Path addCurveToPoint: CGPointMake(58.36, 26.13) controlPoint1: CGPointMake(59.52, 24.97) controlPoint2: CGPointMake(59.01, 25.28)];
                [bezier5Path addLineToPoint: CGPointMake(58.55, 25.04)];
                [bezier5Path addLineToPoint: CGPointMake(56.6, 25.04)];
                [bezier5Path addLineToPoint: CGPointMake(55.29, 32.21)];
                [bezier5Path addLineToPoint: CGPointMake(57.44, 32.21)];
                [bezier5Path addCurveToPoint: CGPointMake(59.57, 27.06) controlPoint1: CGPointMake(58.21, 27.83) controlPoint2: CGPointMake(58.54, 27.06)];
                [bezier5Path addCurveToPoint: CGPointMake(59.84, 27.08) controlPoint1: CGPointMake(59.65, 27.06) controlPoint2: CGPointMake(59.74, 27.07)];
                [bezier5Path addLineToPoint: CGPointMake(60.09, 27.13)];
                [bezier5Path addLineToPoint: CGPointMake(60.87, 25.1)];
                [bezier5Path addLineToPoint: CGPointMake(60.87, 25.1)];
                [bezier5Path addLineToPoint: CGPointMake(60.87, 25.1)];
                [bezier5Path addLineToPoint: CGPointMake(60.87, 25.1)];
                [bezier5Path closePath];
                bezier5Path.miterLimit = 4;

                bezier5Path.usesEvenOddFillRule = YES;

                [color3 setFill];
                [bezier5Path fill];


                //// Bezier 6 Drawing
                UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
                [bezier6Path moveToPoint: CGPointMake(46.09, 27.31)];
                [bezier6Path addCurveToPoint: CGPointMake(47.74, 29.31) controlPoint1: CGPointMake(46.09, 28.21) controlPoint2: CGPointMake(46.59, 28.84)];
                [bezier6Path addCurveToPoint: CGPointMake(48.76, 30.1) controlPoint1: CGPointMake(48.62, 29.67) controlPoint2: CGPointMake(48.76, 29.77)];
                [bezier6Path addCurveToPoint: CGPointMake(47.51, 30.75) controlPoint1: CGPointMake(48.76, 30.54) controlPoint2: CGPointMake(48.37, 30.75)];
                [bezier6Path addCurveToPoint: CGPointMake(45.56, 30.46) controlPoint1: CGPointMake(46.86, 30.75) controlPoint2: CGPointMake(46.26, 30.66)];
                [bezier6Path addLineToPoint: CGPointMake(45.26, 32.11)];
                [bezier6Path addLineToPoint: CGPointMake(45.36, 32.13)];
                [bezier6Path addLineToPoint: CGPointMake(45.76, 32.2)];
                [bezier6Path addCurveToPoint: CGPointMake(46.33, 32.27) controlPoint1: CGPointMake(45.89, 32.23) controlPoint2: CGPointMake(46.08, 32.25)];
                [bezier6Path addCurveToPoint: CGPointMake(47.52, 32.33) controlPoint1: CGPointMake(46.84, 32.31) controlPoint2: CGPointMake(47.24, 32.33)];
                [bezier6Path addCurveToPoint: CGPointMake(50.88, 29.93) controlPoint1: CGPointMake(49.82, 32.33) controlPoint2: CGPointMake(50.88, 31.57)];
                [bezier6Path addCurveToPoint: CGPointMake(49.34, 27.94) controlPoint1: CGPointMake(50.88, 28.95) controlPoint2: CGPointMake(50.43, 28.37)];
                [bezier6Path addCurveToPoint: CGPointMake(48.33, 27.16) controlPoint1: CGPointMake(48.43, 27.58) controlPoint2: CGPointMake(48.33, 27.5)];
                [bezier6Path addCurveToPoint: CGPointMake(49.39, 26.58) controlPoint1: CGPointMake(48.33, 26.78) controlPoint2: CGPointMake(48.69, 26.58)];
                [bezier6Path addCurveToPoint: CGPointMake(50.95, 26.68) controlPoint1: CGPointMake(49.82, 26.58) controlPoint2: CGPointMake(50.4, 26.62)];
                [bezier6Path addLineToPoint: CGPointMake(51.26, 25.03)];
                [bezier6Path addCurveToPoint: CGPointMake(49.35, 24.89) controlPoint1: CGPointMake(50.7, 24.95) controlPoint2: CGPointMake(49.85, 24.89)];
                [bezier6Path addCurveToPoint: CGPointMake(46.09, 27.31) controlPoint1: CGPointMake(46.92, 24.89) controlPoint2: CGPointMake(46.08, 25.99)];
                [bezier6Path addLineToPoint: CGPointMake(46.09, 27.31)];
                [bezier6Path addLineToPoint: CGPointMake(46.09, 27.31)];
                [bezier6Path addLineToPoint: CGPointMake(46.09, 27.31)];
                [bezier6Path addLineToPoint: CGPointMake(46.09, 27.31)];
                [bezier6Path closePath];
                bezier6Path.miterLimit = 4;

                bezier6Path.usesEvenOddFillRule = YES;

                [color3 setFill];
                [bezier6Path fill];


                //// Bezier 7 Drawing
                UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
                [bezier7Path moveToPoint: CGPointMake(37.58, 32.21)];
                [bezier7Path addLineToPoint: CGPointMake(35.8, 32.21)];
                [bezier7Path addLineToPoint: CGPointMake(35.84, 31.47)];
                [bezier7Path addCurveToPoint: CGPointMake(33.58, 32.34) controlPoint1: CGPointMake(35.29, 32.06) controlPoint2: CGPointMake(34.57, 32.34)];
                [bezier7Path addCurveToPoint: CGPointMake(31.62, 30.38) controlPoint1: CGPointMake(32.42, 32.34) controlPoint2: CGPointMake(31.62, 31.54)];
                [bezier7Path addCurveToPoint: CGPointMake(35.39, 27.61) controlPoint1: CGPointMake(31.62, 28.63) controlPoint2: CGPointMake(33.01, 27.61)];
                [bezier7Path addCurveToPoint: CGPointMake(36.27, 27.67) controlPoint1: CGPointMake(35.64, 27.61) controlPoint2: CGPointMake(35.95, 27.63)];
                [bezier7Path addCurveToPoint: CGPointMake(36.35, 27.2) controlPoint1: CGPointMake(36.34, 27.43) controlPoint2: CGPointMake(36.35, 27.33)];
                [bezier7Path addCurveToPoint: CGPointMake(34.98, 26.55) controlPoint1: CGPointMake(36.35, 26.73) controlPoint2: CGPointMake(35.98, 26.55)];
                [bezier7Path addCurveToPoint: CGPointMake(33.19, 26.75) controlPoint1: CGPointMake(34.36, 26.55) controlPoint2: CGPointMake(33.67, 26.63)];
                [bezier7Path addLineToPoint: CGPointMake(32.89, 26.83)];
                [bezier7Path addLineToPoint: CGPointMake(32.7, 26.87)];
                [bezier7Path addLineToPoint: CGPointMake(33, 25.26)];
                [bezier7Path addCurveToPoint: CGPointMake(35.57, 24.88) controlPoint1: CGPointMake(34.07, 24.99) controlPoint2: CGPointMake(34.78, 24.88)];
                [bezier7Path addCurveToPoint: CGPointMake(38.39, 26.98) controlPoint1: CGPointMake(37.42, 24.88) controlPoint2: CGPointMake(38.39, 25.61)];
                [bezier7Path addCurveToPoint: CGPointMake(38.22, 28.4) controlPoint1: CGPointMake(38.39, 27.34) controlPoint2: CGPointMake(38.36, 27.61)];
                [bezier7Path addLineToPoint: CGPointMake(37.77, 30.95)];
                [bezier7Path addLineToPoint: CGPointMake(37.69, 31.4)];
                [bezier7Path addLineToPoint: CGPointMake(37.64, 31.77)];
                [bezier7Path addLineToPoint: CGPointMake(37.6, 32.02)];
                [bezier7Path addLineToPoint: CGPointMake(37.58, 32.21)];
                [bezier7Path addLineToPoint: CGPointMake(37.58, 32.21)];
                [bezier7Path addLineToPoint: CGPointMake(37.58, 32.21)];
                [bezier7Path addLineToPoint: CGPointMake(37.58, 32.21)];
                [bezier7Path closePath];
                [bezier7Path moveToPoint: CGPointMake(36.01, 29.02)];
                [bezier7Path addCurveToPoint: CGPointMake(35.53, 28.99) controlPoint1: CGPointMake(35.79, 28.99) controlPoint2: CGPointMake(35.69, 28.99)];
                [bezier7Path addCurveToPoint: CGPointMake(33.7, 30.08) controlPoint1: CGPointMake(34.32, 28.99) controlPoint2: CGPointMake(33.7, 29.36)];
                [bezier7Path addCurveToPoint: CGPointMake(34.47, 30.81) controlPoint1: CGPointMake(33.7, 30.53) controlPoint2: CGPointMake(34, 30.81)];
                [bezier7Path addCurveToPoint: CGPointMake(36.01, 29.02) controlPoint1: CGPointMake(35.35, 30.81) controlPoint2: CGPointMake(35.98, 30.08)];
                [bezier7Path addLineToPoint: CGPointMake(36.01, 29.02)];
                [bezier7Path addLineToPoint: CGPointMake(36.01, 29.02)];
                [bezier7Path addLineToPoint: CGPointMake(36.01, 29.02)];
                [bezier7Path addLineToPoint: CGPointMake(36.01, 29.02)];
                [bezier7Path closePath];
                bezier7Path.miterLimit = 4;

                bezier7Path.usesEvenOddFillRule = YES;

                [color3 setFill];
                [bezier7Path fill];


                //// Bezier 8 Drawing
                UIBezierPath* bezier8Path = [UIBezierPath bezierPath];
                [bezier8Path moveToPoint: CGPointMake(44.63, 32.06)];
                [bezier8Path addCurveToPoint: CGPointMake(42.43, 32.35) controlPoint1: CGPointMake(43.89, 32.25) controlPoint2: CGPointMake(43.18, 32.35)];
                [bezier8Path addCurveToPoint: CGPointMake(38.77, 29.14) controlPoint1: CGPointMake(40.02, 32.35) controlPoint2: CGPointMake(38.77, 31.24)];
                [bezier8Path addCurveToPoint: CGPointMake(42.53, 24.86) controlPoint1: CGPointMake(38.77, 26.68) controlPoint2: CGPointMake(40.36, 24.86)];
                [bezier8Path addCurveToPoint: CGPointMake(45.42, 27.47) controlPoint1: CGPointMake(44.29, 24.86) controlPoint2: CGPointMake(45.42, 25.88)];
                [bezier8Path addCurveToPoint: CGPointMake(45.16, 29.24) controlPoint1: CGPointMake(45.42, 28) controlPoint2: CGPointMake(45.35, 28.51)];
                [bezier8Path addLineToPoint: CGPointMake(40.89, 29.24)];
                [bezier8Path addCurveToPoint: CGPointMake(40.87, 29.47) controlPoint1: CGPointMake(40.87, 29.35) controlPoint2: CGPointMake(40.87, 29.4)];
                [bezier8Path addCurveToPoint: CGPointMake(42.75, 30.72) controlPoint1: CGPointMake(40.87, 30.3) controlPoint2: CGPointMake(41.5, 30.72)];
                [bezier8Path addCurveToPoint: CGPointMake(44.98, 30.27) controlPoint1: CGPointMake(43.52, 30.72) controlPoint2: CGPointMake(44.21, 30.58)];
                [bezier8Path addLineToPoint: CGPointMake(44.63, 32.06)];
                [bezier8Path addLineToPoint: CGPointMake(44.63, 32.06)];
                [bezier8Path addLineToPoint: CGPointMake(44.63, 32.06)];
                [bezier8Path addLineToPoint: CGPointMake(44.63, 32.06)];
                [bezier8Path closePath];
                [bezier8Path moveToPoint: CGPointMake(43.48, 27.79)];
                [bezier8Path addCurveToPoint: CGPointMake(43.5, 27.43) controlPoint1: CGPointMake(43.49, 27.64) controlPoint2: CGPointMake(43.5, 27.52)];
                [bezier8Path addCurveToPoint: CGPointMake(42.48, 26.5) controlPoint1: CGPointMake(43.5, 26.84) controlPoint2: CGPointMake(43.12, 26.5)];
                [bezier8Path addCurveToPoint: CGPointMake(41.11, 27.79) controlPoint1: CGPointMake(41.8, 26.5) controlPoint2: CGPointMake(41.31, 26.96)];
                [bezier8Path addLineToPoint: CGPointMake(43.48, 27.79)];
                [bezier8Path addLineToPoint: CGPointMake(43.48, 27.79)];
                [bezier8Path addLineToPoint: CGPointMake(43.48, 27.79)];
                [bezier8Path addLineToPoint: CGPointMake(43.48, 27.79)];
                [bezier8Path closePath];
                bezier8Path.miterLimit = 4;

                bezier8Path.usesEvenOddFillRule = YES;

                [color3 setFill];
                [bezier8Path fill];


                //// Bezier 9 Drawing
                UIBezierPath* bezier9Path = [UIBezierPath bezierPath];
                [bezier9Path moveToPoint: CGPointMake(67.55, 28.96)];
                [bezier9Path addCurveToPoint: CGPointMake(63.38, 32.4) controlPoint1: CGPointMake(67.23, 31.35) controlPoint2: CGPointMake(65.57, 32.4)];
                [bezier9Path addCurveToPoint: CGPointMake(59.96, 29.1) controlPoint1: CGPointMake(60.95, 32.4) controlPoint2: CGPointMake(59.96, 30.92)];
                [bezier9Path addCurveToPoint: CGPointMake(64.19, 24.84) controlPoint1: CGPointMake(59.96, 26.56) controlPoint2: CGPointMake(61.63, 24.84)];
                [bezier9Path addCurveToPoint: CGPointMake(67.6, 28.07) controlPoint1: CGPointMake(66.42, 24.84) controlPoint2: CGPointMake(67.6, 26.25)];
                [bezier9Path addCurveToPoint: CGPointMake(67.55, 28.96) controlPoint1: CGPointMake(67.6, 28.52) controlPoint2: CGPointMake(67.6, 28.55)];
                [bezier9Path addLineToPoint: CGPointMake(67.55, 28.96)];
                [bezier9Path addLineToPoint: CGPointMake(67.55, 28.96)];
                [bezier9Path addLineToPoint: CGPointMake(67.55, 28.96)];
                [bezier9Path addLineToPoint: CGPointMake(67.55, 28.96)];
                [bezier9Path closePath];
                [bezier9Path moveToPoint: CGPointMake(65.33, 28.05)];
                [bezier9Path addCurveToPoint: CGPointMake(64.15, 26.59) controlPoint1: CGPointMake(65.33, 27.3) controlPoint2: CGPointMake(65.03, 26.59)];
                [bezier9Path addCurveToPoint: CGPointMake(62.38, 29.04) controlPoint1: CGPointMake(63.06, 26.59) controlPoint2: CGPointMake(62.38, 27.89)];
                [bezier9Path addCurveToPoint: CGPointMake(63.61, 30.66) controlPoint1: CGPointMake(62.38, 30.02) controlPoint2: CGPointMake(62.84, 30.67)];
                [bezier9Path addCurveToPoint: CGPointMake(65.26, 28.9) controlPoint1: CGPointMake(64.08, 30.66) controlPoint2: CGPointMake(65.07, 30.02)];
                [bezier9Path addCurveToPoint: CGPointMake(65.33, 28.05) controlPoint1: CGPointMake(65.31, 28.64) controlPoint2: CGPointMake(65.33, 28.35)];
                [bezier9Path addLineToPoint: CGPointMake(65.33, 28.05)];
                [bezier9Path addLineToPoint: CGPointMake(65.33, 28.05)];
                [bezier9Path addLineToPoint: CGPointMake(65.33, 28.05)];
                [bezier9Path addLineToPoint: CGPointMake(65.33, 28.05)];
                [bezier9Path closePath];
                bezier9Path.miterLimit = 4;
                
                bezier9Path.usesEvenOddFillRule = YES;
                
                [color3 setFill];
                [bezier9Path fill];
            }
        }
    }
}
@end
