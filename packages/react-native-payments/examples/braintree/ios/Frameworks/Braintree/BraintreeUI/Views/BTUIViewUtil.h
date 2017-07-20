#import <UIKit/UIKit.h>

#import "BTUICardType.h"
#import "BTUIPaymentOptionType.h"

/*!
 @class BTUIViewUtil
 @brief Utilities used by other views
*/
@interface BTUIViewUtil : NSObject

+ (BTUIPaymentOptionType)paymentMethodTypeForCardType:(BTUICardType *)cardType;
+ (NSString *)nameForPaymentMethodType:(BTUIPaymentOptionType)paymentMethodType;

+ (void)vibrate;

@end
