#import "BTCardNonce.h"
#import "BTJSON.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTCardNonce ()

- (instancetype)initWithNonce:(nonnull NSString *)nonce
                  description:(nullable NSString *)description
                  cardNetwork:(BTCardNetwork)cardNetwork
                      lastTwo:(nullable NSString *)lastTwo
                    isDefault:(BOOL)isDefault;

@end

NS_ASSUME_NONNULL_END
