//
//  ApplePayPaymentButtonManager.m
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "ApplePayPaymentButtonManager.h"

@implementation ApplePayPaymentButtonManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  PKPaymentButton *button = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypeBuy paymentButtonStyle:PKPaymentButtonStyleBlack];
  
  return button;
}

@end
