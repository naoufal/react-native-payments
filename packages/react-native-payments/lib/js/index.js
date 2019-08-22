// @flow

import { NativeModules } from 'react-native'
import _PaymentRequest from './PaymentRequest';
import { PKPaymentButton } from './PKPaymentButton';

export const ApplePayButton = PKPaymentButton;
export const PaymentRequest = _PaymentRequest;
export const GPay = NativeModules.GPay;