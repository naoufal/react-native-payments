#import <Foundation/Foundation.h>
#import "BTClientMetadata.h"
#import "BTConfiguration.h"
#import "BTJSON.h"

@class BTPaymentMethodNonce;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const BTAPIClientErrorDomain;

typedef NS_ENUM(NSInteger, BTAPIClientErrorType) {
    BTAPIClientErrorTypeUnknown = 0,

    /// Configuration fetch failed
    BTAPIClientErrorTypeConfigurationUnavailable,

    /// The authorization provided to the API client is insufficient
    BTAPIClientErrorTypeNotAuthorized,
};

/*!
 @class BTAPIClient
 @brief This class acts as the entry point for accessing the Braintree APIs via common HTTP methods performed on API endpoints.
 @discussion It also manages authentication via tokenization key and provides access to a merchant's gateway configuration.
*/
@interface BTAPIClient : NSObject

/*!
 @brief Initialize a new API client.

 @param authorization Your tokenization key or client token. Passing an invalid value may return `nil`.
 @return A Braintree API client, or `nil` if initialization failed.
*/
- (nullable instancetype)initWithAuthorization:(NSString *)authorization;

/*!
 @brief Create a copy of an existing API client, but specify a new source and integration type.
 @discussion This provides a way to override an API client's source and integration metadata, which
 is captured and sent to Braintree as part of the analytics we track.
*/
- (instancetype)copyWithSource:(BTClientMetadataSourceType)source
                   integration:(BTClientMetadataIntegrationType)integration;

/*!
 @brief Provides configuration data as a `BTJSON` object.

 @discussion The configuration data can be used by supported payment options to configure themselves
 dynamically through the Control Panel. It also contains configuration options for the
 Braintree SDK Core components.

 @note This method is asynchronous because it requires a network call to fetch the
 configuration for a merchant account from Braintree servers. This configuration is
 cached on subsequent calls for better performance.
*/
- (void)fetchOrReturnRemoteConfiguration:(void (^)(BTConfiguration * _Nullable configuration, NSError * _Nullable error))completionBlock;

/*!
 @brief Fetches a customer's vaulted payment method nonces.

 @discussion Must be using client token with a customer ID specified.

 @param completion Callback that returns an array of payment method nonces.
 On success, `paymentMethodNonces` contains the nonces and `error` is `nil`. The default payment method nonce, if one exists, will be first.
 On failure, `error` contains the error that occured and `paymentMethodNonces` is `nil`.
*/
- (void)fetchPaymentMethodNonces:(void(^)(NSArray <BTPaymentMethodNonce *> * _Nullable paymentMethodNonces, NSError * _Nullable error))completion;

/*!
 @brief Fetches a customer's vaulted payment method nonces.

 @discussion Must be using client token with a customer ID specified.

 @param defaultFirst Specifies whether to sorts the fetched payment method nonces with the default payment method or the most recently used payment method first
 @param completion Callback that returns an array of payment method nonces
*/
- (void)fetchPaymentMethodNonces:(BOOL)defaultFirst
                      completion:(void(^)(NSArray <BTPaymentMethodNonce *> * _Nullable paymentMethodNonces, NSError * _Nullable error))completion;

/*!
 @brief Perfom an HTTP GET on a URL composed of the configured from environment and the given path.

 @param path The endpoint URI path.
 @param parameters Optional set of query parameters to be encoded with the request.
 @param completionBlock A block object to be executed when the request finishes.
 On success, `body` and `response` will contain the JSON body response and the
 HTTP response and `error` will be `nil`; on failure, `body` and `response` will be
 `nil` and `error` will contain the error that occurred.
*/
- (void)GET:(NSString *)path
 parameters:(nullable NSDictionary <NSString *, NSString *> *)parameters
 completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

/*!
 @brief Perfom an HTTP POST on a URL composed of the configured from environment and the given path.

 @param path The endpoint URI path.
 @param parameters Optional set of parameters to be JSON encoded and sent in the body of the request.
 @param completionBlock A block object to be executed when the request finishes.
 On success, `body` and `response` will contain the JSON body response and the
 HTTP response and `error` will be `nil`; on failure, `body` and `response` will be
 `nil` and `error` will contain the error that occurred.
*/
- (void)POST:(NSString *)path
  parameters:(nullable NSDictionary *)parameters
  completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

- (instancetype)init __attribute__((unavailable("Use initWithAuthorization: instead.")));

@end

NS_ASSUME_NONNULL_END
