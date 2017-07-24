#import "BTPaymentButton.h"

@interface BTPaymentButton ()

/*!
 @discussion Defaults to [UIApplication sharedApplication], but exposed for unit tests to inject test doubles
 to prevent calls to openURL. Its type is `id` and not `UIApplication` because trying to subclass
 UIApplication is not possible, since it enforces that only one instance can ever exist
*/
@property (nonatomic, strong) id application;

@end
