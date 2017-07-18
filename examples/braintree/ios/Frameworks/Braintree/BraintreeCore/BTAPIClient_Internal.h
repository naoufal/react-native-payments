#import "BTAnalyticsService.h"
#import "BTAPIClient.h"
#import "BTClientMetadata.h"
#import "BTClientToken.h"
#import "BTHTTP.h"
#import "BTJSON.h"

NS_ASSUME_NONNULL_BEGIN

@class BTPaymentMethodNonce;

@interface BTAPIClient ()

@property (nonatomic, copy, nullable) NSString *tokenizationKey;
@property (nonatomic, strong, nullable) BTClientToken *clientToken;
@property (nonatomic, strong) BTHTTP *http;
@property (nonatomic, strong) BTHTTP *configurationHTTP;

/*!
 @brief Client metadata that is used for tracking the client session
*/
@property (nonatomic, readonly, strong) BTClientMetadata *metadata;

/*!
 @brief Exposed for testing analytics
*/
@property (nonatomic, strong) BTAnalyticsService *analyticsService;

/*!
 @brief Analytics should only be posted by internal clients.
*/
- (void)sendAnalyticsEvent:(NSString *)eventName;

/*!
 @brief An internal initializer to toggle whether to send an analytics event during initialization.
 @discussion This prevents copyWithSource:integration: from sending a duplicate event. It can also be used to suppress excessive network chatter during testing.
*/

- (nullable instancetype)initWithAuthorization:(NSString *)authorization sendAnalyticsEvent:(BOOL)sendAnalyticsEvent;

@end

NS_ASSUME_NONNULL_END
