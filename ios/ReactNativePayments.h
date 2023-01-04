@import UIKit;
@import PassKit;
@import AddressBook;

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import "GatewayManager.h"

@interface ReactNativePayments : NSObject <RCTBridgeModule, PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, strong) RCTResponseSenderBlock callback;
@property (nonatomic, strong) PKPaymentRequest *paymentRequest;
@property (nonatomic, strong) NSDictionary *initialOptions;
@property (nonatomic, strong) GatewayManager *gatewayManager;
@property BOOL *hasGatewayParameters;
@property (nonatomic, strong) PKPaymentAuthorizationViewController *viewController;
@property (nonatomic, copy) void (^completion)(PKPaymentAuthorizationStatus);
@property (nonatomic, copy) void (^shippingContactCompletion)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull);
@property (nonatomic, copy) void (^shippingMethodCompletion)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull);

// Private methods
- (NSArray *_Nonnull)getSupportedNetworksFromMethodData:(NSDictionary *_Nonnull)methodData;
- (NSArray<PKPaymentSummaryItem *> *_Nonnull)getPaymentSummaryItemsFromDetails:(NSDictionary *_Nonnull)details;
- (NSArray<PKShippingMethod *> *_Nonnull)getShippingMethodsFromDetails:(NSDictionary *_Nonnull)details;
- (PKPaymentSummaryItem *_Nonnull)convertDisplayItemToPaymentSummaryItem:(NSDictionary *_Nonnull)displayItem;
- (PKShippingMethod *_Nonnull)convertShippingOptionToShippingMethod:(NSDictionary *_Nonnull)shippingOption;
- (void)handleUserAccept:(PKPayment *_Nonnull)payment
            paymentToken:(NSString *_Nullable)token;
- (void)handleGatewayError:(NSError *_Nonnull)error;

@end
