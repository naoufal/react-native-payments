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
#import "ApplePayPaymentButton.h"

@implementation ApplePayPaymentButtonManager

RCT_EXPORT_MODULE()

RCT_CUSTOM_VIEW_PROPERTY(enabled, BOOL, ApplePayPaymentButton)
{
  if (json) {
    view.button.enabled = [RCTConvert BOOL:json];
  } else {
    view.button.enabled = defaultView.button.enabled;
  }
}

- (UIView *) view
{
  return [ApplePayPaymentButton new];
}

@end
