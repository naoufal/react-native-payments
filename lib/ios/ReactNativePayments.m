#import "ReactNativePayments.h"
#import <React/RCTEventDispatcher.h>

@implementation ReactNativePayments
@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport
{
    return @{ @"canMakePayments": @([PKPaymentAuthorizationViewController canMakePayments]) };
}

RCT_EXPORT_METHOD(createPaymentRequest: (NSDictionary *)methodData
                  details: (NSDictionary *)details
                  options: (NSDictionary *)options
                  callback: (RCTResponseSenderBlock)callback)
{
    // https://developer.apple.com/reference/passkit/pkpaymentnetwork
    NSDictionary *supportedNetworksMapping = @{
        @"amex": PKPaymentNetworkAmex,
        @"chinaunionpay": PKPaymentNetworkChinaUnionPay,
        @"discover": PKPaymentNetworkDiscover,
        @"jcb": PKPaymentNetworkJCB,
        @"mastercard": PKPaymentNetworkMasterCard,
        @"privatelabel": PKPaymentNetworkPrivateLabel,
        @"visa": PKPaymentNetworkVisa,
        @"interac": PKPaymentNetworkInterac,
        @"suica": PKPaymentNetworkSuica,
        @"quicpay": PKPaymentNetworkQuicPay,
        @"idcredit": PKPaymentNetworkIDCredit
    };

    // Setup supportedNetworks
    NSMutableArray *supportedNetworks = [NSMutableArray array];
    for (int i = 0; i < [methodData[@"supportedNetworks"] count]; i++) {
        [supportedNetworks addObject: [supportedNetworksMapping objectForKey: methodData[@"supportedNetworks"][i]]];
    }

    // Setup itemSummary
    NSMutableArray *itemSummary = [NSMutableArray array];

    // Add displayItems to itemSummary
    NSArray *displayItems = details[@"displayItems"];
    if (displayItems) {
        for (int i = 0; i < [displayItems count]; i++) {
            PKPaymentSummaryItem *displayItem = [PKPaymentSummaryItem summaryItemWithLabel:displayItems[i][@"label"] amount:[NSDecimalNumber decimalNumberWithString: displayItems[i][@"amount"][@"value"]]];
            [itemSummary addObject: displayItem];
        }
    }

    // Add total to itemSummary
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel: details[@"total"][@"label"] amount:[NSDecimalNumber decimalNumberWithString: details[@"total"][@"amount"][@"value"]]];
    [itemSummary addObject: total];

    self.paymentRequest = [[PKPaymentRequest alloc] init];
    self.paymentRequest.merchantIdentifier = methodData[@"merchantIdentifier"];
    self.paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
    self.paymentRequest.supportedNetworks = supportedNetworks;
    self.paymentRequest.countryCode = methodData[@"countryCode"];
    self.paymentRequest.currencyCode = methodData[@"currencyCode"];
    self.paymentRequest.paymentSummaryItems = itemSummary;

    NSLog(@"PAYMENT REQUEST CREATED");

    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(show:(RCTResponseSenderBlock)callback)
{

    self.viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: self.paymentRequest];
    self.viewController.delegate = self;

    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl presentViewController:self.viewController animated:YES completion:nil];

    NSLog(@"PAYMENT REQUEST SHOWN");

    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(abort: (RCTResponseSenderBlock)callback)
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];

    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(complete: (NSString *)paymentStatus
                  callback: (RCTResponseSenderBlock)callback)
{
    if ([paymentStatus isEqual: @"success"]) {
        NSLog(@"baz baz baz");

        self.completion(PKPaymentAuthorizationStatusSuccess);
    }

    NSLog(@"foo foo foo");

    self.completion(PKPaymentAuthorizationStatusSuccess);

    callback(@[[NSNull null]]);
}


-(void) paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Payment Authorization Controller dismissed.");
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onuserdismiss" body:nil];
}

- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                        didAuthorizePayment:(PKPayment *)payment
                                 completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    // Store completion for later use
    self.completion = completion;

    NSError *error;
//    ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty);
//    NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
//
//    if (error) {
//    NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];

//
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onuseraccept"
                                                    body:@{
                                                           @"transactionIdentifier": payment.token.transactionIdentifier,
                                                           @"paymentData": [[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding]
                                                           }
                                                    //     @"token": [[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding]
     ];


    // ... Send payment token, shipping and billing address, and order information to your server ...
}


// Shipping Contact && Shipping Method delegates
//- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
//                   didSelectShippingContact:(CNContact *)contact
//                                 completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *, NSArray *))completion
//{
//    self.selectedContact = contact;
//    [self updateShippingCost];
//    NSArray *shippingMethods = [self shippingMethodsForContact:contact];
//    completion(PKPaymentAuthorizationStatusSuccess, shippingMethods, self.summaryItems);
//}
//
//- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
//                    didSelectShippingMethod:(PKShippingMethod *)shippingMethod
//                                 completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *))completion
//{
//    self.selectedShippingMethod = shippingMethod;
//    [self updateShippingCost];
//    completion(PKPaymentAuthorizationStatusSuccess, self.summaryItems);
//}

@end
