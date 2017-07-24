#import "BTPaymentMethodNonce.h"
#import "BTPaymentMethodNonceParser.h"

@interface BTPaymentMethodNonceParser ()

/// Dictionary of JSON parsing blocks keyed by types as strings. The blocks have the following type:
///
/// `BTPaymentMethodNonce *(^)(NSDictionary *json)`
@property (nonatomic, strong) NSMutableDictionary *JSONParsingBlocks;

@end

@implementation BTPaymentMethodNonceParser

+ (instancetype)sharedParser {
    static BTPaymentMethodNonceParser *sharedParser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParser = [[BTPaymentMethodNonceParser alloc] init];
    });
    return sharedParser;
}

- (NSMutableDictionary *)JSONParsingBlocks {
    if (!_JSONParsingBlocks) {
        _JSONParsingBlocks = [NSMutableDictionary dictionary];
    }
    return _JSONParsingBlocks;
}

- (BOOL)isTypeAvailable:(NSString *)type {
    return self.JSONParsingBlocks[type] != nil;
}

- (NSArray *)allTypes {
    return self.JSONParsingBlocks.allKeys;
}

- (void)registerType:(NSString *)type withParsingBlock:(BTPaymentMethodNonce *(^)(BTJSON *))jsonParsingBlock {
    if (jsonParsingBlock) {
        self.JSONParsingBlocks[type] = [jsonParsingBlock copy];
    }
}

- (BTPaymentMethodNonce *)parseJSON:(BTJSON *)json withParsingBlockForType:(NSString *)type {
    BTPaymentMethodNonce *(^block)(BTJSON *) = self.JSONParsingBlocks[type];
    if (!json) {
        return nil;
    }
    if (block) {
        return block(json);
    }
    // Unregistered types should fall back to parsing basic nonce and description from JSON
    if (![json[@"nonce"] isString]) return nil;
    return [[BTPaymentMethodNonce alloc] initWithNonce:[json[@"nonce"] asString]
                                  localizedDescription:[json[@"description"] asString]
                                                  type:@"Unknown"
                                             isDefault:[json[@"default"] isTrue]];
}

@end
