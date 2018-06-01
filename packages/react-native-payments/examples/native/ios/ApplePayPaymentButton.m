//
//  ApplePayPaymentButtonManager.m
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ApplePayPaymentButton.h"

@implementation ApplePayPaymentButton

@synthesize pkPaymentBtn = _pkPaymentBtn;

- (instancetype) init {
  self = [super init]; 
  return self;
}

/**
 * PKPayment button cannot be modified. Due to this limitation, we have to
 * unmount existint button and create new one whenever it's style and/or
 * type is changed.
 */
- (void)setButtonType:(NSString *) buttonType andStyle:(NSString *) buttonStyle {
  
  if (_pkPaymentBtn && _pkPaymentBtn.superview) {
    [_pkPaymentBtn removeFromSuperview];
    _pkPaymentBtn = nil;
  }
  
  PKPaymentButtonType type;
  PKPaymentButtonStyle style;

  if ([buttonType isEqual: @"buy"]) {
    type = PKPaymentButtonTypeBuy;
  } else if ([buttonType isEqual: @"setUp"]) {
    type = PKPaymentButtonTypeSetUp;
  } else if ([buttonType isEqual: @"inStore"]) {
    type = PKPaymentButtonTypeInStore;
  } else if ([buttonType isEqual: @"donate"]) {
    type = PKPaymentButtonTypeDonate;
  } else {
    type = PKPaymentButtonTypePlain;
  }

  if ([buttonStyle isEqual: @"white"]) {
    style = PKPaymentButtonStyleWhite;
  } else if ([buttonStyle isEqual: @"whiteOutline"]) {
    style = PKPaymentButtonStyleWhiteOutline;
  } else {
    style = PKPaymentButtonStyleBlack;
  }

  _pkPaymentBtn = [[PKPaymentButton alloc] initWithPaymentButtonType:type paymentButtonStyle:style];
  [_pkPaymentBtn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
  
  [self addSubview:_pkPaymentBtn];
}

/**
 * Respond to touch event
 */
- (void)touchUpInside:(PKPaymentButton *)button {
  if (self.onPress) {
    self.onPress(nil);
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _pkPaymentBtn.frame = self.bounds;
}

@end
