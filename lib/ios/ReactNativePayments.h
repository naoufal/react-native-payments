@import UIKit;
@import PassKit;
@import AddressBook;

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@interface ReactNativePayments : NSObject <RCTBridgeModule, PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, strong) RCTResponseSenderBlock callback;
@property (nonatomic, strong) PKPaymentRequest *paymentRequest;
@property (nonatomic, strong) NSDictionary *initialOptions;
@property (nonatomic, strong) PKPaymentAuthorizationViewController *viewController;
@property (nonatomic, copy) void (^completion)(PKPaymentAuthorizationStatus);
@property (nonatomic, copy) void (^shippingContactCompletion)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull);
@property (nonatomic, copy) void (^shippingMethodCompletion)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull);



// Private methods
- (NSArray<PKPaymentSummaryItem *> *_Nonnull)getPaymentSummaryItemsFromDetails:(NSDictionary *_Nonnull)details;
- (NSArray<PKShippingMethod *> *_Nonnull)getShippingMethodsFromDetails:(NSDictionary *_Nonnull)details;

@end