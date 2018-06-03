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

NSString * const DEFAULT_BUTTON_STYLE = @"black";
NSString * const DEFAULT_BUTTON_TYPE = @"plain";

@implementation ApplePayPaymentButtonManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(buttonType, NSString, ApplePayPaymentButton)
{
  if (json) {
    self.buttonType = [RCTConvert NSString:json];
    [view setButtonType:self.buttonType andStyle:self.buttonStyle];
  }
}

RCT_CUSTOM_VIEW_PROPERTY(buttonStyle, NSString, ApplePayPaymentButton)
{
  if (json) {
    self.buttonStyle = [RCTConvert NSString:json];
    [view setButtonType:self.buttonType andStyle:self.buttonStyle];
  }
}

- (UIView *) view
{
  self.buttonType = DEFAULT_BUTTON_TYPE;
  self.buttonStyle = DEFAULT_BUTTON_STYLE;
  
  return [ApplePayPaymentButton new];
}

@end
