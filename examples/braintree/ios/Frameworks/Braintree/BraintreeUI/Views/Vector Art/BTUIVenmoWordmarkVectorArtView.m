#import "BTUIVenmoWordmarkVectorArtView.h"

@implementation BTUIVenmoWordmarkVectorArtView

- (id)init {
    self = [super init];
    if (self) {
        self.artDimensions = CGSizeMake(132, 88);
        self.opaque = NO;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawArt {
    //// Color Declarations
    UIColor* color = self.color; //[UIColor colorWithRed: 0.194 green: 0.507 blue: 0.764 alpha: 1];

    //// Assets
    {
        //// button-venmo
        {
            //// Rectangle Drawing


            //// logo/venmo
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(70.02, 53.98)];
                [bezierPath addCurveToPoint: CGPointMake(70.02, 52.78) controlPoint1: CGPointMake(70.02, 53.43) controlPoint2: CGPointMake(69.97, 53.09)];
                [bezierPath addCurveToPoint: CGPointMake(72.56, 36.46) controlPoint1: CGPointMake(70.87, 47.34) controlPoint2: CGPointMake(71.77, 41.9)];
                [bezierPath addCurveToPoint: CGPointMake(74.94, 34.44) controlPoint1: CGPointMake(72.87, 34.33) controlPoint2: CGPointMake(72.83, 34.43)];
                [bezierPath addCurveToPoint: CGPointMake(76.91, 34.43) controlPoint1: CGPointMake(75.59, 34.44) controlPoint2: CGPointMake(76.25, 34.48)];
                [bezierPath addCurveToPoint: CGPointMake(78.78, 35.72) controlPoint1: CGPointMake(77.84, 34.35) controlPoint2: CGPointMake(78.63, 34.46)];
                [bezierPath addCurveToPoint: CGPointMake(79.63, 35.35) controlPoint1: CGPointMake(79.13, 35.57) controlPoint2: CGPointMake(79.39, 35.49)];
                [bezierPath addCurveToPoint: CGPointMake(83.08, 34.11) controlPoint1: CGPointMake(80.7, 34.71) controlPoint2: CGPointMake(81.84, 34.3)];
                [bezierPath addCurveToPoint: CGPointMake(87.94, 35.56) controlPoint1: CGPointMake(84.94, 33.83) controlPoint2: CGPointMake(86.59, 34.13)];
                [bezierPath addCurveToPoint: CGPointMake(88.47, 35.99) controlPoint1: CGPointMake(88.08, 35.71) controlPoint2: CGPointMake(88.26, 35.82)];
                [bezierPath addCurveToPoint: CGPointMake(90.53, 34.9) controlPoint1: CGPointMake(89.16, 35.62) controlPoint2: CGPointMake(89.83, 35.22)];
                [bezierPath addCurveToPoint: CGPointMake(96.29, 34.23) controlPoint1: CGPointMake(92.38, 34.05) controlPoint2: CGPointMake(94.29, 33.75)];
                [bezierPath addCurveToPoint: CGPointMake(99, 37.48) controlPoint1: CGPointMake(97.97, 34.63) controlPoint2: CGPointMake(98.97, 35.72)];
                [bezierPath addCurveToPoint: CGPointMake(98.7, 41.97) controlPoint1: CGPointMake(99.02, 38.98) controlPoint2: CGPointMake(98.91, 40.49)];
                [bezierPath addCurveToPoint: CGPointMake(97.05, 52.6) controlPoint1: CGPointMake(98.2, 45.52) controlPoint2: CGPointMake(97.6, 49.06)];
                [bezierPath addCurveToPoint: CGPointMake(95.52, 53.99) controlPoint1: CGPointMake(96.84, 53.93) controlPoint2: CGPointMake(96.8, 53.99)];
                [bezierPath addCurveToPoint: CGPointMake(91.7, 53.99) controlPoint1: CGPointMake(94.24, 54) controlPoint2: CGPointMake(92.97, 54)];
                [bezierPath addCurveToPoint: CGPointMake(90.47, 53.9) controlPoint1: CGPointMake(91.34, 53.99) controlPoint2: CGPointMake(90.98, 53.94)];
                [bezierPath addCurveToPoint: CGPointMake(90.55, 52.4) controlPoint1: CGPointMake(90.5, 53.35) controlPoint2: CGPointMake(90.48, 52.87)];
                [bezierPath addCurveToPoint: CGPointMake(92.22, 41.39) controlPoint1: CGPointMake(91.1, 48.73) controlPoint2: CGPointMake(91.66, 45.06)];
                [bezierPath addCurveToPoint: CGPointMake(92.28, 40.52) controlPoint1: CGPointMake(92.26, 41.1) controlPoint2: CGPointMake(92.32, 40.8)];
                [bezierPath addCurveToPoint: CGPointMake(91.24, 39.51) controlPoint1: CGPointMake(92.21, 39.89) controlPoint2: CGPointMake(91.84, 39.46)];
                [bezierPath addCurveToPoint: CGPointMake(89.13, 40.07) controlPoint1: CGPointMake(90.52, 39.58) controlPoint2: CGPointMake(89.78, 39.77)];
                [bezierPath addCurveToPoint: CGPointMake(88.65, 41.13) controlPoint1: CGPointMake(88.86, 40.2) controlPoint2: CGPointMake(88.71, 40.75)];
                [bezierPath addCurveToPoint: CGPointMake(87.43, 48.92) controlPoint1: CGPointMake(88.22, 43.72) controlPoint2: CGPointMake(87.83, 46.32)];
                [bezierPath addCurveToPoint: CGPointMake(86.63, 53.9) controlPoint1: CGPointMake(87.17, 50.56) controlPoint2: CGPointMake(86.91, 52.2)];
                [bezierPath addLineToPoint: CGPointMake(80.17, 53.9)];
                [bezierPath addCurveToPoint: CGPointMake(80.62, 50.53) controlPoint1: CGPointMake(80.33, 52.73) controlPoint2: CGPointMake(80.45, 51.62)];
                [bezierPath addCurveToPoint: CGPointMake(81.96, 42.12) controlPoint1: CGPointMake(81.06, 47.72) controlPoint2: CGPointMake(81.52, 44.93)];
                [bezierPath addCurveToPoint: CGPointMake(82.02, 40.63) controlPoint1: CGPointMake(82.03, 41.63) controlPoint2: CGPointMake(82.08, 41.12)];
                [bezierPath addCurveToPoint: CGPointMake(81.53, 39.69) controlPoint1: CGPointMake(81.97, 40.29) controlPoint2: CGPointMake(81.79, 39.88)];
                [bezierPath addCurveToPoint: CGPointMake(78.43, 40.93) controlPoint1: CGPointMake(80.64, 39.03) controlPoint2: CGPointMake(78.64, 39.84)];
                [bezierPath addCurveToPoint: CGPointMake(77.86, 44.51) controlPoint1: CGPointMake(78.2, 42.12) controlPoint2: CGPointMake(78.04, 43.32)];
                [bezierPath addCurveToPoint: CGPointMake(76.58, 53.05) controlPoint1: CGPointMake(77.43, 47.36) controlPoint2: CGPointMake(77, 50.2)];
                [bezierPath addCurveToPoint: CGPointMake(75.81, 53.98) controlPoint1: CGPointMake(76.51, 53.55) controlPoint2: CGPointMake(76.4, 53.97)];
                [bezierPath addCurveToPoint: CGPointMake(70.02, 53.98) controlPoint1: CGPointMake(73.93, 53.98) controlPoint2: CGPointMake(72.05, 53.98)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(65.64, 53.85)];
                [bezierPath addCurveToPoint: CGPointMake(59.25, 53.73) controlPoint1: CGPointMake(64, 54.09) controlPoint2: CGPointMake(60.19, 54.03)];
                [bezierPath addCurveToPoint: CGPointMake(59.71, 50.43) controlPoint1: CGPointMake(59.4, 52.64) controlPoint2: CGPointMake(59.54, 51.53)];
                [bezierPath addCurveToPoint: CGPointMake(61.06, 41.78) controlPoint1: CGPointMake(60.16, 47.55) controlPoint2: CGPointMake(60.61, 44.67)];
                [bezierPath addCurveToPoint: CGPointMake(58.66, 39.69) controlPoint1: CGPointMake(61.39, 39.72) controlPoint2: CGPointMake(60.6, 39.04)];
                [bezierPath addCurveToPoint: CGPointMake(57.43, 41.2) controlPoint1: CGPointMake(57.9, 39.94) controlPoint2: CGPointMake(57.55, 40.4)];
                [bezierPath addCurveToPoint: CGPointMake(55.71, 52.57) controlPoint1: CGPointMake(56.88, 45) controlPoint2: CGPointMake(56.29, 48.78)];
                [bezierPath addCurveToPoint: CGPointMake(54.19, 53.98) controlPoint1: CGPointMake(55.51, 53.92) controlPoint2: CGPointMake(55.46, 53.97)];
                [bezierPath addCurveToPoint: CGPointMake(49, 53.98) controlPoint1: CGPointMake(52.51, 53.99) controlPoint2: CGPointMake(50.84, 53.98)];
                [bezierPath addCurveToPoint: CGPointMake(49.38, 50.94) controlPoint1: CGPointMake(49.13, 52.89) controlPoint2: CGPointMake(49.22, 51.91)];
                [bezierPath addCurveToPoint: CGPointMake(51.46, 37.73) controlPoint1: CGPointMake(50.06, 46.54) controlPoint2: CGPointMake(50.76, 42.14)];
                [bezierPath addCurveToPoint: CGPointMake(51.8, 35.38) controlPoint1: CGPointMake(51.58, 36.95) controlPoint2: CGPointMake(51.71, 36.17)];
                [bezierPath addCurveToPoint: CGPointMake(52.73, 34.45) controlPoint1: CGPointMake(51.86, 34.79) controlPoint2: CGPointMake(52.12, 34.45)];
                [bezierPath addCurveToPoint: CGPointMake(56.91, 34.44) controlPoint1: CGPointMake(54.12, 34.45) controlPoint2: CGPointMake(55.52, 34.47)];
                [bezierPath addCurveToPoint: CGPointMake(57.91, 35.69) controlPoint1: CGPointMake(57.69, 34.43) controlPoint2: CGPointMake(57.61, 35.12)];
                [bezierPath addCurveToPoint: CGPointMake(59.21, 35.06) controlPoint1: CGPointMake(58.36, 35.47) controlPoint2: CGPointMake(58.79, 35.27)];
                [bezierPath addCurveToPoint: CGPointMake(65.29, 34.26) controlPoint1: CGPointMake(61.15, 34.1) controlPoint2: CGPointMake(63.16, 33.69)];
                [bezierPath addCurveToPoint: CGPointMake(67.84, 37) controlPoint1: CGPointMake(66.7, 34.64) controlPoint2: CGPointMake(67.49, 35.55)];
                [bezierPath addCurveToPoint: CGPointMake(67.73, 40.97) controlPoint1: CGPointMake(68.17, 38.36) controlPoint2: CGPointMake(67.92, 39.67)];
                [bezierPath addCurveToPoint: CGPointMake(65.8, 53.33) controlPoint1: CGPointMake(67.14, 45.1) controlPoint2: CGPointMake(66.45, 49.21)];
                [bezierPath addCurveToPoint: CGPointMake(65.64, 53.85) controlPoint1: CGPointMake(65.77, 53.49) controlPoint2: CGPointMake(65.71, 53.64)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(118.98, 42.12)];
                [bezierPath addCurveToPoint: CGPointMake(117.38, 48.99) controlPoint1: CGPointMake(119.11, 44.56) controlPoint2: CGPointMake(118.6, 46.87)];
                [bezierPath addCurveToPoint: CGPointMake(108.97, 54) controlPoint1: CGPointMake(115.52, 52.2) controlPoint2: CGPointMake(112.75, 53.97)];
                [bezierPath addCurveToPoint: CGPointMake(105.76, 53.8) controlPoint1: CGPointMake(107.9, 54) controlPoint2: CGPointMake(106.8, 54.02)];
                [bezierPath addCurveToPoint: CGPointMake(101.19, 49.25) controlPoint1: CGPointMake(103.3, 53.26) controlPoint2: CGPointMake(101.73, 51.62)];
                [bezierPath addCurveToPoint: CGPointMake(102.47, 38.85) controlPoint1: CGPointMake(100.37, 45.67) controlPoint2: CGPointMake(100.59, 42.13)];
                [bezierPath addCurveToPoint: CGPointMake(109.3, 34.21) controlPoint1: CGPointMake(103.99, 36.22) controlPoint2: CGPointMake(106.29, 34.71)];
                [bezierPath addCurveToPoint: CGPointMake(113.49, 34.2) controlPoint1: CGPointMake(110.7, 33.97) controlPoint2: CGPointMake(112.08, 33.96)];
                [bezierPath addCurveToPoint: CGPointMake(118.97, 40.15) controlPoint1: CGPointMake(116.67, 34.74) controlPoint2: CGPointMake(118.72, 36.92)];
                [bezierPath addCurveToPoint: CGPointMake(118.98, 42.12) controlPoint1: CGPointMake(119.02, 40.8) controlPoint2: CGPointMake(118.98, 41.46)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(107.37, 45.48)];
                [bezierPath addCurveToPoint: CGPointMake(107.54, 45.5) controlPoint1: CGPointMake(107.43, 45.48) controlPoint2: CGPointMake(107.48, 45.49)];
                [bezierPath addCurveToPoint: CGPointMake(107.55, 47.1) controlPoint1: CGPointMake(107.54, 46.04) controlPoint2: CGPointMake(107.5, 46.57)];
                [bezierPath addCurveToPoint: CGPointMake(108.89, 48.99) controlPoint1: CGPointMake(107.64, 48.09) controlPoint2: CGPointMake(108.18, 48.82)];
                [bezierPath addCurveToPoint: CGPointMake(110.96, 47.92) controlPoint1: CGPointMake(109.58, 49.16) controlPoint2: CGPointMake(110.4, 48.74)];
                [bezierPath addCurveToPoint: CGPointMake(111.09, 47.71) controlPoint1: CGPointMake(111, 47.85) controlPoint2: CGPointMake(111.05, 47.79)];
                [bezierPath addCurveToPoint: CGPointMake(112.18, 40.52) controlPoint1: CGPointMake(112.23, 45.43) controlPoint2: CGPointMake(112.51, 43.02)];
                [bezierPath addCurveToPoint: CGPointMake(111.11, 39.14) controlPoint1: CGPointMake(112.1, 39.9) controlPoint2: CGPointMake(111.81, 39.33)];
                [bezierPath addCurveToPoint: CGPointMake(109.2, 39.73) controlPoint1: CGPointMake(110.36, 38.95) controlPoint2: CGPointMake(109.66, 39.14)];
                [bezierPath addCurveToPoint: CGPointMake(108.08, 41.75) controlPoint1: CGPointMake(108.73, 40.33) controlPoint2: CGPointMake(108.29, 41.03)];
                [bezierPath addCurveToPoint: CGPointMake(107.37, 45.48) controlPoint1: CGPointMake(107.74, 42.96) controlPoint2: CGPointMake(107.6, 44.23)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(12, 35.08)];
                [bezierPath addCurveToPoint: CGPointMake(13.83, 34.83) controlPoint1: CGPointMake(12.73, 34.98) controlPoint2: CGPointMake(13.28, 34.89)];
                [bezierPath addCurveToPoint: CGPointMake(17.44, 34.46) controlPoint1: CGPointMake(15.03, 34.69) controlPoint2: CGPointMake(16.24, 34.55)];
                [bezierPath addCurveToPoint: CGPointMake(18.72, 35.54) controlPoint1: CGPointMake(18.39, 34.39) controlPoint2: CGPointMake(18.6, 34.58)];
                [bezierPath addCurveToPoint: CGPointMake(19.75, 44.26) controlPoint1: CGPointMake(19.08, 38.45) controlPoint2: CGPointMake(19.4, 41.36)];
                [bezierPath addCurveToPoint: CGPointMake(20.28, 47.47) controlPoint1: CGPointMake(19.87, 45.33) controlPoint2: CGPointMake(20.02, 46.39)];
                [bezierPath addCurveToPoint: CGPointMake(23.06, 41.7) controlPoint1: CGPointMake(21.55, 45.7) controlPoint2: CGPointMake(22.38, 43.74)];
                [bezierPath addCurveToPoint: CGPointMake(23.16, 35.38) controlPoint1: CGPointMake(23.75, 39.62) controlPoint2: CGPointMake(23.88, 37.53)];
                [bezierPath addCurveToPoint: CGPointMake(23.98, 34.99) controlPoint1: CGPointMake(23.49, 35.22) controlPoint2: CGPointMake(23.72, 35.05)];
                [bezierPath addCurveToPoint: CGPointMake(28.25, 34.07) controlPoint1: CGPointMake(25.4, 34.67) controlPoint2: CGPointMake(26.82, 34.36)];
                [bezierPath addCurveToPoint: CGPointMake(29.46, 34.73) controlPoint1: CGPointMake(29.01, 33.91) controlPoint2: CGPointMake(29.17, 33.97)];
                [bezierPath addCurveToPoint: CGPointMake(29.93, 36.66) controlPoint1: CGPointMake(29.69, 35.35) controlPoint2: CGPointMake(29.86, 36.01)];
                [bezierPath addCurveToPoint: CGPointMake(28.75, 43.64) controlPoint1: CGPointMake(30.19, 39.1) controlPoint2: CGPointMake(29.68, 41.41)];
                [bezierPath addCurveToPoint: CGPointMake(23.03, 53.4) controlPoint1: CGPointMake(27.27, 47.16) controlPoint2: CGPointMake(25.23, 50.33)];
                [bezierPath addCurveToPoint: CGPointMake(22.17, 53.97) controlPoint1: CGPointMake(22.84, 53.67) controlPoint2: CGPointMake(22.46, 53.96)];
                [bezierPath addCurveToPoint: CGPointMake(15.03, 54) controlPoint1: CGPointMake(19.83, 54.02) controlPoint2: CGPointMake(17.49, 54)];
                [bezierPath addCurveToPoint: CGPointMake(13.49, 44.53) controlPoint1: CGPointMake(14.51, 50.78) controlPoint2: CGPointMake(13.99, 47.65)];
                [bezierPath addCurveToPoint: CGPointMake(12, 35.08) controlPoint1: CGPointMake(12.99, 41.41) controlPoint2: CGPointMake(12.4, 38.31)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(38.37, 45.72)];
                [bezierPath addCurveToPoint: CGPointMake(41.21, 48.8) controlPoint1: CGPointMake(38.38, 47.8) controlPoint2: CGPointMake(39.3, 48.75)];
                [bezierPath addCurveToPoint: CGPointMake(45.43, 47.88) controlPoint1: CGPointMake(42.69, 48.84) controlPoint2: CGPointMake(44.07, 48.4)];
                [bezierPath addCurveToPoint: CGPointMake(46.75, 47.34) controlPoint1: CGPointMake(45.8, 47.73) controlPoint2: CGPointMake(46.18, 47.57)];
                [bezierPath addCurveToPoint: CGPointMake(45.97, 52.45) controlPoint1: CGPointMake(46.49, 49.15) controlPoint2: CGPointMake(46.28, 50.81)];
                [bezierPath addCurveToPoint: CGPointMake(45.18, 53.12) controlPoint1: CGPointMake(45.92, 52.72) controlPoint2: CGPointMake(45.5, 53.03)];
                [bezierPath addCurveToPoint: CGPointMake(42.05, 53.85) controlPoint1: CGPointMake(44.15, 53.42) controlPoint2: CGPointMake(43.11, 53.75)];
                [bezierPath addCurveToPoint: CGPointMake(37.72, 53.88) controlPoint1: CGPointMake(40.62, 53.98) controlPoint2: CGPointMake(39.14, 54.06)];
                [bezierPath addCurveToPoint: CGPointMake(31.74, 47.78) controlPoint1: CGPointMake(34.3, 53.45) controlPoint2: CGPointMake(32.15, 51.27)];
                [bezierPath addCurveToPoint: CGPointMake(34.04, 38.05) controlPoint1: CGPointMake(31.32, 44.29) controlPoint2: CGPointMake(31.95, 40.99)];
                [bezierPath addCurveToPoint: CGPointMake(44.6, 34.35) controlPoint1: CGPointMake(36.45, 34.65) controlPoint2: CGPointMake(40.9, 33.31)];
                [bezierPath addCurveToPoint: CGPointMake(46.79, 42.8) controlPoint1: CGPointMake(48.43, 35.42) controlPoint2: CGPointMake(49.6, 39.99)];
                [bezierPath addCurveToPoint: CGPointMake(41.48, 45.3) controlPoint1: CGPointMake(45.32, 44.27) controlPoint2: CGPointMake(43.45, 44.9)];
                [bezierPath addCurveToPoint: CGPointMake(38.37, 45.72) controlPoint1: CGPointMake(40.48, 45.5) controlPoint2: CGPointMake(39.45, 45.58)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(38.49, 42.08)];
                [bezierPath addCurveToPoint: CGPointMake(42.3, 40.96) controlPoint1: CGPointMake(40.01, 42.18) controlPoint2: CGPointMake(41.22, 41.79)];
                [bezierPath addCurveToPoint: CGPointMake(42.73, 40.36) controlPoint1: CGPointMake(42.49, 40.82) controlPoint2: CGPointMake(42.63, 40.58)];
                [bezierPath addCurveToPoint: CGPointMake(42.52, 38.87) controlPoint1: CGPointMake(42.96, 39.83) controlPoint2: CGPointMake(42.92, 39.31)];
                [bezierPath addCurveToPoint: CGPointMake(41.16, 38.52) controlPoint1: CGPointMake(42.16, 38.46) controlPoint2: CGPointMake(41.68, 38.36)];
                [bezierPath addCurveToPoint: CGPointMake(40.36, 38.85) controlPoint1: CGPointMake(40.88, 38.6) controlPoint2: CGPointMake(40.59, 38.69)];
                [bezierPath addCurveToPoint: CGPointMake(38.49, 42.08) controlPoint1: CGPointMake(39.31, 39.6) controlPoint2: CGPointMake(38.62, 40.57)];
                [bezierPath addLineToPoint: CGPointMake(38.49, 42.08)];
                [bezierPath closePath];
                bezierPath.miterLimit = 4;
                
                bezierPath.usesEvenOddFillRule = YES;
                
                [color setFill];
                [bezierPath fill];
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
