#import "BTUICoinbaseWordmarkVectorArtView.h"

@implementation BTUICoinbaseWordmarkVectorArtView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (void)doSetup {
    self.artDimensions = CGSizeMake(162, 88);
    self.opaque = NO;
    self.color = [UIColor colorWithRed: 0.053 green: 0.433 blue: 0.7 alpha: 1]; // Default color
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawArt {
    //// Assets
    {
        //// button-coinbase
        {
            //// Rectangle Drawing


            //// logo/coinbase-2
            {
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(20.22, 54)];
                [bezierPath addCurveToPoint: CGPointMake(12, 43.98) controlPoint1: CGPointMake(16.06, 54) controlPoint2: CGPointMake(12, 50.93)];
                [bezierPath addCurveToPoint: CGPointMake(20.22, 34) controlPoint1: CGPointMake(12, 37.03) controlPoint2: CGPointMake(16.06, 34)];
                [bezierPath addCurveToPoint: CGPointMake(25, 35.32) controlPoint1: CGPointMake(22.26, 34) controlPoint2: CGPointMake(23.86, 34.53)];
                [bezierPath addLineToPoint: CGPointMake(23.75, 38.14)];
                [bezierPath addCurveToPoint: CGPointMake(20.7, 37.21) controlPoint1: CGPointMake(22.99, 37.56) controlPoint2: CGPointMake(21.85, 37.21)];
                [bezierPath addCurveToPoint: CGPointMake(15.92, 43.95) controlPoint1: CGPointMake(18.21, 37.21) controlPoint2: CGPointMake(15.92, 39.24)];
                [bezierPath addCurveToPoint: CGPointMake(20.7, 50.72) controlPoint1: CGPointMake(15.92, 48.65) controlPoint2: CGPointMake(18.27, 50.72)];
                [bezierPath addCurveToPoint: CGPointMake(23.75, 49.79) controlPoint1: CGPointMake(21.85, 50.72) controlPoint2: CGPointMake(22.99, 50.36)];
                [bezierPath addLineToPoint: CGPointMake(25, 52.68)];
                [bezierPath addCurveToPoint: CGPointMake(20.22, 54) controlPoint1: CGPointMake(23.82, 53.5) controlPoint2: CGPointMake(22.26, 54)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(36.07, 54)];
                [bezierPath addCurveToPoint: CGPointMake(27.62, 44.12) controlPoint1: CGPointMake(30.61, 54) controlPoint2: CGPointMake(27.62, 49.74)];
                [bezierPath addCurveToPoint: CGPointMake(36.07, 34.27) controlPoint1: CGPointMake(27.62, 38.49) controlPoint2: CGPointMake(30.61, 34.27)];
                [bezierPath addCurveToPoint: CGPointMake(44.52, 44.12) controlPoint1: CGPointMake(41.53, 34.27) controlPoint2: CGPointMake(44.52, 38.49)];
                [bezierPath addCurveToPoint: CGPointMake(36.07, 54) controlPoint1: CGPointMake(44.52, 49.74) controlPoint2: CGPointMake(41.53, 54)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(31, 44)];
                [bezierPath addCurveToPoint: CGPointMake(36, 51) controlPoint1: CGPointMake(31, 48.08) controlPoint2: CGPointMake(32.97, 51)];
                [bezierPath addCurveToPoint: CGPointMake(41, 44) controlPoint1: CGPointMake(39.03, 51) controlPoint2: CGPointMake(41, 48.08)];
                [bezierPath addCurveToPoint: CGPointMake(36, 37) controlPoint1: CGPointMake(41, 39.92) controlPoint2: CGPointMake(39.03, 37)];
                [bezierPath addCurveToPoint: CGPointMake(31, 44) controlPoint1: CGPointMake(32.97, 37) controlPoint2: CGPointMake(31, 39.92)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(51, 32)];
                [bezierPath addCurveToPoint: CGPointMake(49, 30) controlPoint1: CGPointMake(49.89, 32) controlPoint2: CGPointMake(49, 31.1)];
                [bezierPath addCurveToPoint: CGPointMake(51, 28) controlPoint1: CGPointMake(49, 28.9) controlPoint2: CGPointMake(49.89, 28)];
                [bezierPath addCurveToPoint: CGPointMake(53, 30) controlPoint1: CGPointMake(52.11, 28) controlPoint2: CGPointMake(53, 28.9)];
                [bezierPath addCurveToPoint: CGPointMake(51, 32) controlPoint1: CGPointMake(53, 31.1) controlPoint2: CGPointMake(52.11, 32)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(49, 54)];
                [bezierPath addLineToPoint: CGPointMake(49, 35)];
                [bezierPath addLineToPoint: CGPointMake(53, 35)];
                [bezierPath addLineToPoint: CGPointMake(53, 54)];
                [bezierPath addLineToPoint: CGPointMake(49, 54)];
                [bezierPath addLineToPoint: CGPointMake(49, 54)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(70, 41)];
                [bezierPath addCurveToPoint: CGPointMake(65.5, 37) controlPoint1: CGPointMake(70, 38.71) controlPoint2: CGPointMake(68.28, 37)];
                [bezierPath addCurveToPoint: CGPointMake(62, 38) controlPoint1: CGPointMake(64.01, 37) controlPoint2: CGPointMake(62.82, 37.67)];
                [bezierPath addLineToPoint: CGPointMake(62, 54)];
                [bezierPath addLineToPoint: CGPointMake(58, 54)];
                [bezierPath addLineToPoint: CGPointMake(58, 35.38)];
                [bezierPath addCurveToPoint: CGPointMake(65.5, 34) controlPoint1: CGPointMake(60, 34.58) controlPoint2: CGPointMake(62.38, 34)];
                [bezierPath addCurveToPoint: CGPointMake(74, 40.55) controlPoint1: CGPointMake(71.11, 34) controlPoint2: CGPointMake(74, 36.4)];
                [bezierPath addLineToPoint: CGPointMake(74, 54)];
                [bezierPath addLineToPoint: CGPointMake(70, 54)];
                [bezierPath addLineToPoint: CGPointMake(70, 41)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(78, 52.66)];
                [bezierPath addLineToPoint: CGPointMake(78, 26)];
                [bezierPath addLineToPoint: CGPointMake(81.9, 26)];
                [bezierPath addLineToPoint: CGPointMake(81.9, 35.15)];
                [bezierPath addCurveToPoint: CGPointMake(85.5, 34) controlPoint1: CGPointMake(82.83, 34.72) controlPoint2: CGPointMake(84.18, 34)];
                [bezierPath addCurveToPoint: CGPointMake(94, 43.69) controlPoint1: CGPointMake(90.48, 34) controlPoint2: CGPointMake(94, 37.89)];
                [bezierPath addCurveToPoint: CGPointMake(84.48, 54) controlPoint1: CGPointMake(94, 50.83) controlPoint2: CGPointMake(90.24, 54)];
                [bezierPath addCurveToPoint: CGPointMake(78, 52.66) controlPoint1: CGPointMake(81.97, 54) controlPoint2: CGPointMake(79.5, 53.4)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(85, 37)];
                [bezierPath addCurveToPoint: CGPointMake(82, 37.65) controlPoint1: CGPointMake(83.96, 37) controlPoint2: CGPointMake(82.73, 37.25)];
                [bezierPath addLineToPoint: CGPointMake(82, 50.49)];
                [bezierPath addCurveToPoint: CGPointMake(84.72, 51) controlPoint1: CGPointMake(82.56, 50.75) controlPoint2: CGPointMake(83.64, 51)];
                [bezierPath addCurveToPoint: CGPointMake(90, 43.82) controlPoint1: CGPointMake(87.76, 51) controlPoint2: CGPointMake(90, 48.82)];
                [bezierPath addCurveToPoint: CGPointMake(85, 37) controlPoint1: CGPointMake(90, 39.54) controlPoint2: CGPointMake(88.04, 37)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(97, 48)];
                [bezierPath addCurveToPoint: CGPointMake(108, 41.5) controlPoint1: CGPointMake(97, 42.72) controlPoint2: CGPointMake(102.19, 41.82)];
                [bezierPath addLineToPoint: CGPointMake(108, 40)];
                [bezierPath addCurveToPoint: CGPointMake(104.5, 37) controlPoint1: CGPointMake(108, 37.61) controlPoint2: CGPointMake(106.96, 37)];
                [bezierPath addCurveToPoint: CGPointMake(98.9, 38.24) controlPoint1: CGPointMake(102.68, 37) controlPoint2: CGPointMake(100.18, 37.64)];
                [bezierPath addLineToPoint: CGPointMake(97.9, 35.6)];
                [bezierPath addCurveToPoint: CGPointMake(104.5, 34) controlPoint1: CGPointMake(99.43, 34.93) controlPoint2: CGPointMake(101.93, 34)];
                [bezierPath addCurveToPoint: CGPointMake(111.99, 40.7) controlPoint1: CGPointMake(109.1, 34) controlPoint2: CGPointMake(111.99, 36.03)];
                [bezierPath addLineToPoint: CGPointMake(111.99, 52.66)];
                [bezierPath addCurveToPoint: CGPointMake(105.07, 54) controlPoint1: CGPointMake(110.6, 53.4) controlPoint2: CGPointMake(107.78, 54)];
                [bezierPath addCurveToPoint: CGPointMake(97, 48) controlPoint1: CGPointMake(99.54, 54) controlPoint2: CGPointMake(97, 51.73)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(100.5, 48)];
                [bezierPath addCurveToPoint: CGPointMake(105, 51) controlPoint1: CGPointMake(100.5, 50.01) controlPoint2: CGPointMake(102.04, 51)];
                [bezierPath addLineToPoint: CGPointMake(108, 51)];
                [bezierPath addLineToPoint: CGPointMake(108, 44)];
                [bezierPath addCurveToPoint: CGPointMake(100.5, 48) controlPoint1: CGPointMake(104.08, 44.21) controlPoint2: CGPointMake(100.5, 44.62)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(121.79, 54)];
                [bezierPath addCurveToPoint: CGPointMake(116, 52.65) controlPoint1: CGPointMake(119.62, 54) controlPoint2: CGPointMake(117.35, 53.39)];
                [bezierPath addLineToPoint: CGPointMake(117.28, 49.65)];
                [bezierPath addCurveToPoint: CGPointMake(121.69, 50.9) controlPoint1: CGPointMake(118.24, 50.26) controlPoint2: CGPointMake(120.28, 50.9)];
                [bezierPath addCurveToPoint: CGPointMake(125.07, 48.26) controlPoint1: CGPointMake(123.72, 50.9) controlPoint2: CGPointMake(125.07, 49.86)];
                [bezierPath addCurveToPoint: CGPointMake(121.76, 45.12) controlPoint1: CGPointMake(125.07, 46.51) controlPoint2: CGPointMake(123.66, 45.84)];
                [bezierPath addCurveToPoint: CGPointMake(116.48, 39.38) controlPoint1: CGPointMake(119.28, 44.16) controlPoint2: CGPointMake(116.48, 42.98)];
                [bezierPath addCurveToPoint: CGPointMake(123, 34) controlPoint1: CGPointMake(116.48, 36.21) controlPoint2: CGPointMake(118.86, 34)];
                [bezierPath addCurveToPoint: CGPointMake(128.41, 35.35) controlPoint1: CGPointMake(125.24, 34) controlPoint2: CGPointMake(127.1, 34.57)];
                [bezierPath addLineToPoint: CGPointMake(127.24, 38.06)];
                [bezierPath addCurveToPoint: CGPointMake(123.41, 36.92) controlPoint1: CGPointMake(126.41, 37.53) controlPoint2: CGPointMake(124.76, 36.92)];
                [bezierPath addCurveToPoint: CGPointMake(120.34, 39.38) controlPoint1: CGPointMake(121.45, 36.92) controlPoint2: CGPointMake(120.34, 37.99)];
                [bezierPath addCurveToPoint: CGPointMake(123.55, 42.45) controlPoint1: CGPointMake(120.34, 41.13) controlPoint2: CGPointMake(121.72, 41.74)];
                [bezierPath addCurveToPoint: CGPointMake(129, 48.3) controlPoint1: CGPointMake(126.14, 43.45) controlPoint2: CGPointMake(129, 44.55)];
                [bezierPath addCurveToPoint: CGPointMake(121.79, 54) controlPoint1: CGPointMake(129, 51.75) controlPoint2: CGPointMake(126.45, 54)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(136, 46)];
                [bezierPath addCurveToPoint: CGPointMake(142.08, 50.94) controlPoint1: CGPointMake(136.39, 49.41) controlPoint2: CGPointMake(138.84, 50.94)];
                [bezierPath addCurveToPoint: CGPointMake(147.39, 49.78) controlPoint1: CGPointMake(144.01, 50.94) controlPoint2: CGPointMake(146.08, 50.48)];
                [bezierPath addLineToPoint: CGPointMake(148.54, 52.66)];
                [bezierPath addCurveToPoint: CGPointMake(141.83, 54) controlPoint1: CGPointMake(147.04, 53.44) controlPoint2: CGPointMake(144.47, 54)];
                [bezierPath addCurveToPoint: CGPointMake(132, 44.04) controlPoint1: CGPointMake(135.77, 54) controlPoint2: CGPointMake(132, 50.1)];
                [bezierPath addCurveToPoint: CGPointMake(141, 34) controlPoint1: CGPointMake(132, 38.24) controlPoint2: CGPointMake(135.62, 34)];
                [bezierPath addCurveToPoint: CGPointMake(149, 42.6) controlPoint1: CGPointMake(145.99, 34) controlPoint2: CGPointMake(149, 37.5)];
                [bezierPath addCurveToPoint: CGPointMake(148.96, 44.04) controlPoint1: CGPointMake(149, 43.06) controlPoint2: CGPointMake(149, 43.55)];
                [bezierPath addLineToPoint: CGPointMake(136, 46)];
                [bezierPath closePath];
                [bezierPath moveToPoint: CGPointMake(140.98, 37.08)];
                [bezierPath addCurveToPoint: CGPointMake(135.95, 43.27) controlPoint1: CGPointMake(137.98, 37.08) controlPoint2: CGPointMake(136.02, 39.33)];
                [bezierPath addLineToPoint: CGPointMake(145.26, 42)];
                [bezierPath addCurveToPoint: CGPointMake(140.98, 37.08) controlPoint1: CGPointMake(145.22, 38.7) controlPoint2: CGPointMake(143.54, 37.08)];
                [bezierPath addLineToPoint: CGPointMake(140.98, 37.08)];
                [bezierPath closePath];
                bezierPath.miterLimit = 4;
                
                bezierPath.usesEvenOddFillRule = YES;
                
                [self.color setFill];
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

    [self addConstraints:@[aspectRatioConstraint]];

    [super updateConstraints];
}

- (UILayoutPriority)contentCompressionResistancePriorityForAxis:(__unused UILayoutConstraintAxis)axis {
    return UILayoutPriorityRequired;
}

@end
