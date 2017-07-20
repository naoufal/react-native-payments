#import <Foundation/Foundation.h>
@class BTJSON;

#define kBTHTTPTestProtocolScheme @"bt-http-test"
#define kBTHTTPTestProtocolHost @"base.example.com"
#define kBTHTTPTestProtocolBasePath @"/base/path"
#define kBTHTTPTestProtocolPort @1234

@interface BTHTTPTestProtocol : NSURLProtocol

+ (NSURLRequest *)parseRequestFromTestResponseBody:(BTJSON *)responseBody;
+ (NSString *)parseRequestBodyFromTestResponseBody:(BTJSON *)responseBody;
+ (NSURL *)testBaseURL;

@end
