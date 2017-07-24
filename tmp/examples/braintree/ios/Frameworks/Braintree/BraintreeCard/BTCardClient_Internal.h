#import "BTCardClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTCardClient ()

/*!
 @brief Exposed for testing to get the instance of BTAPIClient
*/
@property (nonatomic, strong, readwrite) BTAPIClient *apiClient;

/*!
 @brief Convenience helper method for creating friendlier, more human-readable userInfo dictionaries for 422 HTTP errors
*/
+ (NSDictionary *)validationErrorUserInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
