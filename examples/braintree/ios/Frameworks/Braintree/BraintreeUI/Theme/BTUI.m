#import "BTUI.h"
#import "BTUIUtil.h"
#import "UIColor+BTUI.h"

#import "BTUIMasterCardVectorArtView.h"
#import "BTUIJCBVectorArtView.h"
#import "BTUIMaestroVectorArtView.h"
#import "BTUIVisaVectorArtView.h"
#import "BTUIDiscoverVectorArtView.h"
#import "BTUIUnknownCardVectorArtView.h"
#import "BTUIDinersClubVectorArtView.h"
#import "BTUIAmExVectorArtView.h"
#import "BTUIPayPalMonogramCardView.h"
#import "BTUICoinbaseMonogramCardView.h"
#import "BTUIVenmoMonogramCardView.h"
#import "BTUIUnionPayVectorArtView.h"

@implementation BTUI

+ (BTUI *)braintreeTheme {
    static BTUI *_sharedBraintreeTheme;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBraintreeTheme = [[BTUI alloc] init];
    });
    return _sharedBraintreeTheme;
}

- (UIColor *)idealGray {
    return [UIColor bt_colorWithBytesR:128 G:128 B:128];
}

- (UIColor *)viewBackgroundColor {
    return [UIColor bt_colorFromHex:@"f3f4f6" alpha:1.0f];
}

- (UIColor *)callToActionColor {
    return [UIColor bt_colorWithBytesR:7 G:158 B:222];
}

- (UIColor *)callToActionColorHighlighted {
    return [UIColor colorWithRed:0.375 green:0.635 blue:0.984 alpha:1.000];
}

- (UIColor *)disabledButtonColor {
    return [UIColor bt_colorFromHex:@"#BCBFC4" alpha:1.0f];
}

- (UIColor *)titleColor {
    return [UIColor bt_colorWithBytesR:46 G:51 B:58];
}

- (UIColor *)detailColor {
    return [UIColor bt_colorWithBytesR:98 G:102 B:105];
}

- (UIColor *)borderColor {
    return [UIColor bt_colorWithBytesR:216 G:216 B:216];
}

- (UIColor *)textFieldTextColor {
    return [UIColor bt_colorWithBytesR:26 G:26 B:26];
}

- (UIColor *)textFieldPlaceholderColor {
    return [self idealGray];
}

- (UIColor *)sectionHeaderTextColor {
    return [self idealGray];
}

- (UIColor *)textFieldFloatLabelTextColor {
    return [self sectionHeaderTextColor];
}

- (UIColor *)defaultTintColor {
    return [self palBlue];
}

- (UIColor *)cardHintBorderColor {
    return [UIColor bt_colorWithBytesR:0 G:0 B:0 A:20];
}

- (UIColor *)errorBackgroundColor {
    return [UIColor bt_colorWithBytesR:250 G:229 B:232];
}

- (UIColor *)errorForegroundColor {
    return [UIColor bt_colorWithBytesR:208 G:2 B:27];
}

#pragma mark PayPal Colors

- (UIColor *)payBlue {
    return [UIColor bt_colorFromHex:@"003087" alpha:1.0f];
}

- (UIColor *)palBlue {
    return [UIColor bt_colorFromHex:@"009CDE" alpha:1.0f];
}

- (UIColor *)payPalButtonBlue {
    return [UIColor bt_colorWithBytesR:12 G:141 B:196];
}

- (UIColor *)payPalButtonActiveBlue {
    return [UIColor bt_colorWithBytesR:1 G:156 B:222];
}

#pragma mark Venmo Color

- (UIColor *)venmoPrimaryBlue {
    return [UIColor bt_colorFromHex:@"3D95CE" alpha:1.0f];
}

#pragma mark Coinbase Color

- (UIColor *)coinbasePrimaryBlue {
    return [UIColor colorWithRed: 0.053 green: 0.433 blue: 0.7 alpha: 1];
}

#pragma mark Adjustments

- (CGFloat)highlightedBrightnessAdjustment {
    return 0.6;
}

#pragma mark - Appearance

- (CGFloat)cornerRadius {
    return 4.0f;
}

- (CGFloat)borderWidth {
    CGFloat screenScale = [UIScreen mainScreen].scale;
    return 1 / screenScale;
}

- (CGFloat)formattedEntryKerning {
    return 8.0f;
}

- (CGFloat)horizontalMargin {
    return 17.0f;
}

- (CGFloat)paymentButtonMinHeight {
    return 44.0f;
}

- (CGFloat)paymentButtonMaxHeight {
    return 60.0f;
}

- (CGFloat)paymentButtonWordMarkHeight {
    return 18.0f;
}


#pragma mark - Type

- (UIFont *)controlFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
}

- (UIFont *)controlTitleFont {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f];
}

- (UIFont *)controlDetailFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
}

- (UIFont *)textFieldFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
}

- (UIFont *)textFieldFloatLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
}

- (UIFont *)sectionHeaderFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
}

#pragma mark - String Attributes

- (NSDictionary *)textFieldTextAttributes {
    return @{NSFontAttributeName: self.textFieldFont,
             NSForegroundColorAttributeName: self.textFieldTextColor};
}

- (NSDictionary *)textFieldPlaceholderAttributes {
    return @{NSFontAttributeName: self.textFieldFont,
             NSForegroundColorAttributeName: self.textFieldPlaceholderColor};
}

#pragma mark Transitions

- (CGFloat)quickTransitionDuration {
    return 0.1f;
}

- (CGFloat)transitionDuration {
    return 0.2f;
}

- (CGFloat)minimumVisibilityTime {
    return 0.5f;
}

#pragma mark Icons

+ (BTUIPaymentOptionType)paymentOptionTypeForPaymentInfoType:(NSString *)typeString {
    if ([typeString isEqualToString:@"Visa"]) {
        return BTUIPaymentOptionTypeVisa;
    } else if ([typeString isEqualToString:@"MasterCard"]) {
        return BTUIPaymentOptionTypeMasterCard;
    } else if ([typeString isEqualToString:@"Coinbase"]) {
        return BTUIPaymentOptionTypeCoinbase;
    } else if ([typeString isEqualToString:@"PayPal"]) {
        return BTUIPaymentOptionTypePayPal;
    } else if ([typeString isEqualToString:@"DinersClub"]) {
        return BTUIPaymentOptionTypeDinersClub;
    } else if ([typeString isEqualToString:@"JCB"]) {
        return BTUIPaymentOptionTypeJCB;
    } else if ([typeString isEqualToString:@"Maestro"]) {
        return BTUIPaymentOptionTypeMaestro;
    } else if ([typeString isEqualToString:@"Discover"]) {
        return BTUIPaymentOptionTypeDiscover;
    } else if ([typeString isEqualToString:@"UKMaestro"]) {
        return BTUIPaymentOptionTypeUKMaestro;
    } else if ([typeString isEqualToString:@"AMEX"]) {
        return BTUIPaymentOptionTypeAMEX;
    } else if ([typeString isEqualToString:@"Solo"]) {
        return BTUIPaymentOptionTypeSolo;
    } else if ([typeString isEqualToString:@"Laser"]) {
        return BTUIPaymentOptionTypeLaser;
    } else if ([typeString isEqualToString:@"Switch"]) {
        return BTUIPaymentOptionTypeSwitch;
    } else if ([typeString isEqualToString:@"UnionPay"]) {
        return BTUIPaymentOptionTypeUnionPay;
    } else if ([typeString isEqualToString:@"Venmo"]) {
        return BTUIPaymentOptionTypeVenmo;
    } else {
        return BTUIPaymentOptionTypeUnknown;
    }
}

- (BTUIVectorArtView *)vectorArtViewForPaymentInfoType:(NSString *)typeString {
    return [self vectorArtViewForPaymentOptionType:[BTUI paymentOptionTypeForPaymentInfoType:typeString]];
}

- (BTUIVectorArtView *)vectorArtViewForPaymentOptionType:(BTUIPaymentOptionType)type {
    switch (type) {
        case BTUIPaymentOptionTypeVisa:
            return [BTUIVisaVectorArtView new];
        case BTUIPaymentOptionTypeMasterCard:
            return [BTUIMasterCardVectorArtView new];
        case BTUIPaymentOptionTypeCoinbase:
            return [BTUICoinbaseMonogramCardView new];
        case BTUIPaymentOptionTypePayPal:
            return [BTUIPayPalMonogramCardView new];
        case BTUIPaymentOptionTypeDinersClub:
            return [BTUIDinersClubVectorArtView new];
        case BTUIPaymentOptionTypeJCB:
            return [BTUIJCBVectorArtView new];
        case BTUIPaymentOptionTypeMaestro:
            return [BTUIMaestroVectorArtView new];
        case BTUIPaymentOptionTypeDiscover:
            return [BTUIDiscoverVectorArtView new];
        case BTUIPaymentOptionTypeUKMaestro:
            return [BTUIMaestroVectorArtView new];
        case BTUIPaymentOptionTypeAMEX:
            return [BTUIAmExVectorArtView new];
        case BTUIPaymentOptionTypeVenmo:
            return [BTUIVenmoMonogramCardView new];
        case BTUIPaymentOptionTypeUnionPay:
            return [BTUIUnionPayVectorArtView new];
        case BTUIPaymentOptionTypeSolo:
        case BTUIPaymentOptionTypeLaser:
        case BTUIPaymentOptionTypeSwitch:
        case BTUIPaymentOptionTypeUnknown:
            return [BTUIUnknownCardVectorArtView new];
    }
}

#pragma mark Utilties

+ (UIActivityIndicatorViewStyle)activityIndicatorViewStyleForBarTintColor:(UIColor *)color {
    CGFloat r, g, b;
    [color getRed:&r green:&g blue:&b alpha:NULL];
    CGFloat perceivedBrightnessBasedOnWeightedDistanceIn3DRGBSpace = sqrtf(r * r * .241 + g * g * .691 + b * b * .068);

    return perceivedBrightnessBasedOnWeightedDistanceIn3DRGBSpace > 0.5 ? UIActivityIndicatorViewStyleGray : UIActivityIndicatorViewStyleWhite;
}

@end

