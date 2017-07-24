#import "BTTokenizationService.h"

NSString * const BTTokenizationServiceErrorDomain = @"com.braintreepayments.BTTokenizationServiceErrorDomain";
NSString * const BTTokenizationServiceViewPresentingDelegateOption = @"viewControllerPresentingDelegate";
NSString * const BTTokenizationServiceAppSwitchDelegateOption = @"BTTokenizationServiceAppSwitchDelegateOption";
NSString * const BTTokenizationServicePayPalScopesOption = @"BTPaymentRequest.additionalPayPalScopes";
NSString * const BTTokenizationServiceAmountOption = @"BTTokenizationServiceAmountOption";
NSString * const BTTokenizationServiceNonceOption = @"BTTokenizationServiceNonceOption";

@interface BTTokenizationService ()
/// Dictionary of tokenization blocks keyed by types as strings. The blocks have the following type:
///
/// `void (^)(BTAPIClient * _Nonnull, NSDictionary * _Nullable, void (^ _Nonnull)(BTPaymentMethodNonce * _Nullable, NSError * _Nullable))`
@property (nonatomic, strong) NSMutableDictionary *tokenizationBlocks;
@end

@implementation BTTokenizationService

+ (instancetype)sharedService {
    static BTTokenizationService *sharedService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[BTTokenizationService alloc] init];
    });
    return sharedService;
}

- (NSMutableDictionary *)tokenizationBlocks {
    if (!_tokenizationBlocks) {
        _tokenizationBlocks = [NSMutableDictionary dictionary];
    }
    return _tokenizationBlocks;
}

- (void)registerType:(NSString *)type withTokenizationBlock:(void (^)(BTAPIClient * _Nonnull, NSDictionary * _Nullable, void (^ _Nonnull)(BTPaymentMethodNonce * _Nullable, NSError * _Nullable)))tokenizationBlock
{
    self.tokenizationBlocks[type] = [tokenizationBlock copy];
}

- (BOOL)isTypeAvailable:(NSString *)type {
    return self.tokenizationBlocks[type] != nil;
}

- (NSArray *)allTypes {
    return [self.tokenizationBlocks allKeys];
}

- (void)tokenizeType:(NSString *)type
       withAPIClient:(BTAPIClient *)apiClient
          completion:(void (^)(BTPaymentMethodNonce * _Nullable, NSError * _Nullable))completion
{
    [self tokenizeType:type options:nil withAPIClient:apiClient completion:completion];
}

- (void)tokenizeType:(NSString *)type
             options:(NSDictionary<NSString *,id> *)options
       withAPIClient:(BTAPIClient *)apiClient
          completion:(void (^)(BTPaymentMethodNonce * _Nullable, NSError * _Nullable))completion
{
    void(^block)(BTAPIClient *, NSDictionary *, void(^)(BTPaymentMethodNonce *, NSError *)) = self.tokenizationBlocks[type];
    if (block) {
        block(apiClient, options ?: @{}, completion);
    } else {
        NSError *error = [NSError errorWithDomain:BTTokenizationServiceErrorDomain
                                             code:BTTokenizationServiceErrorTypeNotRegistered
                                         userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ processing not available", type],
                                                    NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"Type '%@' is not registered with BTTokenizationService", type],
                                                    NSLocalizedRecoverySuggestionErrorKey: [NSString stringWithFormat:@"Please link Braintree%@.framework to your app", type]
                                                    }];
        completion(nil, error);
    }
}

@end
