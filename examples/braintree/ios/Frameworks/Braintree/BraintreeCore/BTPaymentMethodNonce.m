#import "BTPaymentMethodNonce.h"

@interface BTPaymentMethodNonce ()
@property (nonatomic, copy, readwrite) NSString *nonce;
@property (nonatomic, copy, readwrite) NSString *localizedDescription;
@property (nonatomic, copy, readwrite) NSString *type;
@property (nonatomic, readwrite, assign) BOOL isDefault;
@end

@implementation BTPaymentMethodNonce

- (instancetype)initWithNonce:(NSString *)nonce localizedDescription:(NSString *)description type:(NSString *)type {
    if (!nonce) return nil;
    
    if (self = [super init]) {
        self.nonce = nonce;
        self.localizedDescription = description;
        self.type = type;
    }
    return self;
}

- (nullable instancetype)initWithNonce:(NSString *)nonce localizedDescription:(nullable NSString *)description {
    return [self initWithNonce:nonce localizedDescription:description type:@"Unknown"];
}

- (nullable instancetype)initWithNonce:(NSString *)nonce localizedDescription:(NSString *)description type:(nonnull NSString *)type isDefault:(BOOL)isDefault {
    if (self = [self initWithNonce:nonce localizedDescription:description type:type]) {
        _isDefault = isDefault;
    }
    return self;
}

@end
