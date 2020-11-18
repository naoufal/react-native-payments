//
//  ApplePayPaymentButton.h
//  ReactNativePaymentsExample
//
//  Created by Andrej on 16/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTView.h>
#import <PassKit/PassKit.h>

@interface PKPaymentButtonView : RCTView

@property (strong, nonatomic) NSString *buttonStyle;
@property (strong, nonatomic) NSString *buttonType;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic, readonly) PKPaymentButton *button;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;

@end
