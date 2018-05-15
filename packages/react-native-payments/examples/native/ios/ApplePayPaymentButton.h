//
//  ApplePayPaymentButton.h
//  ReactNativePaymentsExample
//
//  Created by Andrej on 16/05/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@interface ApplePayPaymentButton : UIView

@property (nonatomic, readonly) PKPaymentButton *button;

@end
