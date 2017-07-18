#if __has_include("BraintreeCard.h")
#import "BTCardNonce.h"
#else
#import <BraintreeCard/BTCardNonce.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BTThreeDSecureCardNonce : BTCardNonce

@property (nonatomic, readonly, assign) BOOL liabilityShifted;
@property (nonatomic, readonly, assign) BOOL liabilityShiftPossible;

#pragma mark - Internal

- (instancetype)initWithNonce:(NSString *)nonce
                  description:(nullable NSString *)description
                  cardNetwork:(BTCardNetwork)cardNetwork
                      lastTwo:(nullable NSString *)lastTwo
             threeDSecureJSON:(BTJSON *)threeDSecureJSON
                    isDefault:(BOOL)isDefault;

@end

NS_ASSUME_NONNULL_END
