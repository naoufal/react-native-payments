#import <Foundation/Foundation.h>
#import "BTHTTP.h"

@interface BTFakeHTTP : BTHTTP

@property (nonatomic, assign) NSUInteger GETRequestCount;
@property (nonatomic, assign) NSUInteger POSTRequestCount;
@property (nonatomic, copy, nullable) NSString *lastRequestEndpoint;
@property (nonatomic, copy, nullable) NSString *lastRequestMethod;
@property (nonatomic, strong, nullable) NSDictionary *lastRequestParameters;
@property (nonatomic, copy, nullable) NSString *stubMethod;
@property (nonatomic, copy, nullable) NSString *stubEndpoint;
@property (nonatomic, strong, nullable) BTJSON *cannedResponse;
@property (nonatomic, strong, nullable) BTJSON *cannedConfiguration;
@property (nonatomic, assign) NSUInteger cannedStatusCode;
@property (nonatomic, strong, nullable) NSError *cannedError;

- (nullable instancetype)init;

+ (nullable instancetype)fakeHTTP;

- (void)stubRequest:(nonnull NSString *)httpMethod toEndpoint:(nonnull NSString *)endpoint respondWith:(nonnull id)value statusCode:(NSUInteger)statusCode;

- (void)stubRequest:(nonnull NSString *)httpMethod toEndpoint:(nonnull NSString *)endpoint respondWithError:(nonnull NSError *)error;

@end
