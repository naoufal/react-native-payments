#import <Foundation/Foundation.h>

extern NSString *BraintreeDemoMerchantAPIEnvironmentDidChangeNotification;

@interface BraintreeDemoMerchantAPI : NSObject

+ (instancetype)sharedService;

- (void)fetchMerchantConfigWithCompletion:(void (^)(NSString *merchantId, NSError *error))completionBlock;
- (void)createCustomerAndFetchClientTokenWithCompletion:(void (^)(NSString *clientToken, NSError *error))completionBlock;
- (void)makeTransactionWithPaymentMethodNonce:(NSString *)paymentMethodNonce completion:(void (^)(NSString *transactionId, NSError *error))completionBlock;
- (void)makeTransactionWithPaymentMethodNonce:(NSString *)paymentMethodNonce merchantAccountId:(NSString *)merchantAccountId completion:(void (^)(NSString *transactionId, NSError *error))completionBlock;

@end
