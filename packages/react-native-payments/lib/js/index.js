// @flow

import { NativeModules, requireNativeComponent } from 'react-native'
import _PaymentRequest from './PaymentRequest';
import { PKPaymentButton } from './PKPaymentButton';

export const ApplePayButton = PKPaymentButton;
export const PaymentRequest = _PaymentRequest;
export const GPay = NativeModules.GPay;
export const GooglePayImage = requireNativeComponent("GooglePayImageView");
