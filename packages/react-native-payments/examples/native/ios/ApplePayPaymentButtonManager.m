//
//  ApplePayPaymentButtonManager.m
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "ApplePayPaymentButtonManager.h"
#import "ApplePayPaymentButton.h"

@implementation ApplePayPaymentButtonManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(buttonType, NSString, ApplePayPaymentButton)
{
  if (json) {
    [view setButtonType:[RCTConvert NSString:json]];
  }
}

RCT_CUSTOM_VIEW_PROPERTY(buttonStyle, NSString, ApplePayPaymentButton)
{
  if (json) {
    [view setButtonStyle:[RCTConvert NSString:json]];
  }
}

- (UIView *) view
{
  return [ApplePayPaymentButton new];
}

@end
