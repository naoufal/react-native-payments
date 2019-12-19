//
//  ApplePayPaymentButtonManager.m
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "PKPaymentButtonView.h"

NSString * const DEFAULT_BUTTON_TYPE = @"plain";
NSString * const DEFAULT_BUTTON_STYLE = @"black";

@implementation PKPaymentButtonView

@synthesize buttonType = _buttonType;
@synthesize buttonStyle = _buttonStyle;
@synthesize button = _button;

- (instancetype) init {
  self = [super init];
  
  [self setButtonType:DEFAULT_BUTTON_TYPE andStyle:DEFAULT_BUTTON_STYLE];
  
  return self;
}

- (void)setButtonType:(NSString *) value {
  if (_buttonType != value) {
    [self setButtonType:value andStyle:_buttonStyle];
  }
  
  _buttonType = value;
}

- (void)setButtonStyle:(NSString *) value {
  if (_buttonStyle != value) {
    [self setButtonType:_buttonType andStyle:value];
  }
  
  _buttonStyle = value;
}

/**
 * PKPayment button cannot be modified. Due to this limitation, we have to
 * unmount existint button and create new one whenever it's style and/or
 * type is changed.
 */
- (void)setButtonType:(NSString *) buttonType andStyle:(NSString *) buttonStyle {
  for (UIView *view in self.subviews) {
    [view removeFromSuperview];
  }

  PKPaymentButtonType type;
  PKPaymentButtonStyle style;
  
  if ([buttonType isEqualToString: @"buy"]) {
    type = PKPaymentButtonTypeBuy;
  } else if ([buttonType isEqualToString: @"setUp"]) {
    type = PKPaymentButtonTypeSetUp;
  } else if ([buttonType isEqualToString: @"inStore"]) {
    type = PKPaymentButtonTypeInStore;
  } else if ([buttonType isEqualToString: @"donate"]) {
    type = PKPaymentButtonTypeDonate;
  } else {
    type = PKPaymentButtonTypePlain;
  }

  if ([buttonStyle isEqualToString: @"white"]) {
    style = PKPaymentButtonStyleWhite;
  } else if ([buttonStyle isEqualToString: @"whiteOutline"]) {
    style = PKPaymentButtonStyleWhiteOutline;
  } else {
    style = PKPaymentButtonStyleBlack;
  }

  _button = [[PKPaymentButton alloc] initWithPaymentButtonType:type paymentButtonStyle:style];
  [_button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
  
  [self addSubview:_button];
}

/**
 * Respond to touch event
 */
- (void)touchUpInside:(PKPaymentButton *)button {
  if (self.onPress) {
    self.onPress(nil);
  }
}

/**
 * Set button frame to what React sets for parent view.
 */
- (void)layoutSubviews
{
  [super layoutSubviews];
  _button.frame = self.bounds;
}

@end
