#import "BTThreeDSecureLocalizedString.h"

@implementation BTThreeDSecureLocalizedString

+ (NSBundle *)localizationBundle {

    static NSString * bundleName = @"Braintree-3D-Secure-Localization";
    NSString *localizationBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if (!localizationBundlePath) {
        localizationBundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:bundleName ofType:@"bundle"];
    }
    
    return localizationBundlePath ? [NSBundle bundleWithPath:localizationBundlePath] : [NSBundle mainBundle];
}

+ (NSString *)localizationTable {
    return @"Three-D-Secure";
}

+ (NSString *)ERROR_ALERT_OK_BUTTON_TEXT {
    return NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_OK_BUTTON_TEXT", [self localizationTable], [self localizationBundle], @"OK", @"Button text to indicate acceptance of an alert condition");
}


+ (NSString *)ERROR_ALERT_CANCEL_BUTTON_TEXT {
    return NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_CANCEL_BUTTON_TEXT", [self localizationTable], [self localizationBundle], @"Cancel", @"Button text to indicate acceptance of an alert condition");
}

@end
