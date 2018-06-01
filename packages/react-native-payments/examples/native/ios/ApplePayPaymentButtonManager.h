//
//  ApplePayPaymentButtonManager.h
//  ReactNativePaymentsExample
//
//  Created by Andrej on 15/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTViewManager.h>
#import "ApplePayPaymentButton.h"

@interface ApplePayPaymentButtonManager : RCTViewManager

@property ApplePayPaymentButton* _btnView;
@property NSString *buttonStyle;
@property NSString *buttonType;

@end
