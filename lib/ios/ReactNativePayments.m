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

    self.paymentRequest = [[PKPaymentRequest alloc] init];
    self.paymentRequest.merchantIdentifier = methodData[@"merchantIdentifier"];
    self.paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
    self.paymentRequest.supportedNetworks = supportedNetworks;
    self.paymentRequest.countryCode = methodData[@"countryCode"];
    self.paymentRequest.currencyCode = methodData[@"currencyCode"];
    self.paymentRequest.paymentSummaryItems = [self getPaymentSummaryItemsFromDetails:details];
    self.paymentRequest.shippingMethods = [self getShippingMethodsFromDetails:details];

    // Internal slots
    self.initialOptions = options;

    // Request Shipping
    if (options[@"requestShipping"]) {
        self.paymentRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress;
    }

    if (options[@"requestPayerName"]) {
        self.paymentRequest.requiredShippingAddressFields = self.paymentRequest.requiredShippingAddressFields | PKAddressFieldName;
    }

    if (options[@"requestPayerPhone"]) {
        self.paymentRequest.requiredShippingAddressFields = self.paymentRequest.requiredShippingAddressFields | PKAddressFieldPhone;
    }

    if (options[@"requestPayerEmail"]) {
        self.paymentRequest.requiredShippingAddressFields = self.paymentRequest.requiredShippingAddressFields | PKAddressFieldEmail;
    }

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

RCT_EXPORT_METHOD(handleDetailsUpdate: (NSDictionary *)details
                  callback: (RCTResponseSenderBlock)callback)

{
    if (!self.shippingContactCompletion && !self.shippingMethodCompletion) {
        // TODO:
        // - Call callback with error saying shippingContactCompletion was never called;

        return;
    }

    NSArray<PKShippingMethod *> * shippingMethods = [self getShippingMethodsFromDetails:details];

    NSArray<PKPaymentSummaryItem *> * paymentSummaryItems = [self getPaymentSummaryItemsFromDetails:details];


    if (self.shippingMethodCompletion) {
        self.shippingMethodCompletion(
                                      PKPaymentAuthorizationStatusSuccess,
                                      paymentSummaryItems
                                      );

        // Invalidate `self.shippingMethodCompletion`
        self.shippingMethodCompletion = nil;
    }

    if (self.shippingContactCompletion) {
        // Display shipping address error when shipping is needed and shipping method count is below 1
        if (self.initialOptions[@"requestShipping"] && [shippingMethods count] == 0) {
            return self.shippingContactCompletion(
                                           PKPaymentAuthorizationStatusInvalidShippingPostalAddress,
                                           shippingMethods,
                                           paymentSummaryItems
                                           );
        } else {
            self.shippingContactCompletion(
                                           PKPaymentAuthorizationStatusSuccess,
                                           shippingMethods,
                                           paymentSummaryItems
                                           );
        }
        // Invalidate `self.shippingContactCompletion`
        self.shippingContactCompletion = nil;

    }

    // Call callback
    callback(@[[NSNull null]]);

}

// DELEGATES
// ---------------
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
     ];


    // ... Send payment token, shipping and billing address, and order information to your server ...
}


// Shipping Contact
- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingContact:(PKContact *)contact
                                 completion:(nonnull void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
    NSLog(@"DID SELECT SHIPPING CONTACT");
    self.shippingContactCompletion = completion;

    CNPostalAddress *postalAddress = contact.postalAddress;
    // street, subAdministrativeArea, and subLocality are supressed for privacy
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onshippingaddresschange" body:@{
                                                                                                          @"recipient": @[[NSNull null]],
                                                                                                          @"organization": @[[NSNull null]],
                                                                                                          @"addressLine": @[[NSNull null]],
                                                                                                          @"city": postalAddress.city,
                                                                                                          @"region": postalAddress.state,
                                                                                                          @"country": postalAddress.ISOCountryCode,

                                                                                                          @"postalCode": postalAddress.postalCode,
                                                                                                          @"phone": @[[NSNull null]],
                                                                                                          @"languageCode": @[[NSNull null]],
                                                                                                          @"sortingCode": @[[NSNull null]],
                                                                                                          @"dependentLocality": @[[NSNull null]]

                                                                                                          }];
}

// Shipping Method delegates
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
    NSLog(@"DID SELECT SHIPPING METHOD");

    self.shippingMethodCompletion = completion;

    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onshippingoptionchange" body:@{
                                                                                                         @"selectedShippingOptionId": shippingMethod.identifier
                                                                                                         }];

}

// PRIVATE METHODS
// ---------------
- (NSArray<PKPaymentSummaryItem *> *_Nonnull)getPaymentSummaryItemsFromDetails:(NSDictionary *_Nonnull)details
{
    // Setup `paymentSummaryItems` array
    NSMutableArray <PKPaymentSummaryItem *> * paymentSummaryItems = [NSMutableArray array];

    // Add `displayItems` to `paymentSummaryItems`
    NSArray *displayItems = details[@"displayItems"];
    if (displayItems) {
        for (int i = 0; i < [displayItems count]; i++) {
            PKPaymentSummaryItem *displayItem = [PKPaymentSummaryItem summaryItemWithLabel:displayItems[i][@"label"] amount:[NSDecimalNumber decimalNumberWithString: displayItems[i][@"amount"][@"value"]]];
            [paymentSummaryItems addObject: displayItem];
        }
    }

    // Add total to `paymentSummaryItems`
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel: details[@"total"][@"label"] amount:[NSDecimalNumber decimalNumberWithString: details[@"total"][@"amount"][@"value"]]];
    [paymentSummaryItems addObject: total];

    return paymentSummaryItems;
}

- (NSArray<PKShippingMethod *> *_Nonnull)getShippingMethodsFromDetails:(NSDictionary *_Nonnull)details
{
    // Setup `shippingMethods` array
    NSMutableArray <PKShippingMethod *> * shippingMethods = [NSMutableArray array];

    // Add `shippingOptions` to `shippingMethods`
    NSArray *shippingOptions = details[@"shippingOptions"];
    if (shippingOptions) {
        for (int i = 0; i < [shippingOptions count]; i++) {
            PKShippingMethod *shippingOption = [PKShippingMethod summaryItemWithLabel:shippingOptions[i][@"label"] amount:[NSDecimalNumber decimalNumberWithString: shippingOptions[i][@"amount"][@"value"]]];
            shippingOption.detail = @"";
            // TODO: format to local currency
//            shippingOption.detail = shippingOptions[i][@"amount"][@"value"];
            shippingOption.identifier = shippingOptions[i][@"id"];

            [shippingMethods addObject: shippingOption];
        }
    }

    return shippingMethods;
}



@end