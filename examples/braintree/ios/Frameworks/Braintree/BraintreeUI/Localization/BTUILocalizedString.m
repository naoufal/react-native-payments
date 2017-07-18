#import "BTUILocalizedString.h"

@implementation BTUILocalizedString

+ (NSBundle *)localizationBundle {

    static NSString * bundleName = @"Braintree-UI-Localization";
    NSString *localizationBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if (!localizationBundlePath) {
        localizationBundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:bundleName ofType:@"bundle"];
    }
    
    return localizationBundlePath ? [NSBundle bundleWithPath:localizationBundlePath] : [NSBundle mainBundle];
}

+ (NSString *)localizationTable {
    return @"UI";
}

+ (NSString *)CVV_FIELD_PLACEHOLDER {
    return NSLocalizedStringWithDefaultValue(@"CVV_FIELD_PLACEHOLDER", [self localizationTable], [self localizationBundle], @"CVV", @"CVV (credit card security code) field placeholder");
}

+ (NSString *)CARD_NUMBER_PLACEHOLDER {
    return NSLocalizedStringWithDefaultValue(@"CARD_NUMBER_PLACEHOLDER", [self localizationTable], [self localizationBundle], @"Card Number", @"Credit card number field placeholder");
}

+ (NSString *)PHONE_NUMBER_PLACEHOLDER {
    return NSLocalizedStringWithDefaultValue(@"PHONE_NUMBER_PLACEHOLDER", [self localizationTable], [self localizationBundle], @"Phone Number", @"Phone number field placeholder");
}

+ (NSString *)EXPIRY_PLACEHOLDER_FOUR_DIGIT_YEAR {
    return NSLocalizedStringWithDefaultValue(@"EXPIRY_PLACEHOLDER_FOUR_DIGIT_YEAR", [self localizationTable], [self localizationBundle], @"MM/YYYY", @"Credit card expiration date field placeholder (MM/YYYY format)");
}

+ (NSString *)EXPIRY_PLACEHOLDER_TWO_DIGIT_YEAR {
    return NSLocalizedStringWithDefaultValue(@"EXPIRY_PLACEHOLDER_TWO_DIGIT_YEAR", [self localizationTable], [self localizationBundle], @"MM/YY", @"Credit card expiration date field placeholder (MM/YY format)");
}

+ (NSString *)PAYPAL_CARD_BRAND {
    return NSLocalizedStringWithDefaultValue(@"PAYPAL_CARD_BRAND", [self localizationTable], [self localizationBundle], @"PayPal", @"PayPal payment method name");
}

+ (NSString *)POSTAL_CODE_PLACEHOLDER {
    return NSLocalizedStringWithDefaultValue(@"POSTAL_CODE_PLACEHOLDER", [self localizationTable], [self localizationBundle], @"Postal Code", @"Credit card billing postal code field placeholder");
}

+ (NSString *)TOP_LEVEL_ERROR_ALERT_VIEW_OK_BUTTON_TEXT {
    return NSLocalizedStringWithDefaultValue(@"TOP_LEVEL_ERROR_ALERT_VIEW_OK_BUTTON_TEXT", [self localizationTable], [self localizationBundle], @"OK", @"OK Button on card form alert view for top level errors");
}

+ (NSString *)CARD_TYPE_AMERICAN_EXPRESS {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_AMERICAN_EXPRESS", [self localizationTable], [self localizationBundle], @"American Express", @"American Express card brand");
}

+ (NSString *)CARD_TYPE_DINERS_CLUB {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_DINERS_CLUB", [self localizationTable], [self localizationBundle], @"Diners Club", @"Diners Club card brand");
}

+ (NSString *)CARD_TYPE_DISCOVER {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_DISCOVER", [self localizationTable], [self localizationBundle], @"Discover", @"Discover card brand");
}

+ (NSString *)CARD_TYPE_MASTER_CARD {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_MASTER_CARD", [self localizationTable], [self localizationBundle], @"MasterCard", @"MasterCard card brand");
}

+ (NSString *)CARD_TYPE_VISA {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_VISA", [self localizationTable], [self localizationBundle], @"Visa", @"Visa card brand");
}

+ (NSString *)CARD_TYPE_JCB {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_JCB", [self localizationTable], [self localizationBundle], @"JCB", @"JCB card brand");
}

+ (NSString *)CARD_TYPE_MAESTRO {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_MAESTRO", [self localizationTable], [self localizationBundle], @"Maestro", @"Maestro card brand");
}

+ (NSString *)CARD_TYPE_UNION_PAY {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_UNION_PAY", [self localizationTable], [self localizationBundle], @"UnionPay", @"UnionPay card brand");
}

+ (NSString *)CARD_TYPE_LASER {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_LASER", [self localizationTable], [self localizationBundle], @"Laser", @"Laser card brand");
}

+ (NSString *)CARD_TYPE_SOLO {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_SOLO", [self localizationTable], [self localizationBundle], @"Solo", @"Solo card brand");
}

+ (NSString *)CARD_TYPE_SWITCH {
    return NSLocalizedStringWithDefaultValue(@"CARD_TYPE_SWITCH", [self localizationTable], [self localizationBundle], @"Switch", @"Switch card brand");
}

+ (NSString *)PAYMENT_METHOD_TYPE_PAYPAL {
    return NSLocalizedStringWithDefaultValue(@"PAYPAL", [self localizationTable], [self localizationBundle], @"PayPal", @"PayPal (as a standalone term, referring to the payment method type, analogous to Visa or Discover)");
}

+ (NSString *)PAYMENT_METHOD_TYPE_COINBASE {
    return NSLocalizedStringWithDefaultValue(@"COINBASE", [self localizationTable], [self localizationBundle], @"Coinbase", @"Coinbase (as a standalone term, referring to the bitcoin wallet company)");
}

+ (NSString *)PAYMENT_METHOD_TYPE_VENMO {
    return NSLocalizedStringWithDefaultValue(@"VENMO", [self localizationTable], [self localizationBundle], @"Venmo", @"Venmo (as a standalone term, referring to Venmo the company)");
}

@end
