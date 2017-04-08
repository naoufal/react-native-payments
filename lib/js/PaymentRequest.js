// @flow

// TODO:
// - Implement NativePayments.show, NativePayments.dismiss, NativePayments.canMakePayments (exportConstant)

// Types
import type {
  PaymentMethodData,
  PaymentDetailsInit,
  PaymentOptions
} from './types';
import type PaymentResponseType from './PaymentResponse';

// Modules
import { Platform, DeviceEventEmitter } from 'react-native';
import uuid from 'uuid/v1';

import NativePayments from './NativePayments';
import PaymentResponse from './PaymentResponse';

// Constants
const MODULE_SCOPING = 'NativePayments';
const SHIPPING_ADDRESS_CHANGE_EVENT = `${MODULE_SCOPING}:onshippingaddresschange`;
const SHIPPING_OPTION_CHANGE_EVENT = `${MODULE_SCOPING}:onshippingoptionchange`;

export default class PaymentRequest {
  id: string;
  shippingAddress: null | string;
  shippingOption: null | string;

  // Internal Slots
  _serializedMethodData: string;
  _serializedModifierData: string;
  _details: Object;
  _options: Object;
  _state: 'created' | 'interactive' | 'closed';
  _updating: boolean;
  _acceptPromise: Promise<any>;
  _shippingAddressChangeSubscription: any; // TODO: - add proper type annotation
  _shippingOptionChangeSubscription: any; // TODO: - add proper type annotation

  constructor(
    methodData: Array<PaymentMethodData>,
    details: PaymentDetailsInit,
    options?: PaymentOptions
  ) {
    if (!methodData || !details) {
      throw new Error('`methodData` and `details` are required to instantiate a PaymentRequest.');
    }

    const id = details.id || uuid();

    this.id = id;
    this.shippingAddress = null;
    this.shippingOption = null;

    // Internal Slots
    this._details = Object.assign({}, details, { id });
    this._options = Object.assign({}, options);
    this._updating = false;

    // Setup event listeners
    this.addEventListeners();
  }

  // https://www.w3.org/TR/payment-request/#onshippingaddresschange-attribute
  // https://www.w3.org/TR/payment-request/#onshippingoptionchange-attribute
  addEventListeners() {
    this._shippingAddressChangeSubscription = DeviceEventEmitter
      .addListener(SHIPPING_ADDRESS_CHANGE_EVENT, this.handleShippingAddressChange);
    this._shippingOptionChangeSubscription = DeviceEventEmitter
      .addListener(SHIPPING_OPTION_CHANGE_EVENT, this.handleShippingOptionChange);
  }

  handleShippingAddressChange() {
    alert('handleShippingAddressChange');
  }

  handleShippingOptionChange() {
    alert('handleShippingOptionChange');
  }

  removeEventListeners() {
    DeviceEventEmitter.removeSubscription(this._shippingAddressChangeSubscription);
    DeviceEventEmitter.removeSubscription(this._shippingOptionChangeSubscription);
  }

  // https://www.w3.org/TR/payment-request/#show-method
  show(): Promise<PaymentResponseType> {
    this._acceptPromise = new Promise((resolve, reject) => {
      if (this._state !== 'created') {
        return reject(new Error('InvalidStateError'));
      }


      this._state = 'interactive';
      NativePayments.show((err, paymentToken) => {
        // TODO:
        // - Update NativePayments state to set `showing: true`
        if (err) {
          return reject('')
        }

        const paymentResponse = new PaymentResponse({
          requestId: this.id,
          methodName: Platform.OS === 'ios' ? 'apple-pay' : 'android-pay', // TODO: this is typically visa, or mastercard. Are apple-pay / andorid-pay the right methodName?
          details: { paymentToken }
        });

        return resolve(paymentResponse);
      });
    });

    return this._acceptPromise;
  }

  // https://www.w3.org/TR/payment-request/#abort-method
  abort(): Promise<void> {
    return new Promise((resolve, reject) => {
      // We can't abort if the PaymentRequest isn't shown or already closed
      if (this._state !== 'interactive') {
        return reject(new Error('InvalidStateError'));
      }

      // Try to dismiss the UI
      NativePayments.dismiss((err) => {
        if (err) {
          return reject(new Error('InvalidStateError'));
        }

        this._state = 'closed';
        if (this._acceptPromise) {
          this._acceptPromise.reject(new Error('AbortError'));
        }

        // Remove event listeners before aborting.
        this.removeEventListeners();

        // Return `undefined` as proposed in the spec.
        return resolve(undefined);
      });
    });
  }

  // https://www.w3.org/TR/payment-request/#canmakepayment-method
  canMakePayments(): Promise<boolean> {
    return new Promise((resolve) => {
      return resolve(NativePayments.canMakePayments);
    });
  }
}
