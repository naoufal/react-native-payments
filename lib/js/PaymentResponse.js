// @flow

// Types
import type { PaymentComplete } from './types';

// Modules
import NativePayments from './NativePayments';

import { setReadOnlyAttributesOnObject } from './utils';

// Constants
const READ_ONLY_ATTRIBUTES = [
  'requestId',
  'methodName',
  'details',

  // The attributes below are optional
  'shippingAddress',
  'shippingOption',
  'payerName',
  'payerEmail',
  'payerPhone'
];

export default class PaymentResponse {
  // Internal Slots
  _completeCalled: boolean;

  constructor(paymentResponse: Object) {
    setReadOnlyAttributesOnObject(paymentResponse, READ_ONLY_ATTRIBUTES)(this);

    // Internal Slots
    this._completeCalled = false;
  }

  // https://www.w3.org/TR/payment-request/#complete-method
  complete(paymentStatus: PaymentComplete) {
    if (this._completeCalled === true) {
      throw new Error('InvalidStateError');
    }

    this._completeCalled = true;

    return new Promise((resolve, reject) => {
      return NativePayments.complete(paymentStatus, () => {
        return resolve(undefined);
      });
    });
  }
}
