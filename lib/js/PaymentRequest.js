// @flow

// Types
import type {
  PaymentMethodData,
  PaymentDetailsInit,
  PaymentOptions
} from './types';
import type PaymentResponseType from './PaymentResponse';

// Modules
import {
  DeviceEventEmitter,
  Platform
 } from 'react-native';
import uuid from 'uuid/v1';

import NativePayments from './NativePayments';
import PaymentResponse from './PaymentResponse';

// Constants
const MODULE_SCOPING = 'NativePayments';
const SHIPPING_ADDRESS_CHANGE_EVENT = `${MODULE_SCOPING}:onshippingaddresschange`;
const SHIPPING_OPTION_CHANGE_EVENT = `${MODULE_SCOPING}:onshippingoptionchange`;
const USER_DISMISS_EVENT = `${MODULE_SCOPING}:onuserdismiss`;
const USER_ACCEPT_EVENT = `${MODULE_SCOPING}:onuseraccept`;
const SUPPORTED_METHOD_NAME = Platform.OS === 'ios' ? 'apple-pay' : 'android-pay';

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
  _acceptPromiseResolver: (value: any) =>  void;
  _acceptPromiseRejecter: (reason: any) =>  void;
  _shippingAddressChangeSubscription: any; // TODO: - add proper type annotation
  _shippingOptionChangeSubscription: any; // TODO: - add proper type annotation
  _userDismissSubscription: any; // TODO: - add proper type annotation
  _userAcceptSubscription: any; // TODO: - add proper type annotation

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

    // TODO:
    // - Loop through methodData and grab the iOS/Android one
    // and error for anything else.
    NativePayments.createPaymentRequest(methodData[0].data, details, options)
      .then(() => this._state = 'created');
  }

  addEventListeners() {
    // https://www.w3.org/TR/payment-request/#onshippingaddresschange-attribute
    this._shippingAddressChangeSubscription = DeviceEventEmitter
      .addListener(SHIPPING_ADDRESS_CHANGE_EVENT, this.handleShippingAddressChange);

    // https://www.w3.org/TR/payment-request/#onshippingoptionchange-attribute
    this._shippingOptionChangeSubscription = DeviceEventEmitter
      .addListener(SHIPPING_OPTION_CHANGE_EVENT, this.handleShippingOptionChange);

    // Internal Events
    this._userDismissSubscription = DeviceEventEmitter
      .addListener(USER_DISMISS_EVENT, this.closePaymentRequest.bind(this));
    this._userAcceptSubscription = DeviceEventEmitter
      .addListener(USER_ACCEPT_EVENT, this.handleUserAccept.bind(this));
  }

  handleShippingAddressChange() {
    alert('handleShippingAddressChange');
  }

  handleShippingOptionChange() {
    alert('handleShippingOptionChange');
  }

  getPlatformDetails(details: { transactionIdentifier: string, paymentData: string }) {
    if (Platform.OS === 'ios') {
      const { transactionIdentifier, paymentData: serializedPaymentData } = details;
      const isSimulator = transactionIdentifier === 'Simulated Identifier';

      if (isSimulator) {
        return Object.assign({}, details, {
          paymentData: null,
          serializedPaymentData
        });
      }

      return {
        transactionIdentifier,
        paymentData: JSON.parse(serializedPaymentData),
        serializedPaymentData
      }
    }

    return null;
  }

  handleUserAccept(details: { transactionIdentifier: string, paymentData: string }) {
    const platformDetails = this.getPlatformDetails(details);
    const paymentResponse = new PaymentResponse({
      requestId: this.id,
      methodName: Platform.OS === 'ios' ? 'apple-pay' : 'android-pay',
      details: platformDetails
    });

    return this._acceptPromiseResolver(paymentResponse);
  }

  closePaymentRequest() {
    this._state = 'closed';

    if (this._acceptPromise && this._acceptPromise.reject) {
      this._acceptPromiseRejecter(new Error('AbortError'));
    }

    // Remove event listeners before aborting.
    this.removeEventListeners();
  }

  removeEventListeners() {
    DeviceEventEmitter.removeSubscription(this._shippingAddressChangeSubscription);
    DeviceEventEmitter.removeSubscription(this._shippingOptionChangeSubscription);

    // Internal Events
    DeviceEventEmitter.removeSubscription(this._userDismissSubscription);
    DeviceEventEmitter.removeSubscription(this._userAcceptSubscription);
  }

  // https://www.w3.org/TR/payment-request/#show-method
  show(): Promise<PaymentResponseType> {
    this._acceptPromise = new Promise((resolve, reject) => {
      this._acceptPromiseResolver = resolve;
      this._acceptPromiseRejecter = reject;
      if (this._state !== 'created') {
        return reject(new Error('InvalidStateError'));
      }

      this._state = 'interactive';

      return NativePayments.show();
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
      NativePayments.abort((err) => {
        if (err) {
          return reject(new Error('InvalidStateError'));
        }

        this.closePaymentRequest();

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
