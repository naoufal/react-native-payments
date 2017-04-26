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
@property (nonatomic, strong) PKPaymentAuthorizationViewController *viewController;
@property (nonatomic, copy) void (^completion)(PKPaymentAuthorizationStatus);
@property (nonatomic, copy) void (^shippingContactCompletion)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull);


// Private methods
- (NSArray<PKPaymentSummaryItem *> *_Nonnull)getPaymentSummaryItemsFromDetails:(NSDictionary *_Nonnull)details;

@end
