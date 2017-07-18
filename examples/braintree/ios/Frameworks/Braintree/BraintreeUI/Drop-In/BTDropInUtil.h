#import "BTCardNonce.h"
#import "BTUIPaymentOptionType.h"

@interface BTDropInUtil : NSObject

+ (BTUIPaymentOptionType)uiForCardNetwork:(BTCardNetwork)cardNetwork;

/*!
 @brief Get the top view controller
 
 @return The top most UIViewController
 */
+ (UIViewController *)topViewController;

@end
