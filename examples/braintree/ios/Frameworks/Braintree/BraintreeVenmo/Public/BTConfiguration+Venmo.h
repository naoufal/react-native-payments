#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

@interface BTConfiguration (Venmo)

/*!
 @discussion Force Venmo to be enabled. If false, Drop-In will not display the Venmo button and [BTVenmoDriver authorizationWithCompletion:] will return an error.
 When set to true the Venmo button will be visible if it is also setup properly.
 Defaults to false during the limited availability phase.
*/
+ (void)enableVenmo:(BOOL)isEnabled DEPRECATED_MSG_ATTRIBUTE("Pay with Venmo no longer relies on a user whitelist, thus this method is not needed");

/*!
 @brief Indicates whether Venmo is enabled for the merchant account.
*/
@property (nonatomic, readonly, assign) BOOL isVenmoEnabled;

/*!
 @brief Returns the Access Token used by the Venmo app to tokenize on behalf of the merchant
*/
@property (nonatomic, readonly, assign) NSString *venmoAccessToken;

@end
