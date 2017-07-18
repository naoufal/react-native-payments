#import "BTVenmoAccountNonce.h"

@interface BTVenmoAccountNonce ()
@property (nonatomic, readwrite, copy) NSString *username;
@end

@implementation BTVenmoAccountNonce

- (instancetype)initWithPaymentMethodNonce:(NSString *)nonce
                               description:(__unused NSString *)description
                                  username:(NSString *)username
                                 isDefault:(BOOL)isDefault
{
    if (self = [super initWithNonce:nonce localizedDescription:username type:@"Venmo" isDefault:isDefault]) {
        _username = username;
    }
    return self;
}

+ (instancetype)venmoAccountWithJSON:(BTJSON *)venmoAccountJSON {
    return [[[self class] alloc] initWithPaymentMethodNonce:[venmoAccountJSON[@"nonce"] asString]
                                                description:[venmoAccountJSON[@"description"] asString]
                                                   username:[venmoAccountJSON[@"details"][@"username"] asString]
                                                  isDefault:[venmoAccountJSON[@"default"] isTrue]];
}

@end
