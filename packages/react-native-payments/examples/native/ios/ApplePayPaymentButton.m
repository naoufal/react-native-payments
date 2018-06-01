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
  
  if (self) {
    [self setStyle:PKPaymentButtonStyleBlack andType:PKPaymentButtonTypePlain];
  }
  
  return self;
}

- (void)setStyle:(PKPaymentButtonStyle) buttonStyle andType:(PKPaymentButtonType) buttonType {
  NSLog(@"make button");
  _pkPaymentBtn = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypePlain paymentButtonStyle:PKPaymentButtonStyleBlack];
  [_pkPaymentBtn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_pkPaymentBtn];
}

- (void) destroyButton {
  if (_pkPaymentBtn && _pkPaymentBtn.superview) {
    [_pkPaymentBtn removeFromSuperview];
    _pkPaymentBtn = nil;
  }
}

- (id) updateButtonStyle: (NSString *) buttonStyle buttonType:(NSString *) buttonType {
  [self destroyButton];
  [self setStyle:PKPaymentButtonStyleWhiteOutline andType:PKPaymentButtonTypeSetUp];
  return nil;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  NSLog(@"layout");
  _pkPaymentBtn.frame = self.bounds;
}

- (void)touchUpInside:(PKPaymentButton *)button {
  if (self.onPress) {
    self.onPress(nil);
  }
}

@end
