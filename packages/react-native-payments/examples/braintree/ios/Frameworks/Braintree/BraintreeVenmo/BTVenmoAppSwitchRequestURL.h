#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BTClientMetadata;

@interface BTVenmoAppSwitchRequestURL : NSObject

/*!
 @brief The base app switch URL for Venmo. Does not include specific parameters.
*/
+ (NSURL *)baseAppSwitchURL;

/*!
 Create an app switch URL

 @param merchantID      The merchant ID
 @param accessToken     The access token used by the venmo app to tokenize on behalf of the merchant
 @param scheme          The return URL scheme, e.g. "com.yourcompany.Your-App.payments"
 @param bundleName      The bundle display name for the current app
 @param environment     The environment, e.g. "production" or "sandbox"
 @param metadata        Additional braintree metadata

 @return The resulting URL, or `nil` if any of the parameters are `nil`.
*/
+ (nullable NSURL *)appSwitchURLForMerchantID:(NSString *)merchantID
                                  accessToken:(NSString *)accessToken
                              returnURLScheme:(NSString *)scheme
                            bundleDisplayName:(NSString *)bundleName
                                  environment:(NSString *)environment
                                     metadata:(BTClientMetadata *)metadata;

@end

NS_ASSUME_NONNULL_END
