import _PaymentRequest from './PaymentRequest';
import _NativeBridge from './NativeBridge';
import { PKPaymentButton } from './PKPaymentButton';

export const ApplePayButton = PKPaymentButton;
export const PaymentRequest = _PaymentRequest;
export const canMakePayments = _NativeBridge.canMakePayments;
