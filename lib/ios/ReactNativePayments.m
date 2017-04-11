#import "ReactNativePayments.h"

@implementation ReactNativePayments

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

    // Payment summary
    self.paymentRequest.paymentSummaryItems = @[
        [PKPaymentSummaryItem summaryItemWithLabel:@"foo bar" amount:[NSDecimalNumber decimalNumberWithString:@"88.88"]]
    ];


    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(show:(RCTResponseSenderBlock)callback)
{

    PKPaymentAuthorizationViewController *const viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: self.paymentRequest];
    viewController.delegate = self;

    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl presentViewController:viewController animated:YES completion:nil];

    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(abort: (RCTResponseSenderBlock)callback)
{
    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(complete: (NSString *)paymentStatus
                  callback: (RCTResponseSenderBlock)callback)
{
    callback(@[[NSNull null]]);
}


@end