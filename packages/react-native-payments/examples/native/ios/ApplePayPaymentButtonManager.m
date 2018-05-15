//
//  ApplePayPaymentButtonManager.m
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <PassKit/PassKit.h>
#import <React/RCTConvert.h>
#import "ApplePayPaymentButtonManager.h"

@implementation ApplePayPaymentButtonManager
{
  BOOL _enabled;
}

RCT_EXPORT_MODULE()

RCT_CUSTOM_VIEW_PROPERTY(enabled, BOOL, PKPaymentButton)
{
  NSLog(@"PKPaymentButton: view prop");
  [view setEnabled: json ? [RCTConvert BOOL:json] : defaultView.enabled];
}

- (UIView *) view
{
  NSLog(@"PKPaymentButton: view");
  PKPaymentButton *button = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypePlain paymentButtonStyle:PKPaymentButtonStyleBlack];
  return button;
}

@end
