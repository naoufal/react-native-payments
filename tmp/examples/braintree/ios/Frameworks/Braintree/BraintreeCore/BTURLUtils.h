#import <Foundation/Foundation.h>

@interface BTURLUtils : NSObject

+ (NSURL *)URLfromURL:(NSURL *)URL withAppendedQueryDictionary:(NSDictionary *)dictionary;
+ (NSString *)queryStringWithDictionary:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryForQueryString:(NSString *)queryString;

@end
