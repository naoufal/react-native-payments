import _PaymentRequest from './PaymentRequest';
import _NativePayments from './NativeBridge';
import { PKPaymentButton } from './PKPaymentButton';

export const ApplePayButton = PKPaymentButton;
export const PaymentRequest = _PaymentRequest;
export const canMakePayments = _NativePayments.canMakePayments;
