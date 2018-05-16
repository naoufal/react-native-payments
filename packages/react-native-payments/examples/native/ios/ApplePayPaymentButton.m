//
//  ApplePayPaymentButtonManager.m
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ApplePayPaymentButton.h"

@implementation ApplePayPaymentButton

@synthesize button = _button;

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    [self addSubview:[self makeButton]];
    return self;
  }
  
  return nil;
}

- (PKPaymentButton *)makeButton {
  if (!_button) {
    _button = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypePlain paymentButtonStyle:PKPaymentButtonStyleBlack];
    [_button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _button;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  self.button.frame = self.bounds;
}

- (void)touchUpInside:(PKPaymentButton *)button {
  if (self.onPress) {
    self.onPress(nil);
  }
}

@end
