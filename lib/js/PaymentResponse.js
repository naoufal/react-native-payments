// @flow

// Types
import type { PaymentComplete } from './types';

// Modules
import NativePayments from './NativePayments';

export default class PaymentResponse {
  // Internal Slots
  _completeCalled: boolean;

  constructor(paymentResponse: Object) {
    const READ_ONLY_ATTRIBUTES = [
      'requestId',
      'methodName',
      'details', // These details are left up to the user-agent (browser)

      // The attributes below are optional
      'shippingAddress',
      'shippingOption',
      'payerName',
      'payerEmail',
      'payerPhone'
    ];

    const readOnlyProps = READ_ONLY_ATTRIBUTES.reduce((accumulator, attribute) => {
      if (!paymentResponse[attribute]) {
        return accumulator;
      }

      return Object.assign({}, accumulator, {
        [attribute]: {
          value: paymentResponse[attribute],
          writable: false,
          configurable: false,
          enumerable: true
        }
      });
    }, {});

    // Set readOnly properties
    Object.defineProperties(this, readOnlyProps);

    // Internal Slots
    this._completeCalled = false;
  }

  complete(paymentStatus: PaymentComplete) {
    if (this._completeCalled === true) {
      throw new Error('InvalidStateError');
    }

    this._completeCalled = true;

    return new Promise((resolve, reject) => {
      // return NativePayments.complete(paymentStatus, () => {
      //   resolve(undefined);
      // });
    });
  }
}
