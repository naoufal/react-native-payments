//
//  ApplePayPaymentButton.h
//  ReactNativePaymentsExample
//
//  Created by Andrej on 16/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTView.h>
#import <PassKit/PassKit.h>

@interface ApplePayPaymentButton : RCTView

@property (nonatomic, readonly) PKPaymentButton *pkPaymentBtn;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;

- (void)setStyle:(PKPaymentButtonStyle) buttonStyle andType:(PKPaymentButtonType) buttonType;

@end
