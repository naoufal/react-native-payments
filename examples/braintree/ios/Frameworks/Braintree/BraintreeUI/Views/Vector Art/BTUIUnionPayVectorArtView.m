#import "BTUIUnionPayVectorArtView.h"

@implementation BTUIUnionPayVectorArtView

- (void)drawArt {
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0 green: 0.616 blue: 0.647 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 0 green: 0.447 blue: 0.737 alpha: 1];
    UIColor* color4 = [UIColor colorWithRed: 0.929 green: 0.11 blue: 0.141 alpha: 1];

    //// Group
    {
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
        [bezier4Path moveToPoint: CGPointMake(27.72, 43.3)];
        [bezier4Path addLineToPoint: CGPointMake(34.69, 12.7)];
        [bezier4Path addCurveToPoint: CGPointMake(39.74, 9.03) controlPoint1: CGPointMake(35.15, 10.69) controlPoint2: CGPointMake(37.71, 9.07)];
        [bezier4Path addLineToPoint: CGPointMake(26.2, 9.03)];
        [bezier4Path addCurveToPoint: CGPointMake(21.08, 12.7) controlPoint1: CGPointMake(24.15, 9.03) controlPoint2: CGPointMake(21.53, 10.66)];
        [bezier4Path addLineToPoint: CGPointMake(14.11, 43.3)];
        [bezier4Path addCurveToPoint: CGPointMake(14.03, 43.86) controlPoint1: CGPointMake(14.06, 43.48) controlPoint2: CGPointMake(14.03, 43.68)];
        [bezier4Path addLineToPoint: CGPointMake(14.03, 44.44)];
        [bezier4Path addCurveToPoint: CGPointMake(16.92, 47) controlPoint1: CGPointMake(14.16, 45.89) controlPoint2: CGPointMake(15.3, 46.97)];
        [bezier4Path addLineToPoint: CGPointMake(30.53, 47)];
        [bezier4Path addCurveToPoint: CGPointMake(27.72, 43.3) controlPoint1: CGPointMake(28.53, 46.95) controlPoint2: CGPointMake(27.27, 45.31)];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;

        [color4 setFill];
        [bezier4Path fill];


        //// Bezier 5 Drawing
        UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
        [bezier5Path moveToPoint: CGPointMake(50.34, 9.03)];
        [bezier5Path addLineToPoint: CGPointMake(39.84, 9.03)];
        [bezier5Path addCurveToPoint: CGPointMake(39.76, 9.03) controlPoint1: CGPointMake(39.81, 9.03) controlPoint2: CGPointMake(39.79, 9.03)];
        [bezier5Path addLineToPoint: CGPointMake(50.34, 9.03)];
        [bezier5Path closePath];
        bezier5Path.miterLimit = 4;

        [[UIColor blackColor] setFill];
        [bezier5Path fill];


        //// Bezier 6 Drawing
        UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
        [bezier6Path moveToPoint: CGPointMake(44.2, 43.3)];
        [bezier6Path addLineToPoint: CGPointMake(51.17, 12.7)];
        [bezier6Path addCurveToPoint: CGPointMake(56.19, 9.03) controlPoint1: CGPointMake(51.63, 10.71) controlPoint2: CGPointMake(54.16, 9.1)];
        [bezier6Path addLineToPoint: CGPointMake(50.34, 9.03)];
        [bezier6Path addLineToPoint: CGPointMake(39.76, 9.03)];
        [bezier6Path addCurveToPoint: CGPointMake(34.72, 12.7) controlPoint1: CGPointMake(37.74, 9.07) controlPoint2: CGPointMake(35.18, 10.69)];
        [bezier6Path addLineToPoint: CGPointMake(27.75, 43.3)];
        [bezier6Path addCurveToPoint: CGPointMake(30.56, 46.97) controlPoint1: CGPointMake(27.29, 45.31) controlPoint2: CGPointMake(28.54, 46.95)];
        [bezier6Path addLineToPoint: CGPointMake(47.04, 46.97)];
        [bezier6Path addCurveToPoint: CGPointMake(44.2, 43.3) controlPoint1: CGPointMake(45.01, 46.95) controlPoint2: CGPointMake(43.74, 45.31)];
        [bezier6Path closePath];
        bezier6Path.miterLimit = 4;

        [color3 setFill];
        [bezier6Path fill];


        //// Bezier 7 Drawing
        UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
        [bezier7Path moveToPoint: CGPointMake(70.99, 9.03)];
        [bezier7Path addLineToPoint: CGPointMake(56.24, 9.03)];
        [bezier7Path addLineToPoint: CGPointMake(56.24, 9.03)];
        [bezier7Path addLineToPoint: CGPointMake(56.21, 9.03)];
        [bezier7Path addCurveToPoint: CGPointMake(51.19, 12.7) controlPoint1: CGPointMake(54.18, 9.07) controlPoint2: CGPointMake(51.65, 10.71)];
        [bezier7Path addLineToPoint: CGPointMake(44.22, 43.3)];
        [bezier7Path addCurveToPoint: CGPointMake(47.03, 46.97) controlPoint1: CGPointMake(43.76, 45.31) controlPoint2: CGPointMake(45.01, 46.95)];
        [bezier7Path addLineToPoint: CGPointMake(49.04, 46.97)];
        [bezier7Path addLineToPoint: CGPointMake(58.19, 46.97)];
        [bezier7Path addLineToPoint: CGPointMake(62.55, 46.97)];
        [bezier7Path addCurveToPoint: CGPointMake(66.91, 43.33) controlPoint1: CGPointMake(64.53, 46.87) controlPoint2: CGPointMake(66.45, 45.29)];
        [bezier7Path addLineToPoint: CGPointMake(73.88, 12.72)];
        [bezier7Path addCurveToPoint: CGPointMake(70.99, 9.03) controlPoint1: CGPointMake(74.31, 10.69) controlPoint2: CGPointMake(73.05, 9.03)];
        [bezier7Path closePath];
        bezier7Path.miterLimit = 4;

        [color2 setFill];
        [bezier7Path fill];


        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = [UIBezierPath bezierPath];
        [bezier8Path moveToPoint: CGPointMake(40.04, 31.34)];
        [bezier8Path addLineToPoint: CGPointMake(40.3, 31.34)];
        [bezier8Path addCurveToPoint: CGPointMake(40.75, 31.12) controlPoint1: CGPointMake(40.53, 31.34) controlPoint2: CGPointMake(40.7, 31.27)];
        [bezier8Path addLineToPoint: CGPointMake(41.41, 30.14)];
        [bezier8Path addLineToPoint: CGPointMake(43.19, 30.14)];
        [bezier8Path addLineToPoint: CGPointMake(42.81, 30.79)];
        [bezier8Path addLineToPoint: CGPointMake(44.93, 30.79)];
        [bezier8Path addLineToPoint: CGPointMake(44.66, 31.8)];
        [bezier8Path addLineToPoint: CGPointMake(42.12, 31.8)];
        [bezier8Path addCurveToPoint: CGPointMake(41.03, 32.42) controlPoint1: CGPointMake(41.81, 32.22) controlPoint2: CGPointMake(41.46, 32.45)];
        [bezier8Path addLineToPoint: CGPointMake(39.71, 32.42)];
        [bezier8Path addLineToPoint: CGPointMake(40.04, 31.34)];
        [bezier8Path closePath];
        [bezier8Path moveToPoint: CGPointMake(39.76, 32.78)];
        [bezier8Path addLineToPoint: CGPointMake(44.45, 32.78)];
        [bezier8Path addLineToPoint: CGPointMake(44.15, 33.86)];
        [bezier8Path addLineToPoint: CGPointMake(42.27, 33.86)];
        [bezier8Path addLineToPoint: CGPointMake(41.99, 34.91)];
        [bezier8Path addLineToPoint: CGPointMake(43.82, 34.91)];
        [bezier8Path addLineToPoint: CGPointMake(43.51, 35.99)];
        [bezier8Path addLineToPoint: CGPointMake(41.69, 35.99)];
        [bezier8Path addLineToPoint: CGPointMake(41.26, 37.52)];
        [bezier8Path addCurveToPoint: CGPointMake(41.66, 37.87) controlPoint1: CGPointMake(41.15, 37.77) controlPoint2: CGPointMake(41.28, 37.9)];
        [bezier8Path addLineToPoint: CGPointMake(43.16, 37.87)];
        [bezier8Path addLineToPoint: CGPointMake(42.88, 38.88)];
        [bezier8Path addLineToPoint: CGPointMake(40.02, 38.88)];
        [bezier8Path addCurveToPoint: CGPointMake(39.46, 37.95) controlPoint1: CGPointMake(39.48, 38.88) controlPoint2: CGPointMake(39.28, 38.57)];
        [bezier8Path addLineToPoint: CGPointMake(39.99, 35.98)];
        [bezier8Path addLineToPoint: CGPointMake(38.83, 35.98)];
        [bezier8Path addLineToPoint: CGPointMake(39.13, 34.91)];
        [bezier8Path addLineToPoint: CGPointMake(40.3, 34.91)];
        [bezier8Path addLineToPoint: CGPointMake(40.57, 33.85)];
        [bezier8Path addLineToPoint: CGPointMake(39.46, 33.85)];
        [bezier8Path addLineToPoint: CGPointMake(39.76, 32.78)];
        [bezier8Path closePath];
        [bezier8Path moveToPoint: CGPointMake(47.24, 30.11)];
        [bezier8Path addLineToPoint: CGPointMake(47.17, 30.74)];
        [bezier8Path addCurveToPoint: CGPointMake(48.87, 30.08) controlPoint1: CGPointMake(47.17, 30.74) controlPoint2: CGPointMake(48.05, 30.08)];
        [bezier8Path addLineToPoint: CGPointMake(51.83, 30.08)];
        [bezier8Path addLineToPoint: CGPointMake(50.69, 34.16)];
        [bezier8Path addCurveToPoint: CGPointMake(49.47, 34.86) controlPoint1: CGPointMake(50.59, 34.64) controlPoint2: CGPointMake(50.18, 34.86)];
        [bezier8Path addLineToPoint: CGPointMake(46.1, 34.86)];
        [bezier8Path addLineToPoint: CGPointMake(45.31, 37.73)];
        [bezier8Path addCurveToPoint: CGPointMake(45.49, 37.95) controlPoint1: CGPointMake(45.26, 37.88) controlPoint2: CGPointMake(45.34, 37.95)];
        [bezier8Path addLineToPoint: CGPointMake(46.15, 37.95)];
        [bezier8Path addLineToPoint: CGPointMake(45.9, 38.83)];
        [bezier8Path addLineToPoint: CGPointMake(44.25, 38.83)];
        [bezier8Path addCurveToPoint: CGPointMake(43.44, 38.25) controlPoint1: CGPointMake(43.62, 38.83) controlPoint2: CGPointMake(43.34, 38.63)];
        [bezier8Path addLineToPoint: CGPointMake(45.67, 30.11)];
        [bezier8Path addLineToPoint: CGPointMake(47.24, 30.11)];
        [bezier8Path closePath];
        [bezier8Path moveToPoint: CGPointMake(49.75, 31.27)];
        [bezier8Path addLineToPoint: CGPointMake(47.11, 31.27)];
        [bezier8Path addLineToPoint: CGPointMake(46.81, 32.38)];
        [bezier8Path addCurveToPoint: CGPointMake(47.97, 32.05) controlPoint1: CGPointMake(46.81, 32.38) controlPoint2: CGPointMake(47.24, 32.05)];
        [bezier8Path addCurveToPoint: CGPointMake(49.54, 32.05) controlPoint1: CGPointMake(48.71, 32.05) controlPoint2: CGPointMake(49.54, 32.05)];
        [bezier8Path addLineToPoint: CGPointMake(49.75, 31.27)];
        [bezier8Path closePath];
        [bezier8Path moveToPoint: CGPointMake(48.79, 33.81)];
        [bezier8Path addCurveToPoint: CGPointMake(49.11, 33.58) controlPoint1: CGPointMake(48.99, 33.83) controlPoint2: CGPointMake(49.09, 33.76)];
        [bezier8Path addLineToPoint: CGPointMake(49.27, 33)];
        [bezier8Path addLineToPoint: CGPointMake(46.6, 33)];
        [bezier8Path addLineToPoint: CGPointMake(46.37, 33.8)];
        [bezier8Path addLineToPoint: CGPointMake(48.79, 33.81)];
        [bezier8Path addLineToPoint: CGPointMake(48.79, 33.81)];
        [bezier8Path closePath];
        [bezier8Path moveToPoint: CGPointMake(46.99, 35.11)];
        [bezier8Path addLineToPoint: CGPointMake(48.51, 35.11)];
        [bezier8Path addLineToPoint: CGPointMake(48.48, 35.77)];
        [bezier8Path addLineToPoint: CGPointMake(48.89, 35.77)];
        [bezier8Path addCurveToPoint: CGPointMake(49.2, 35.57) controlPoint1: CGPointMake(49.1, 35.77) controlPoint2: CGPointMake(49.2, 35.69)];
        [bezier8Path addLineToPoint: CGPointMake(49.33, 35.14)];
        [bezier8Path addLineToPoint: CGPointMake(50.59, 35.14)];
        [bezier8Path addLineToPoint: CGPointMake(50.41, 35.77)];
        [bezier8Path addCurveToPoint: CGPointMake(49.27, 36.57) controlPoint1: CGPointMake(50.26, 36.29) controlPoint2: CGPointMake(49.88, 36.55)];
        [bezier8Path addLineToPoint: CGPointMake(48.46, 36.57)];
        [bezier8Path addLineToPoint: CGPointMake(48.46, 37.7)];
        [bezier8Path addCurveToPoint: CGPointMake(48.94, 37.98) controlPoint1: CGPointMake(48.44, 37.88) controlPoint2: CGPointMake(48.61, 37.98)];
        [bezier8Path addLineToPoint: CGPointMake(49.71, 37.98)];
        [bezier8Path addLineToPoint: CGPointMake(49.45, 38.86)];
        [bezier8Path addLineToPoint: CGPointMake(47.63, 38.86)];
        [bezier8Path addCurveToPoint: CGPointMake(46.87, 38.13) controlPoint1: CGPointMake(47.12, 38.88) controlPoint2: CGPointMake(46.87, 38.63)];
        [bezier8Path addLineToPoint: CGPointMake(46.99, 35.11)];
        [bezier8Path closePath];
        bezier8Path.miterLimit = 4;

        [color setFill];
        [bezier8Path fill];


        //// Bezier 9 Drawing
        UIBezierPath* bezier9Path = [UIBezierPath bezierPath];
        [bezier9Path moveToPoint: CGPointMake(53.5, 31.39)];
        [bezier9Path addLineToPoint: CGPointMake(53.86, 30.16)];
        [bezier9Path addLineToPoint: CGPointMake(55.66, 30.16)];
        [bezier9Path addLineToPoint: CGPointMake(55.58, 30.61)];
        [bezier9Path addCurveToPoint: CGPointMake(57.15, 30.16) controlPoint1: CGPointMake(55.58, 30.61) controlPoint2: CGPointMake(56.49, 30.16)];
        [bezier9Path addCurveToPoint: CGPointMake(59.36, 30.16) controlPoint1: CGPointMake(57.81, 30.16) controlPoint2: CGPointMake(59.36, 30.16)];
        [bezier9Path addLineToPoint: CGPointMake(59, 31.39)];
        [bezier9Path addLineToPoint: CGPointMake(58.65, 31.39)];
        [bezier9Path addLineToPoint: CGPointMake(56.98, 37.22)];
        [bezier9Path addLineToPoint: CGPointMake(57.33, 37.22)];
        [bezier9Path addLineToPoint: CGPointMake(57, 38.38)];
        [bezier9Path addLineToPoint: CGPointMake(56.65, 38.38)];
        [bezier9Path addLineToPoint: CGPointMake(56.5, 38.88)];
        [bezier9Path addLineToPoint: CGPointMake(54.78, 38.88)];
        [bezier9Path addLineToPoint: CGPointMake(54.93, 38.38)];
        [bezier9Path addLineToPoint: CGPointMake(51.5, 38.38)];
        [bezier9Path addLineToPoint: CGPointMake(51.83, 37.22)];
        [bezier9Path addLineToPoint: CGPointMake(52.18, 37.22)];
        [bezier9Path addLineToPoint: CGPointMake(53.86, 31.39)];
        [bezier9Path addLineToPoint: CGPointMake(53.5, 31.39)];
        [bezier9Path closePath];
        [bezier9Path moveToPoint: CGPointMake(55.43, 31.39)];
        [bezier9Path addLineToPoint: CGPointMake(54.97, 32.98)];
        [bezier9Path addCurveToPoint: CGPointMake(56.42, 32.6) controlPoint1: CGPointMake(54.97, 32.98) controlPoint2: CGPointMake(55.76, 32.67)];
        [bezier9Path addCurveToPoint: CGPointMake(56.77, 31.39) controlPoint1: CGPointMake(56.57, 32.05) controlPoint2: CGPointMake(56.77, 31.39)];
        [bezier9Path addLineToPoint: CGPointMake(55.43, 31.39)];
        [bezier9Path closePath];
        [bezier9Path moveToPoint: CGPointMake(54.74, 33.71)];
        [bezier9Path addLineToPoint: CGPointMake(54.29, 35.36)];
        [bezier9Path addCurveToPoint: CGPointMake(55.76, 34.91) controlPoint1: CGPointMake(54.29, 35.36) controlPoint2: CGPointMake(55.15, 34.94)];
        [bezier9Path addCurveToPoint: CGPointMake(56.11, 33.71) controlPoint1: CGPointMake(55.94, 34.28) controlPoint2: CGPointMake(56.11, 33.71)];
        [bezier9Path addLineToPoint: CGPointMake(54.74, 33.71)];
        [bezier9Path addLineToPoint: CGPointMake(54.74, 33.71)];
        [bezier9Path closePath];
        [bezier9Path moveToPoint: CGPointMake(55.1, 37.23)];
        [bezier9Path addLineToPoint: CGPointMake(55.45, 36.02)];
        [bezier9Path addLineToPoint: CGPointMake(54.11, 36.02)];
        [bezier9Path addLineToPoint: CGPointMake(53.76, 37.23)];
        [bezier9Path addLineToPoint: CGPointMake(55.1, 37.23)];
        [bezier9Path closePath];
        [bezier9Path moveToPoint: CGPointMake(59.43, 30.06)];
        [bezier9Path addLineToPoint: CGPointMake(61.11, 30.06)];
        [bezier9Path addLineToPoint: CGPointMake(61.18, 30.69)];
        [bezier9Path addCurveToPoint: CGPointMake(61.46, 30.92) controlPoint1: CGPointMake(61.18, 30.84) controlPoint2: CGPointMake(61.26, 30.92)];
        [bezier9Path addLineToPoint: CGPointMake(61.77, 30.92)];
        [bezier9Path addLineToPoint: CGPointMake(61.46, 31.97)];
        [bezier9Path addLineToPoint: CGPointMake(60.22, 31.97)];
        [bezier9Path addCurveToPoint: CGPointMake(59.48, 31.42) controlPoint1: CGPointMake(59.73, 32) controlPoint2: CGPointMake(59.51, 31.82)];
        [bezier9Path addLineToPoint: CGPointMake(59.43, 30.06)];
        [bezier9Path closePath];
        [bezier9Path moveToPoint: CGPointMake(58.93, 32.3)];
        [bezier9Path addLineToPoint: CGPointMake(64.38, 32.3)];
        [bezier9Path addLineToPoint: CGPointMake(64.05, 33.43)];
        [bezier9Path addLineToPoint: CGPointMake(62.3, 33.43)];
        [bezier9Path addLineToPoint: CGPointMake(62, 34.46)];
        [bezier9Path addLineToPoint: CGPointMake(63.72, 34.46)];
        [bezier9Path addLineToPoint: CGPointMake(63.39, 35.59)];
        [bezier9Path addLineToPoint: CGPointMake(61.46, 35.59)];
        [bezier9Path addLineToPoint: CGPointMake(61.04, 36.25)];
        [bezier9Path addLineToPoint: CGPointMake(61.97, 36.25)];
        [bezier9Path addLineToPoint: CGPointMake(62.2, 37.55)];
        [bezier9Path addCurveToPoint: CGPointMake(62.56, 37.76) controlPoint1: CGPointMake(62.23, 37.68) controlPoint2: CGPointMake(62.35, 37.76)];
        [bezier9Path addLineToPoint: CGPointMake(62.86, 37.76)];
        [bezier9Path addLineToPoint: CGPointMake(62.56, 38.84)];
        [bezier9Path addLineToPoint: CGPointMake(61.52, 38.84)];
        [bezier9Path addCurveToPoint: CGPointMake(60.68, 38.31) controlPoint1: CGPointMake(60.99, 38.86) controlPoint2: CGPointMake(60.71, 38.69)];
        [bezier9Path addLineToPoint: CGPointMake(60.43, 37.1)];
        [bezier9Path addLineToPoint: CGPointMake(59.57, 38.38)];
        [bezier9Path addCurveToPoint: CGPointMake(58.63, 38.89) controlPoint1: CGPointMake(59.36, 38.73) controlPoint2: CGPointMake(59.06, 38.91)];
        [bezier9Path addLineToPoint: CGPointMake(57.03, 38.89)];
        [bezier9Path addLineToPoint: CGPointMake(57.33, 37.81)];
        [bezier9Path addLineToPoint: CGPointMake(57.84, 37.81)];
        [bezier9Path addCurveToPoint: CGPointMake(58.37, 37.53) controlPoint1: CGPointMake(58.05, 37.81) controlPoint2: CGPointMake(58.22, 37.71)];
        [bezier9Path addLineToPoint: CGPointMake(59.72, 35.6)];
        [bezier9Path addLineToPoint: CGPointMake(57.97, 35.6)];
        [bezier9Path addLineToPoint: CGPointMake(58.3, 34.46)];
        [bezier9Path addLineToPoint: CGPointMake(60.17, 34.46)];
        [bezier9Path addLineToPoint: CGPointMake(60.48, 33.43)];
        [bezier9Path addLineToPoint: CGPointMake(58.6, 33.43)];
        [bezier9Path addLineToPoint: CGPointMake(58.93, 32.3)];
        [bezier9Path closePath];
        bezier9Path.miterLimit = 4;

        [color setFill];
        [bezier9Path fill];


        //// Bezier 10 Drawing
        UIBezierPath* bezier10Path = [UIBezierPath bezierPath];
        [bezier10Path moveToPoint: CGPointMake(28.48, 24.68)];
        [bezier10Path addCurveToPoint: CGPointMake(27.04, 27.02) controlPoint1: CGPointMake(28.28, 25.69) controlPoint2: CGPointMake(27.8, 26.47)];
        [bezier10Path addCurveToPoint: CGPointMake(24.18, 27.82) controlPoint1: CGPointMake(26.31, 27.55) controlPoint2: CGPointMake(25.34, 27.82)];
        [bezier10Path addCurveToPoint: CGPointMake(21.77, 26.99) controlPoint1: CGPointMake(23.09, 27.82) controlPoint2: CGPointMake(22.28, 27.55)];
        [bezier10Path addCurveToPoint: CGPointMake(21.24, 25.49) controlPoint1: CGPointMake(21.41, 26.59) controlPoint2: CGPointMake(21.24, 26.09)];
        [bezier10Path addCurveToPoint: CGPointMake(21.34, 24.68) controlPoint1: CGPointMake(21.24, 25.24) controlPoint2: CGPointMake(21.26, 24.96)];
        [bezier10Path addLineToPoint: CGPointMake(22.58, 18.75)];
        [bezier10Path addLineToPoint: CGPointMake(24.46, 18.75)];
        [bezier10Path addLineToPoint: CGPointMake(23.24, 24.63)];
        [bezier10Path addCurveToPoint: CGPointMake(23.19, 25.09) controlPoint1: CGPointMake(23.21, 24.78) controlPoint2: CGPointMake(23.19, 24.94)];
        [bezier10Path addCurveToPoint: CGPointMake(23.42, 25.81) controlPoint1: CGPointMake(23.19, 25.39) controlPoint2: CGPointMake(23.27, 25.64)];
        [bezier10Path addCurveToPoint: CGPointMake(24.51, 26.24) controlPoint1: CGPointMake(23.65, 26.09) controlPoint2: CGPointMake(24.01, 26.24)];
        [bezier10Path addCurveToPoint: CGPointMake(25.93, 25.81) controlPoint1: CGPointMake(25.1, 26.24) controlPoint2: CGPointMake(25.57, 26.09)];
        [bezier10Path addCurveToPoint: CGPointMake(26.64, 24.61) controlPoint1: CGPointMake(26.31, 25.54) controlPoint2: CGPointMake(26.54, 25.13)];
        [bezier10Path addLineToPoint: CGPointMake(27.88, 18.73)];
        [bezier10Path addLineToPoint: CGPointMake(29.76, 18.73)];
        [bezier10Path addLineToPoint: CGPointMake(28.48, 24.68)];
        [bezier10Path closePath];
        bezier10Path.miterLimit = 4;

        [color setFill];
        [bezier10Path fill];


        //// Bezier 11 Drawing
        UIBezierPath* bezier11Path = [UIBezierPath bezierPath];
        [bezier11Path moveToPoint: CGPointMake(30.21, 22.35)];
        [bezier11Path addLineToPoint: CGPointMake(31.53, 22.35)];
        [bezier11Path addLineToPoint: CGPointMake(31.37, 23.1)];
        [bezier11Path addLineToPoint: CGPointMake(31.58, 22.87)];
        [bezier11Path addCurveToPoint: CGPointMake(33.15, 22.19) controlPoint1: CGPointMake(32.01, 22.42) controlPoint2: CGPointMake(32.54, 22.19)];
        [bezier11Path addCurveToPoint: CGPointMake(34.37, 22.67) controlPoint1: CGPointMake(33.71, 22.19) controlPoint2: CGPointMake(34.11, 22.34)];
        [bezier11Path addCurveToPoint: CGPointMake(34.57, 24) controlPoint1: CGPointMake(34.62, 23) controlPoint2: CGPointMake(34.67, 23.45)];
        [bezier11Path addLineToPoint: CGPointMake(33.84, 27.62)];
        [bezier11Path addLineToPoint: CGPointMake(32.47, 27.62)];
        [bezier11Path addLineToPoint: CGPointMake(33.13, 24.36)];
        [bezier11Path addCurveToPoint: CGPointMake(33.08, 23.6) controlPoint1: CGPointMake(33.2, 24.03) controlPoint2: CGPointMake(33.18, 23.78)];
        [bezier11Path addCurveToPoint: CGPointMake(32.49, 23.35) controlPoint1: CGPointMake(32.98, 23.45) controlPoint2: CGPointMake(32.77, 23.35)];
        [bezier11Path addCurveToPoint: CGPointMake(31.61, 23.68) controlPoint1: CGPointMake(32.14, 23.35) controlPoint2: CGPointMake(31.86, 23.45)];
        [bezier11Path addCurveToPoint: CGPointMake(31.13, 24.58) controlPoint1: CGPointMake(31.36, 23.9) controlPoint2: CGPointMake(31.2, 24.2)];
        [bezier11Path addLineToPoint: CGPointMake(30.52, 27.62)];
        [bezier11Path addLineToPoint: CGPointMake(29.15, 27.62)];
        [bezier11Path addLineToPoint: CGPointMake(30.21, 22.35)];
        [bezier11Path closePath];
        bezier11Path.miterLimit = 4;

        [color setFill];
        [bezier11Path fill];


        //// Bezier 12 Drawing
        UIBezierPath* bezier12Path = [UIBezierPath bezierPath];
        [bezier12Path moveToPoint: CGPointMake(45.42, 22.35)];
        [bezier12Path addLineToPoint: CGPointMake(46.74, 22.35)];
        [bezier12Path addLineToPoint: CGPointMake(46.59, 23.1)];
        [bezier12Path addLineToPoint: CGPointMake(46.76, 22.87)];
        [bezier12Path addCurveToPoint: CGPointMake(48.33, 22.19) controlPoint1: CGPointMake(47.19, 22.42) controlPoint2: CGPointMake(47.73, 22.19)];
        [bezier12Path addCurveToPoint: CGPointMake(49.55, 22.67) controlPoint1: CGPointMake(48.89, 22.19) controlPoint2: CGPointMake(49.3, 22.34)];
        [bezier12Path addCurveToPoint: CGPointMake(49.76, 24) controlPoint1: CGPointMake(49.8, 23) controlPoint2: CGPointMake(49.88, 23.45)];
        [bezier12Path addLineToPoint: CGPointMake(49.02, 27.62)];
        [bezier12Path addLineToPoint: CGPointMake(47.65, 27.62)];
        [bezier12Path addLineToPoint: CGPointMake(48.31, 24.36)];
        [bezier12Path addCurveToPoint: CGPointMake(48.26, 23.6) controlPoint1: CGPointMake(48.39, 24.03) controlPoint2: CGPointMake(48.36, 23.78)];
        [bezier12Path addCurveToPoint: CGPointMake(47.68, 23.35) controlPoint1: CGPointMake(48.16, 23.45) controlPoint2: CGPointMake(47.96, 23.35)];
        [bezier12Path addCurveToPoint: CGPointMake(46.79, 23.68) controlPoint1: CGPointMake(47.32, 23.35) controlPoint2: CGPointMake(47.05, 23.45)];
        [bezier12Path addCurveToPoint: CGPointMake(46.31, 24.58) controlPoint1: CGPointMake(46.54, 23.9) controlPoint2: CGPointMake(46.39, 24.2)];
        [bezier12Path addLineToPoint: CGPointMake(45.7, 27.62)];
        [bezier12Path addLineToPoint: CGPointMake(44.34, 27.62)];
        [bezier12Path addLineToPoint: CGPointMake(45.42, 22.35)];
        [bezier12Path closePath];
        bezier12Path.miterLimit = 4;

        [color setFill];
        [bezier12Path fill];


        //// Bezier 13 Drawing
        UIBezierPath* bezier13Path = [UIBezierPath bezierPath];
        [bezier13Path moveToPoint: CGPointMake(36.37, 22.35)];
        [bezier13Path addLineToPoint: CGPointMake(37.84, 22.35)];
        [bezier13Path addLineToPoint: CGPointMake(36.7, 27.65)];
        [bezier13Path addLineToPoint: CGPointMake(35.23, 27.65)];
        [bezier13Path addLineToPoint: CGPointMake(36.37, 22.35)];
        [bezier13Path closePath];
        [bezier13Path moveToPoint: CGPointMake(36.82, 20.41)];
        [bezier13Path addLineToPoint: CGPointMake(38.29, 20.41)];
        [bezier13Path addLineToPoint: CGPointMake(38.02, 21.69)];
        [bezier13Path addLineToPoint: CGPointMake(36.55, 21.69)];
        [bezier13Path addLineToPoint: CGPointMake(36.82, 20.41)];
        [bezier13Path closePath];
        bezier13Path.miterLimit = 4;

        [color setFill];
        [bezier13Path fill];


        //// Bezier 14 Drawing
        UIBezierPath* bezier14Path = [UIBezierPath bezierPath];
        [bezier14Path moveToPoint: CGPointMake(39.13, 27.25)];
        [bezier14Path addCurveToPoint: CGPointMake(38.55, 25.76) controlPoint1: CGPointMake(38.75, 26.89) controlPoint2: CGPointMake(38.55, 26.39)];
        [bezier14Path addCurveToPoint: CGPointMake(38.57, 25.41) controlPoint1: CGPointMake(38.55, 25.66) controlPoint2: CGPointMake(38.55, 25.53)];
        [bezier14Path addCurveToPoint: CGPointMake(38.62, 25.03) controlPoint1: CGPointMake(38.6, 25.28) controlPoint2: CGPointMake(38.6, 25.13)];
        [bezier14Path addCurveToPoint: CGPointMake(39.74, 22.97) controlPoint1: CGPointMake(38.8, 24.18) controlPoint2: CGPointMake(39.18, 23.5)];
        [bezier14Path addCurveToPoint: CGPointMake(41.79, 22.22) controlPoint1: CGPointMake(40.32, 22.47) controlPoint2: CGPointMake(41, 22.22)];
        [bezier14Path addCurveToPoint: CGPointMake(43.36, 22.77) controlPoint1: CGPointMake(42.45, 22.22) controlPoint2: CGPointMake(42.98, 22.39)];
        [bezier14Path addCurveToPoint: CGPointMake(43.95, 24.28) controlPoint1: CGPointMake(43.74, 23.15) controlPoint2: CGPointMake(43.95, 23.62)];
        [bezier14Path addCurveToPoint: CGPointMake(43.92, 24.66) controlPoint1: CGPointMake(43.95, 24.38) controlPoint2: CGPointMake(43.95, 24.51)];
        [bezier14Path addCurveToPoint: CGPointMake(43.87, 25.06) controlPoint1: CGPointMake(43.89, 24.78) controlPoint2: CGPointMake(43.89, 24.93)];
        [bezier14Path addCurveToPoint: CGPointMake(42.76, 27.07) controlPoint1: CGPointMake(43.69, 25.92) controlPoint2: CGPointMake(43.34, 26.59)];
        [bezier14Path addCurveToPoint: CGPointMake(40.7, 27.82) controlPoint1: CGPointMake(42.17, 27.57) controlPoint2: CGPointMake(41.49, 27.82)];
        [bezier14Path addCurveToPoint: CGPointMake(39.13, 27.25) controlPoint1: CGPointMake(40.04, 27.78) controlPoint2: CGPointMake(39.51, 27.6)];
        [bezier14Path closePath];
        [bezier14Path moveToPoint: CGPointMake(41.94, 26.19)];
        [bezier14Path addCurveToPoint: CGPointMake(42.5, 24.94) controlPoint1: CGPointMake(42.19, 25.92) controlPoint2: CGPointMake(42.4, 25.49)];
        [bezier14Path addCurveToPoint: CGPointMake(42.55, 24.66) controlPoint1: CGPointMake(42.53, 24.86) controlPoint2: CGPointMake(42.53, 24.76)];
        [bezier14Path addCurveToPoint: CGPointMake(42.58, 24.41) controlPoint1: CGPointMake(42.55, 24.56) controlPoint2: CGPointMake(42.58, 24.48)];
        [bezier14Path addCurveToPoint: CGPointMake(42.32, 23.65) controlPoint1: CGPointMake(42.58, 24.08) controlPoint2: CGPointMake(42.5, 23.83)];
        [bezier14Path addCurveToPoint: CGPointMake(41.61, 23.38) controlPoint1: CGPointMake(42.15, 23.48) controlPoint2: CGPointMake(41.92, 23.38)];
        [bezier14Path addCurveToPoint: CGPointMake(40.63, 23.8) controlPoint1: CGPointMake(41.21, 23.38) controlPoint2: CGPointMake(40.88, 23.53)];
        [bezier14Path addCurveToPoint: CGPointMake(40.07, 25.09) controlPoint1: CGPointMake(40.37, 24.08) controlPoint2: CGPointMake(40.17, 24.51)];
        [bezier14Path addCurveToPoint: CGPointMake(40.02, 25.34) controlPoint1: CGPointMake(40.04, 25.16) controlPoint2: CGPointMake(40.04, 25.26)];
        [bezier14Path addCurveToPoint: CGPointMake(40.02, 25.59) controlPoint1: CGPointMake(40.02, 25.41) controlPoint2: CGPointMake(40.02, 25.51)];
        [bezier14Path addCurveToPoint: CGPointMake(40.27, 26.34) controlPoint1: CGPointMake(40.02, 25.91) controlPoint2: CGPointMake(40.1, 26.17)];
        [bezier14Path addCurveToPoint: CGPointMake(40.98, 26.62) controlPoint1: CGPointMake(40.45, 26.52) controlPoint2: CGPointMake(40.68, 26.62)];
        [bezier14Path addCurveToPoint: CGPointMake(41.94, 26.19) controlPoint1: CGPointMake(41.34, 26.62) controlPoint2: CGPointMake(41.66, 26.47)];
        [bezier14Path closePath];
        bezier14Path.miterLimit = 4;

        [color setFill];
        [bezier14Path fill];


        //// Bezier 15 Drawing
        UIBezierPath* bezier15Path = [UIBezierPath bezierPath];
        [bezier15Path moveToPoint: CGPointMake(51.96, 19.05)];
        [bezier15Path addLineToPoint: CGPointMake(55.81, 19.05)];
        [bezier15Path addCurveToPoint: CGPointMake(57.51, 19.56) controlPoint1: CGPointMake(56.54, 19.05) controlPoint2: CGPointMake(57.13, 19.23)];
        [bezier15Path addCurveToPoint: CGPointMake(58.09, 20.99) controlPoint1: CGPointMake(57.89, 19.89) controlPoint2: CGPointMake(58.09, 20.36)];
        [bezier15Path addLineToPoint: CGPointMake(58.09, 21.02)];
        [bezier15Path addCurveToPoint: CGPointMake(58.07, 21.42) controlPoint1: CGPointMake(58.09, 21.14) controlPoint2: CGPointMake(58.09, 21.27)];
        [bezier15Path addCurveToPoint: CGPointMake(57.99, 21.85) controlPoint1: CGPointMake(58.04, 21.57) controlPoint2: CGPointMake(58.02, 21.7)];
        [bezier15Path addCurveToPoint: CGPointMake(56.83, 23.83) controlPoint1: CGPointMake(57.81, 22.68) controlPoint2: CGPointMake(57.43, 23.33)];
        [bezier15Path addCurveToPoint: CGPointMake(54.67, 24.58) controlPoint1: CGPointMake(56.22, 24.33) controlPoint2: CGPointMake(55.48, 24.58)];
        [bezier15Path addLineToPoint: CGPointMake(52.62, 24.58)];
        [bezier15Path addLineToPoint: CGPointMake(51.98, 27.7)];
        [bezier15Path addLineToPoint: CGPointMake(50.18, 27.7)];
        [bezier15Path addLineToPoint: CGPointMake(51.96, 19.05)];
        [bezier15Path closePath];
        [bezier15Path moveToPoint: CGPointMake(52.92, 23.05)];
        [bezier15Path addLineToPoint: CGPointMake(54.64, 23.05)];
        [bezier15Path addCurveToPoint: CGPointMake(55.71, 22.75) controlPoint1: CGPointMake(55.1, 23.05) controlPoint2: CGPointMake(55.45, 22.95)];
        [bezier15Path addCurveToPoint: CGPointMake(56.24, 21.79) controlPoint1: CGPointMake(55.96, 22.54) controlPoint2: CGPointMake(56.14, 22.22)];
        [bezier15Path addCurveToPoint: CGPointMake(56.26, 21.56) controlPoint1: CGPointMake(56.26, 21.72) controlPoint2: CGPointMake(56.26, 21.64)];
        [bezier15Path addCurveToPoint: CGPointMake(56.29, 21.39) controlPoint1: CGPointMake(56.26, 21.51) controlPoint2: CGPointMake(56.29, 21.44)];
        [bezier15Path addCurveToPoint: CGPointMake(55.96, 20.73) controlPoint1: CGPointMake(56.29, 21.08) controlPoint2: CGPointMake(56.19, 20.86)];
        [bezier15Path addCurveToPoint: CGPointMake(54.92, 20.53) controlPoint1: CGPointMake(55.73, 20.58) controlPoint2: CGPointMake(55.4, 20.53)];
        [bezier15Path addLineToPoint: CGPointMake(53.48, 20.53)];
        [bezier15Path addLineToPoint: CGPointMake(52.92, 23.05)];
        [bezier15Path closePath];
        bezier15Path.miterLimit = 4;

        [color setFill];
        [bezier15Path fill];


        //// Bezier 16 Drawing
        UIBezierPath* bezier16Path = [UIBezierPath bezierPath];
        [bezier16Path moveToPoint: CGPointMake(66.13, 28.68)];
        [bezier16Path addCurveToPoint: CGPointMake(64.71, 30.89) controlPoint1: CGPointMake(65.57, 29.86) controlPoint2: CGPointMake(65.01, 30.56)];
        [bezier16Path addCurveToPoint: CGPointMake(62.25, 31.9) controlPoint1: CGPointMake(64.4, 31.22) controlPoint2: CGPointMake(63.77, 31.95)];
        [bezier16Path addLineToPoint: CGPointMake(62.38, 30.99)];
        [bezier16Path addCurveToPoint: CGPointMake(64.74, 28.08) controlPoint1: CGPointMake(63.64, 30.62) controlPoint2: CGPointMake(64.33, 28.86)];
        [bezier16Path addLineToPoint: CGPointMake(64.28, 22.37)];
        [bezier16Path addLineToPoint: CGPointMake(65.27, 22.35)];
        [bezier16Path addLineToPoint: CGPointMake(66.1, 22.35)];
        [bezier16Path addLineToPoint: CGPointMake(66.18, 25.92)];
        [bezier16Path addLineToPoint: CGPointMake(67.72, 22.35)];
        [bezier16Path addLineToPoint: CGPointMake(69.3, 22.35)];
        [bezier16Path addLineToPoint: CGPointMake(66.13, 28.68)];
        [bezier16Path closePath];
        bezier16Path.miterLimit = 4;
        
        [color setFill];
        [bezier16Path fill];
        
        
        //// Bezier 17 Drawing
        UIBezierPath* bezier17Path = [UIBezierPath bezierPath];
        [bezier17Path moveToPoint: CGPointMake(61.74, 22.77)];
        [bezier17Path addLineToPoint: CGPointMake(61.11, 23.2)];
        [bezier17Path addCurveToPoint: CGPointMake(58.72, 22.9) controlPoint1: CGPointMake(60.45, 22.69) controlPoint2: CGPointMake(59.86, 22.4)];
        [bezier17Path addCurveToPoint: CGPointMake(60.15, 27.29) controlPoint1: CGPointMake(57.15, 23.62) controlPoint2: CGPointMake(55.86, 29.1)];
        [bezier17Path addLineToPoint: CGPointMake(60.4, 27.57)];
        [bezier17Path addLineToPoint: CGPointMake(62.1, 27.62)];
        [bezier17Path addLineToPoint: CGPointMake(63.21, 22.62)];
        [bezier17Path addLineToPoint: CGPointMake(61.74, 22.77)];
        [bezier17Path closePath];
        [bezier17Path moveToPoint: CGPointMake(60.78, 25.51)];
        [bezier17Path addCurveToPoint: CGPointMake(59.44, 26.69) controlPoint1: CGPointMake(60.5, 26.31) controlPoint2: CGPointMake(59.89, 26.82)];
        [bezier17Path addCurveToPoint: CGPointMake(59.06, 24.98) controlPoint1: CGPointMake(58.95, 26.54) controlPoint2: CGPointMake(58.8, 25.79)];
        [bezier17Path addCurveToPoint: CGPointMake(60.4, 23.8) controlPoint1: CGPointMake(59.34, 24.18) controlPoint2: CGPointMake(59.94, 23.68)];
        [bezier17Path addCurveToPoint: CGPointMake(60.78, 25.51) controlPoint1: CGPointMake(60.88, 23.95) controlPoint2: CGPointMake(61.06, 24.71)];
        [bezier17Path closePath];
        bezier17Path.miterLimit = 4;
        
        [color setFill];
        [bezier17Path fill];
    }
}

@end
