// @flow
import { requireNativeComponent } from 'react-native'
import GPayProxy from "./GooglePayProxy";
import _PaymentRequest from './PaymentRequest';
import { PKPaymentButton } from './PKPaymentButton';

export const GooglePayImage = requireNativeComponent("GooglePayImageView");
export const ApplePayButton = PKPaymentButton;
export const PaymentRequest = _PaymentRequest;
export const GPayRequest = GPayProxy;
