#import "BraintreeDemoMerchantAPI.h"
#import <AFNetworking/AFNetworking.h>

#import "BraintreeDemoSettings.h"

NSString *BraintreeDemoMerchantAPIEnvironmentDidChangeNotification = @"BraintreeDemoTransactionServiceEnvironmentDidChangeNotification";

@interface BraintreeDemoMerchantAPI ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *sessionManager;
@property (nonatomic, assign) NSString *currentEnvironmentURLString;
@property (nonatomic, assign) BraintreeDemoTransactionServiceThreeDSecureRequiredStatus threeDSecureRequiredStatus;
@end

@implementation BraintreeDemoMerchantAPI

+ (instancetype)sharedService {
    static BraintreeDemoMerchantAPI *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.threeDSecureRequiredStatus = -1;
        [self setupSessionManager:nil];
        
        // Use KVO because we don't want to be notified while the user types each character of a Custom URL
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:BraintreeDemoSettingsEnvironmentDefaultsKey options:NSKeyValueObservingOptionNew context:NULL];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:BraintreeDemoSettingsThreeDSecureRequiredDefaultsKey options:NSKeyValueObservingOptionNew context:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupSessionManager:) name:UITextFieldTextDidEndEditingNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:BraintreeDemoSettingsEnvironmentDefaultsKey];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:BraintreeDemoSettingsThreeDSecureRequiredDefaultsKey];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)observeValueForKeyPath:(__unused NSString *)keyPath ofObject:(__unused id)object change:(__unused NSDictionary *)change context:(__unused void *)context {
    [self setupSessionManager:nil];
}

- (void)setupSessionManager:(__unused NSNotification *)notif {
    if (![self.currentEnvironmentURLString isEqualToString:[BraintreeDemoSettings currentEnvironmentURLString]] ||
        self.threeDSecureRequiredStatus != [BraintreeDemoSettings threeDSecureRequiredStatus])
    {
        self.currentEnvironmentURLString = [BraintreeDemoSettings currentEnvironmentURLString];
        self.threeDSecureRequiredStatus = [BraintreeDemoSettings threeDSecureRequiredStatus];
        self.sessionManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[BraintreeDemoSettings currentEnvironmentURLString]]];
        [[NSNotificationCenter defaultCenter] postNotificationName:BraintreeDemoMerchantAPIEnvironmentDidChangeNotification object:self];
    }
}

- (void)fetchMerchantConfigWithCompletion:(void (^)(NSString *merchantId, NSError *error))completionBlock {
    [self.sessionManager GET:@"/config/current"
              parameters:nil
                 success:^(__unused AFHTTPRequestOperation *operation, id responseObject) {
                     if (completionBlock) {
                         completionBlock(responseObject[@"merchant_id"], nil);
                     }
                 } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
                     completionBlock(nil, error);
                 }];
}

- (void)createCustomerAndFetchClientTokenWithCompletion:(void (^)(NSString *, NSError *))completionBlock {
    NSMutableDictionary *parameters = [@{@"version":[BraintreeDemoSettings clientTokenVersion]} mutableCopy];
    if ([BraintreeDemoSettings customerPresent]) {
        if ([BraintreeDemoSettings customerIdentifier].length > 0) {
            parameters[@"customer_id"] = [BraintreeDemoSettings customerIdentifier];
        } else {
            parameters[@"customer_id"] = [[NSUUID UUID] UUIDString];
        }
    }

    [self.sessionManager GET:@"/client_token"
                  parameters:parameters
                     success:^(__unused AFHTTPRequestOperation *operation, id responseObject) {
                         completionBlock(responseObject[@"client_token"], nil);
                     }
                     failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
                         completionBlock(nil, error);
                     }];
}

- (void)makeTransactionWithPaymentMethodNonce:(NSString *)paymentMethodNonce completion:(void (^)(NSString *transactionId, NSError *error))completionBlock {
    [self makeTransactionWithPaymentMethodNonce:paymentMethodNonce
                         merchantAccountId:nil
                                completion:completionBlock];
}

- (void)makeTransactionWithPaymentMethodNonce:(NSString *)paymentMethodNonce merchantAccountId:(NSString *)merchantAccountId completion:(void (^)(NSString *transactionId, NSError *error))completionBlock {
    NSLog(@"Creating a transaction with nonce: %@", paymentMethodNonce);
    NSMutableDictionary *parameters;

    switch ([BraintreeDemoSettings threeDSecureRequiredStatus]) {
        case BraintreeDemoTransactionServiceThreeDSecureRequiredStatusDefault:
            parameters = [@{ @"payment_method_nonce": paymentMethodNonce } mutableCopy];
            break;
        case BraintreeDemoTransactionServiceThreeDSecureRequiredStatusRequired:
            parameters = [@{ @"payment_method_nonce": paymentMethodNonce, @"three_d_secure_required": @YES, } mutableCopy];
            break;
        case BraintreeDemoTransactionServiceThreeDSecureRequiredStatusNotRequired:
            parameters = [@{ @"payment_method_nonce": paymentMethodNonce, @"three_d_secure_required": @NO, } mutableCopy];
            break;
    }

    if (merchantAccountId != nil) {
        [parameters setObject:merchantAccountId forKey:@"merchant_account_id"];
    }

    [self.sessionManager POST:@"/nonce/transaction"
                   parameters:parameters
                      success:^(__unused AFHTTPRequestOperation *operation, __unused id responseObject) {
                          completionBlock(responseObject[@"message"], nil);
                      }
                      failure:^(__unused AFHTTPRequestOperation *operation, __unused NSError *error) {
                          completionBlock(nil, error);
                      }];
}

@end
