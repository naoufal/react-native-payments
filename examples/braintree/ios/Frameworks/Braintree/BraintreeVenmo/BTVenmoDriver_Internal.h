#import <UIKit/UIKit.h>
#import "BTVenmoDriver.h"

@interface BTVenmoDriver ()

/*!
 @discussion Defaults to [UIApplication sharedApplication], but exposed for unit tests to inject test doubles
 to prevent calls to openURL. Its type is `id` and not `UIApplication` because trying to subclass
 UIApplication is not possible, since it enforces that only one instance can ever exist
*/
@property (nonatomic, strong) id application;

/*!
 @brief Defaults to [NSBundle mainBundle], but exposed for unit tests to inject test doubles to stub values in infoDictionary
*/
@property (nonatomic, strong) NSBundle *bundle;

/*!
 @brief Defaults to [UIDevice currentDevice], but exposed for unit tests to inject different devices
 */
@property (nonatomic, strong) UIDevice *device;

/*!
 @brief Defaults to use [BTAppSwitchHandler sharedInstance].returnURLScheme, but exposed for unit tests to stub returnURLScheme.
*/
@property (nonatomic, copy) NSString *returnURLScheme;

/*!
 @brief Exposed for testing to get the instance of BTAPIClient after it has been copied by `copyWithSource:integration:`
*/
@property (nonatomic, strong) BTAPIClient *apiClient;

/*!
 @brief Stored property used to determine whether a venmo account nonce should be vaulted after an app switch return
 */
@property (nonatomic, assign) BOOL shouldVault;

@end
