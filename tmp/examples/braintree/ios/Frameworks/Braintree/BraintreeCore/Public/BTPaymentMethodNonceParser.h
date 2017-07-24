#import "BTJSON.h"
#import "BTPaymentMethodNonce.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class BTPaymentMethodNonceParser
 @brief A JSON parser that parses `BTJSON` into concrete `BTPaymentMethodNonce` objects. It supports registration of parsers at runtime.

 @discussion `BTPaymentMethodNonceParser` provides access to JSON parsing for different payment options
 without introducing compile-time dependencies on payment option frameworks and their symbols.
*/
@interface BTPaymentMethodNonceParser : NSObject

/*!
 @brief The singleton instance
*/
+ (instancetype)sharedParser;

/*!
 @brief An array of the tokenization types currently registered
*/
@property (nonatomic, readonly, strong) NSArray<NSString *> *allTypes;

/*!
 @brief Indicates whether a tokenization type is currently registered

 @param type The tokenization type string
*/
- (BOOL)isTypeAvailable:(NSString *)type;

/*!
 @brief Registers a parsing block for a tokenization type.

 @param type The tokenization type string
 @param jsonParsingBlock The block to execute when `parseJSON:type:` is called for the tokenization type.
        This block should return a `BTPaymentMethodNonce` object, or `nil` if the JSON cannot be parsed.
*/
- (void)registerType:(NSString *)type withParsingBlock:(BTPaymentMethodNonce * _Nullable (^)(BTJSON *json))jsonParsingBlock;

/*!
 @brief Parses tokenized payment information that has been serialized to JSON, and returns a `BTPaymentMethodNonce` object.
 
 @discussion The `BTPaymentMethodNonce` object is created by the JSON parsing block that has been registered for the tokenization
 type.

 If the `type` has not been registered, this method will attempt to read the nonce from the JSON and return
 a basic object; if it fails, it will return `nil`.

 @param json The tokenized payment info, serialized to JSON
 @param type The registered type of the parsing block to use
 @return A `BTPaymentMethodNonce` object, or `nil` if the tokenized payment info JSON does not contain a nonce
*/
- (nullable BTPaymentMethodNonce *)parseJSON:(BTJSON *)json withParsingBlockForType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
