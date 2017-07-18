#import "BTJSON.h"

NSString * const BTJSONErrorDomain = @"com.briantreepayments.BTJSONErrorDomain";

@interface BTJSON ()

@property (nonatomic, strong) NSArray *subscripts;
@property (nonatomic, strong) id value;

@end

@implementation BTJSON

@synthesize value = _value;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.subscripts = [NSMutableArray array];
        self.value = @{};
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    NSError *error;
    id value = [NSJSONSerialization JSONObjectWithData:data
                                               options:NSJSONReadingAllowFragments
                                                 error:&error];
    if (error != nil) {
        return self = [self initWithValue:error];
    }

    return self = [self initWithValue:value];
}

- (instancetype)initWithValue:(id)value {
    self = [self init];
    if (self) {
        self.value = value;
    }
    return self;
}


#pragma mark Subscripting

- (id)objectForKeyedSubscript:(NSString *)key {
    BTJSON *json = [[BTJSON alloc] initWithValue:_value];
    json.subscripts = [self.subscripts arrayByAddingObject:key];

    return json;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    BTJSON *json = [[BTJSON alloc] initWithValue:_value];
    json.subscripts = [self.subscripts arrayByAddingObject:@(idx)];

    return json;
}

- (id)value {
    id value = _value;
    for (id key in self.subscripts) {
        if ([value isKindOfClass:[NSArray class]]) {
            if (![key isKindOfClass:[NSNumber class]]) {
                value = [self chainedErrorOrErrorWithCode:BTJSONErrorAccessInvalid userInfo:nil];
                break;
            }

            NSUInteger idx = [(NSNumber *)key unsignedIntegerValue];
            if (idx >= [(NSArray *)value count]) {
                value = nil;
                break;
            }

            value = [value objectAtIndexedSubscript:idx];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            if (![key isKindOfClass:[NSString class]]) {
                value = [self chainedErrorOrErrorWithCode:BTJSONErrorAccessInvalid userInfo:nil];
                break;
            }

            value = [value objectForKeyedSubscript:key];
        } else {
            value = [self chainedErrorOrErrorWithCode:BTJSONErrorValueInvalid userInfo:@{ NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"Attempted to index into a value that is neither an object nor an array using key (%@).", key] }];
            break;
        }
    }
    return value;
}

#pragma mark Validity Checks

- (BOOL)isError {
    return [self.value isKindOfClass:[NSError class]];
}

- (NSError *)asError {
    if (![self.value isKindOfClass:[NSError class]]) {
        return nil;
    }

    return self.value;
}

#pragma mark Generating JSON

- (NSData *)asJSONAndReturnError:(NSError **)error {
    return [NSJSONSerialization dataWithJSONObject:self.value
                                           options:0
                                             error:error];
}

- (NSString *)asPrettyJSONAndReturnError:(NSError **)error {
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.value
                                                                          options:NSJSONWritingPrettyPrinted
                                                                            error:error]
                                 encoding:NSUTF8StringEncoding];
}


#pragma mark JSON Type Casts

- (NSString *)asString {
    if (![self.value isKindOfClass:[NSString class]]) {
        return nil;
    }

    return self.value;
}

- (NSArray<BTJSON *> *)asArray {
    if (![self.value isKindOfClass:[NSArray class]]) {
        return nil;
    }

    return self.value;
}

- (NSDecimalNumber *)asNumber {
    if (![self.value isKindOfClass:[NSNumber class]]) {
        return nil;
    }

    return [NSDecimalNumber decimalNumberWithDecimal:[self.value decimalValue]];
}

#pragma mark JSON Extension Type Casts

- (NSURL *)asURL {
    NSString *urlString = self.asString;

    if (urlString == nil) {
        return nil;
    }

    return [NSURL URLWithString:urlString];
}

- (NSArray<NSString *> *)asStringArray {
    NSArray <NSString *> *array = (NSArray <NSString *> *)self.asArray;

    for (id obj in array) {
        if (![obj isKindOfClass:[NSString class]]) {
            return nil;
        }
    }

    return array;
}

- (NSDictionary<NSString *, BTJSON *> *)asDictionary {
    NSDictionary *dictionary = self.value;

    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    return dictionary;
}

- (NSInteger)asIntegerOrZero {
    NSNumber *number = self.value;

    if (![number isKindOfClass:[NSNumber class]]) {
        return 0;
    }

    return number.integerValue;
}

- (NSInteger)asEnum:(nonnull NSDictionary *)mapping orDefault:(NSInteger)defaultValue {
    id key = self.value;
    NSNumber *value = mapping[key];

    if (!value || ![value isKindOfClass:[NSNumber class]]) {
        return defaultValue;
    }

    return value.integerValue;
}

// @name JSON Type Checks

- (BOOL)isString {
    return [self.value isKindOfClass:[NSString class]];
}

- (BOOL)isNumber {
    return [self.value isKindOfClass:[NSNumber class]];
}

- (BOOL)isArray {
    return [self.value isKindOfClass:[NSArray class]];
}

- (BOOL)isObject {
    return [self.value isKindOfClass:[NSDictionary class]];
}

- (BOOL)isTrue {
    return [self.value isEqual:@YES];
}

- (BOOL)isFalse {
    return [self.value isEqual:@NO];
}

- (BOOL)isNull {
    return [self.value isKindOfClass:[NSNull class]];
}

#pragma mark Error Handling

- (NSError *)chainedErrorOrErrorWithCode:(NSInteger)code
                               userInfo:(NSDictionary *)userInfo {
    if ([_value isKindOfClass:[NSError class]]) {
        return _value;
    }

    return [NSError errorWithDomain:BTJSONErrorDomain
                               code:code
                           userInfo:userInfo];
}

#pragma mark -

- (NSString *)description {
    return [self debugDescription];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<BTJSON:%p value:%@>", self, self.value];
}

@end
