//
//  ApplePayPaymentButtonManager.m
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ApplePayPaymentButtonManager.h"
#import "ApplePayPaymentButton.h"
#import <PassKit/PassKit.h>

NSString * const DEFAULT_BUTTON_STYLE = @"black";
NSString * const DEFAULT_BUTTON_TYPE = @"plain";

@implementation ApplePayPaymentButtonManager

@synthesize _btnView = _btnView;

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(buttonStyle, NSString, ApplePayPaymentButton)
{
  if (json) {
    self.buttonStyle = [RCTConvert NSString:json];
    [_btnView setButtonType:self.buttonType andStyle:self.buttonStyle];
  }
}

RCT_CUSTOM_VIEW_PROPERTY(buttonType, NSString, ApplePayPaymentButton)
{
  if (json) {
    self.buttonType = [RCTConvert NSString:json];
    [_btnView setButtonType:self.buttonType andStyle:self.buttonStyle];
  }
}

RCT_CUSTOM_VIEW_PROPERTY(enabled, BOOL, ApplePayPaymentButton)
{
  if (json) {
    view.pkPaymentBtn.enabled = [RCTConvert BOOL:json];
  } else {
    view.pkPaymentBtn.enabled = defaultView.pkPaymentBtn.enabled;
  }
}

- (UIView *) view
{
  self.buttonType = DEFAULT_BUTTON_TYPE;
  self.buttonStyle = DEFAULT_BUTTON_STYLE;
  
  _btnView = [ApplePayPaymentButton new];
  [_btnView setButtonType:self.buttonType andStyle:self.buttonStyle];
  
  return _btnView;
}

@end
