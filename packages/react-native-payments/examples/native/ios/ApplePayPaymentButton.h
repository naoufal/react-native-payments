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

@property (nonatomic, readonly) PKPaymentButton *button;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;

@end
