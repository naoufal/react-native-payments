#import "BTDropInLocalizedString.h"

@implementation BTDropInLocalizedString

+ (NSBundle *)localizationBundle {

    static NSString * bundleName = @"Braintree-Drop-In-Localization";
    NSString *localizationBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if (!localizationBundlePath) {
        localizationBundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:bundleName ofType:@"bundle"];
    }
    
    return localizationBundlePath ? [NSBundle bundleWithPath:localizationBundlePath] : [NSBundle mainBundle];
}

+ (NSString *)localizationTable {
    return @"Drop-In";
}

+ (NSString *)DROP_IN_CHANGE_PAYMENT_METHOD_BUTTON_TEXT {
    return NSLocalizedStringWithDefaultValue(@"DROP_IN_CHANGE_PAYMENT_METHOD_BUTTON_TEXT", [self localizationTable], [self localizationBundle], @"Change payment method", @"Title text for button on Drop In with a selected payment method that allows user to choose a different payment method on file");
}

+ (NSString *)ERROR_ALERT_OK_BUTTON_TEXT {
    return NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_OK_BUTTON_TEXT", [self localizationTable], [self localizationBundle], @"OK", @"Button text to indicate acceptance of an alert condition");
}


+ (NSString *)ERROR_ALERT_CANCEL_BUTTON_TEXT {
    return NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_CANCEL_BUTTON_TEXT", [self localizationTable], [self localizationBundle], @"Cancel", @"Button text to indicate acceptance of an alert condition");
}

+ (NSString *)ERROR_ALERT_TRY_AGAIN_BUTTON_TEXT {
    return NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_TRY_AGAIN_BUTTON_TEXT", [self localizationTable], [self localizationBundle], @"Try Again", @"Button text to request that an failed operation should be restarted and to try again");
}

+ (NSString *)ERROR_ALERT_CONNECTION_ERROR {
    return NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_CONNECTION_ERROR", [self localizationTable], [self localizationBundle], @"Connection Error", @"Vague title for alert view that ambiguously indicates an unspecified failure");
}

+ (NSString *)DEFAULT_CALL_TO_ACTION {
    return NSLocalizedStringWithDefaultValue(@"DEFAULT_CALL_TO_ACTION", [self localizationTable], [self localizationBundle], @"Pay", @"Default text to display in Drop In view controller call to action (Submit button)");
}

+ (NSString *)CARD_FORM_SECTION_HEADER {
    return NSLocalizedStringWithDefaultValue(@"CARD_FORM_SECTION_HEADER", [self localizationTable], [self localizationBundle], @"Pay with a card", @"Section header above card form in Drop In view controller");
}

+ (NSString *)SELECT_PAYMENT_METHOD_TITLE {
    return NSLocalizedStringWithDefaultValue(@"SELECT_PAYMENT_METHOD_TITLE", [self localizationTable], [self localizationBundle], @"Payment Method", @"Title for select payment method view controller");
}

+ (NSString *)ERROR_SAVING_CARD_ALERT_TITLE{
    return NSLocalizedStringWithDefaultValue(@"ERROR_SAVING_CARD_ALERT_TITLE", [self localizationTable], [self localizationBundle], @"Error Saving Card", @"Title for alert view that is displayed when Drop In submission fails because there was an error saving the card");
}

+ (NSString *)ERROR_SAVING_CARD_MESSAGE {
    return NSLocalizedStringWithDefaultValue(@"ERROR_SAVING_CARD_MESSAGE", [self localizationTable], [self localizationBundle], @"Please try again.", @"Message for alert view that is displayed when Drop In submission fails because there was an error saving the card");
}

+ (NSString *)ERROR_SAVING_PAYMENT_METHOD_ALERT_TITLE {
    return NSLocalizedStringWithDefaultValue(@"ERROR_SAVING_PAYMENT_METHOD_ALERT_TITLE", [self localizationTable], [self localizationBundle], @"PayPal Error", @"Title for alert view that is displayed when Drop In submission fails because there was an error saving the PayPal account");
}


+ (NSString *)ERROR_SAVING_PAYPAL_ACCOUNT_ALERT_MESSAGE {
    return NSLocalizedStringWithDefaultValue(@"ERROR_SAVING_PAYPAL_ACCOUNT_ALERT_MESSAGE", [self localizationTable], [self localizationBundle], @"Please try again.", @"Message for alert view that is displayed when Drop In submission fails because there was an error saving the PayPal account");
}

+ (NSString *)ADD_PAYMENT_METHOD_VIEW_CONTROLLER_TITLE {
    return NSLocalizedStringWithDefaultValue(@"ADD_PAYMENT_METHOD_VIEW_CONTROLLER_TITLE", [self localizationTable], [self localizationBundle], @"Add Payment Method", @"Title for view controller presented by Drop In to collect a new payment method when payment methods are already on file");
}

@end
