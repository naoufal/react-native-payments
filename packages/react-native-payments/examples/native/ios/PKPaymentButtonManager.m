//
//  ApplePayPaymentButtonManager.m
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "PKPaymentButtonManager.h"
#import "PKPaymentButtonView.h"

@implementation PKPaymentButtonManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(buttonType, NSString, PKPaymentButtonView)
{
  if (json) {
    [view setButtonType:[RCTConvert NSString:json]];
  }
}

RCT_CUSTOM_VIEW_PROPERTY(buttonStyle, NSString, PKPaymentButtonView)
{
  if (json) {
    [view setButtonStyle:[RCTConvert NSString:json]];
  }
}

- (UIView *) view
{
  return [PKPaymentButtonView new];
}

@end
