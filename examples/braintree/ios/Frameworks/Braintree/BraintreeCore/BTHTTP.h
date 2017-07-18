#import <Foundation/Foundation.h>
#import "BTHTTPErrors.h"
#import "BTJSON.h"

NS_ASSUME_NONNULL_BEGIN

@class BTHTTPResponse, BTClientToken;

/*!
 @brief Performs HTTP methods on the Braintree Client API
*/
@interface BTHTTP : NSObject<NSCopying>

/*!
 @brief An optional array of pinned certificates, each an NSData instance consisting of DER encoded x509 certificates
*/
@property (nonatomic, nullable, strong) NSArray<NSData *> *pinnedCertificates;

/*!
 @brief Initialize `BTHTTP` with the authorization fingerprint from a client token

 @param URL The base URL for the Braintree Client API
 @param authorizationFingerprint The authorization fingerprint HMAC from a client token
*/
- (instancetype)initWithBaseURL:(NSURL *)URL
       authorizationFingerprint:(NSString *)authorizationFingerprint NS_DESIGNATED_INITIALIZER;

/*!
 @brief Initialize `BTHTTP` with a tokenization key

 @param URL The base URL for the Braintree Client API
 @param tokenizationKey A tokenization key
*/
- (instancetype)initWithBaseURL:(NSURL *)URL tokenizationKey:(NSString *)tokenizationKey NS_DESIGNATED_INITIALIZER;

/*!
 @brief A convenience initializer to initialize `BTHTTP` with a client token

 @param clientToken A client token
*/
- (instancetype)initWithClientToken:(BTClientToken *)clientToken;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability"
- (nullable instancetype)init __attribute__((unavailable("Please use initWithBaseURL:authorizationFingerprint: instead.")));
#pragma clang diagnostic pop

// For testing
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, readonly, strong) NSURL *baseURL;

/*!
 @brief Queue that callbacks are dispatched onto, main queue if not otherwise specified
*/
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;

- (void)GET:(NSString *)endpoint
 completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

- (void)GET:(NSString *)endpoint
 parameters:(nullable NSDictionary <NSString *, NSString *> *)parameters
 completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

- (void)POST:(NSString *)endpoint
  completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

- (void)POST:(NSString *)endpoint
  parameters:(nullable NSDictionary *)parameters
  completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

- (void)PUT:(NSString *)endpoint
 completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

- (void)PUT:(NSString *)endpoint
 parameters:(nullable NSDictionary *)parameters
 completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

- (void)DELETE:(NSString *)endpoint
    completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

- (void)DELETE:(NSString *)endpoint
    parameters:(nullable NSDictionary *)parameters
    completion:(nullable void(^)(BTJSON * _Nullable body, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
