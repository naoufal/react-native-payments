#import "ApplePayManager.h"
#import "RCTUtils.h"
#import "RCTLog.h"
#import "StripeManager.h"

@implementation ApplePayManager

RCT_EXPORT_MODULE()

// Checks if user can make payments with ApplePay
//
// This functionality may not be supported by their hardware, or it may be
// restricted by parental controls
RCT_EXPORT_METHOD(canMakePayments: (RCTResponseSenderBlock)callback)
{
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        callback(@[@true]);
    } else {
        callback(@[@false]);
    }
}


// Checks if user can make payments with ApplePay and if a payment card is
// configured
//
// This functionality may not be supported by their hardware, or it may be
// restricted by parental controls
RCT_EXPORT_METHOD(canMakePaymentsUsingNetworks: (RCTResponseSenderBlock)callback)
{
    NSArray *paymentNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    
    if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentNetworks]) {
        callback(@[@true]);
    } else {
        callback(@[@false]);
    }
}


RCT_EXPORT_METHOD(paymentRequest: (NSDictionary *)args
                  items: (NSArray *)items
                  callback:(RCTResponseSenderBlock)callback)
{
    // Set callback to self so we can use it later
    self.callback = callback;
    
    // Set Payment Processor
    if (!args[@"paymentProcessor"] || !args[@"paymentProcessorPublicKey"]) {
        RCTLogError(@"[ApplePay] Your must provide a payment processor and a public key.");
    }
    
    self.paymentProcessor = args[@"paymentProcessor"];
    self.paymentProcessorPublicKey = args[@"paymentProcessorPublicKey"];
    self.backendUrl = args[@"backendUrl"];
    
    // Setup Payment Request
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    // Merchant/Currency Setup
    request.countryCode = args[@"countryCode"];
    request.currencyCode = args[@"currencyCode"];
    request.merchantIdentifier = args[@"merchantIdentifier"];
    
    request.merchantCapabilities = PKMerchantCapabilityDebit;
    request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];

    
    // Setup product, discount, shipping and total
    NSMutableArray *summaryItems = [NSMutableArray array];
    
    for (NSDictionary *i in items) {
        NSLog(@"Item: %@", i[@"label"]);
        PKPaymentSummaryItem *item = [[PKPaymentSummaryItem alloc] init];
        item.label = i[@"label"];
        item.amount = [NSDecimalNumber decimalNumberWithString:i[@"amount"]];
    
        [summaryItems addObject:item];
    }

    // Add Payment Items to request
    request.paymentSummaryItems = summaryItems;
    
    // Show Payment Sheet
    PKPaymentAuthorizationViewController *const viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: request];
    viewController.delegate = self;
     
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl presentViewController:viewController animated:YES completion:nil];
    
    NSLog(@"Payment Authorization Controller visible.");
}

RCT_EXPORT_METHOD(success:(RCTResponseSenderBlock)callback)
{
    self.completion(PKPaymentAuthorizationStatusSuccess);
    callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(failure:(RCTResponseSenderBlock)callback)
{
    self.completion(PKPaymentAuthorizationStatusFailure);
    callback(@[[NSNull null]]);
}

// Payment authorized handler
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    self.payment = payment;
    
    // Set completion to self so we can call it from JS
    NSLog(@"completion: %@", completion);
    self.completion = completion;
    
    // Select Payment Processor
    NSLog(@"Payment Processor: %@", self.paymentProcessor);
    
    if ([self.paymentProcessor isEqual: @"stripe"]) {
        [StripeManager handlePaymentAuthorizationWithPayment:self.paymentProcessorPublicKey
                                                     payment:payment
                                                  completion:completion
                                                    callback:self.callback];
    } else {
        RCTLogError(@"[ApplePay] Your payment provider is not yet supported.");
        return;
    }
}

// Finish handler
-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Payment Authorization Controller dismissed.");
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end

