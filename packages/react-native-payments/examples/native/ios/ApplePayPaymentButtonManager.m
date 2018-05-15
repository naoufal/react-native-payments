//
//  ApplePayPaymentButtonManager.m
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ApplePayPaymentButtonManager.h"

@implementation ApplePayPaymentButtonManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:@"Pay with apple pay" forState:UIControlStateNormal];
  
  return button;
}

@end
