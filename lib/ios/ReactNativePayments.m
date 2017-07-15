#import "ReactNativePayments.h"
#import "GatewayManager.h"
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
    return @{
             @"canMakePayments": @([PKPaymentAuthorizationViewController canMakePayments]),
             @"supportedGateways": [GatewayManager getSupportedGateways]
             };
}

RCT_EXPORT_METHOD(createPaymentRequest: (NSDictionary *)methodData
                  details: (NSDictionary *)details
                  options: (NSDictionary *)options
                  callback: (RCTResponseSenderBlock)callback)
{
    NSString *merchantId = methodData[@"merchantIdentifier"];
    NSDictionary *gatewayParameters = methodData[@"paymentMethodTokenizationParameters"][@"parameters"];
    
    if (gatewayParameters) {
        self.hasGatewayParameters = true;
        [GatewayManager configureGateway:gatewayParameters merchantIdentifier:merchantId];
    }
    
    self.paymentRequest = [[PKPaymentRequest alloc] init];
    self.paymentRequest.merchantIdentifier = merchantId;
    self.paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
    self.paymentRequest.countryCode = methodData[@"countryCode"];
    self.paymentRequest.currencyCode = methodData[@"currencyCode"];
    self.paymentRequest.supportedNetworks = [self getSupportedNetworksFromMethodData:methodData];
    self.paymentRequest.paymentSummaryItems = [self getPaymentSummaryItemsFromDetails:details];
    self.paymentRequest.shippingMethods = [self getShippingMethodsFromDetails:details];

    [self setRequiredShippingAddressFieldsFromOptions:options];

    // Set options so that we can later access it.
    self.initialOptions = options;

    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(show:(RCTResponseSenderBlock)callback)
{

    self.viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: self.paymentRequest];
    self.viewController.delegate = self;

    // TODO - Replace `rootViewController` with a the top rootViewController
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl presentViewController:self.viewController animated:YES completion:nil];

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
    if ([paymentStatus isEqualToString: @"success"]) {
        self.completion(PKPaymentAuthorizationStatusSuccess);
    } else {
        self.completion(PKPaymentAuthorizationStatusFailure);
    }

    callback(@[[NSNull null]]);
}


-(void) paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
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
        // Invalidate `aself.shippingContactCompletion`
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

    if (self.hasGatewayParameters) {
        [GatewayManager createTokenWithPayment:payment completion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if (error) {
                NSLog(@"WTF");
                [self handleGatewayError:error];
                return;
            }
            
            [self handleUserAccept:payment paymentToken:token];
        }];
    } else {
        [self handleUserAccept:payment paymentToken:nil];
    }
}


// Shipping Contact
- (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingContact:(PKContact *)contact
                                 completion:(nonnull void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
    self.shippingContactCompletion = completion;

    CNPostalAddress *postalAddress = contact.postalAddress;
    // street, subAdministrativeArea, and subLocality are supressed for privacy
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onshippingaddresschange"
                                                    body:@{
                                                           @"recipient": [NSNull null],
                                                           @"organization": [NSNull null],
                                                           @"addressLine": [NSNull null],
                                                           @"city": postalAddress.city,
                                                           @"region": postalAddress.state,
                                                           @"country": [postalAddress.ISOCountryCode uppercaseString],
                                                           @"postalCode": postalAddress.postalCode,
                                                           @"phone": [NSNull null],
                                                           @"languageCode": [NSNull null],
                                                           @"sortingCode": [NSNull null],
                                                           @"dependentLocality": [NSNull null]
                                                           }];
}

// Shipping Method delegates
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
    self.shippingMethodCompletion = completion;

    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onshippingoptionchange" body:@{
                                                                                                         @"selectedShippingOptionId": shippingMethod.identifier
                                                                                                         }];

}

// PRIVATE METHODS
// ---------------
- (NSArray *_Nonnull)getSupportedNetworksFromMethodData:(NSDictionary *_Nonnull)methodData
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
    NSArray *jsSupportedNetworks = methodData[@"supportedNetworks"];
    NSMutableArray *supportedNetworks = [NSMutableArray array];
    for (NSString *supportedNetwork in jsSupportedNetworks) {
        [supportedNetworks addObject: supportedNetworksMapping[supportedNetwork]];
    }

    return supportedNetworks;
}

- (NSArray<PKPaymentSummaryItem *> *_Nonnull)getPaymentSummaryItemsFromDetails:(NSDictionary *_Nonnull)details
{
    // Setup `paymentSummaryItems` array
    NSMutableArray <PKPaymentSummaryItem *> * paymentSummaryItems = [NSMutableArray array];

    // Add `displayItems` to `paymentSummaryItems`
    NSArray *displayItems = details[@"displayItems"];
    if (displayItems.count > 0) {
        for (NSDictionary *displayItem in displayItems) {
            [paymentSummaryItems addObject: [self convertDisplayItemToPaymentSummaryItem:displayItem]];
        }
    }

    // Add total to `paymentSummaryItems`
    NSDictionary *total = details[@"total"];
    [paymentSummaryItems addObject: [self convertDisplayItemToPaymentSummaryItem:total]];

    return paymentSummaryItems;
}

- (NSArray<PKShippingMethod *> *_Nonnull)getShippingMethodsFromDetails:(NSDictionary *_Nonnull)details
{
    // Setup `shippingMethods` array
    NSMutableArray <PKShippingMethod *> * shippingMethods = [NSMutableArray array];

    // Add `shippingOptions` to `shippingMethods`
    NSArray *shippingOptions = details[@"shippingOptions"];
    if (shippingOptions.count > 0) {
        for (NSDictionary *shippingOption in shippingOptions) {
            [shippingMethods addObject: [self convertShippingOptionToShippingMethod:shippingOption]];
        }
    }

    return shippingMethods;
}

- (PKPaymentSummaryItem *_Nonnull)convertDisplayItemToPaymentSummaryItem:(NSDictionary *_Nonnull)displayItem;
{
    NSDecimalNumber *decimalNumberAmount = [NSDecimalNumber decimalNumberWithString:displayItem[@"amount"][@"value"]];
    PKPaymentSummaryItem *paymentSummaryItem = [PKPaymentSummaryItem summaryItemWithLabel:displayItem[@"label"] amount:decimalNumberAmount];

    return paymentSummaryItem;
}

- (PKShippingMethod *_Nonnull)convertShippingOptionToShippingMethod:(NSDictionary *_Nonnull)shippingOption
{
    PKShippingMethod *shippingMethod = [PKShippingMethod summaryItemWithLabel:shippingOption[@"label"] amount:[NSDecimalNumber decimalNumberWithString: shippingOption[@"amount"][@"value"]]];
    shippingMethod.identifier = shippingOption[@"id"];

    // shippingOption.detail is not part of the PaymentRequest spec.
    if ([shippingOption[@"detail"] isKindOfClass:[NSString class]]) {
        shippingMethod.detail = shippingOption[@"detail"];
    } else {
        shippingMethod.detail = @"";
    }

    return shippingMethod;
}

- (void)setRequiredShippingAddressFieldsFromOptions:(NSDictionary *_Nonnull)options
{
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
}

- (void)handleUserAccept:(PKPayment *_Nonnull)payment
                paymentToken:(NSString *_Nullable)token
{
    NSString *transactionId = payment.token.transactionIdentifier;
    NSString *paymentData = [[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *paymentResponse = [[NSMutableDictionary alloc]initWithCapacity:3];
    [paymentResponse setObject:transactionId forKey:@"transactionIdentifier"];
    [paymentResponse setObject:paymentData forKey:@"paymentData"];
    
    if (token) {
        [paymentResponse setObject:token forKey:@"paymentToken"];
    }
    
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:onuseraccept"
                                                    body:paymentResponse
     ];
}

- (void)handleGatewayError:(NSError *_Nonnull)error
{
    NSLog(@"ERRROOOORRR");
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"NativePayments:ongatewayerror"
                                                    body: @{
                                                            @"error": [error localizedDescription]
                                                            }
     ];
}

@end
