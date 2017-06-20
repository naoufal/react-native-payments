// @flow
'use strict';

// Types
import type {
  PaymentMethodData,
  PaymentDetailsInit,
  PaymentDetailsBase,
  PaymentDetailsUpdate,
  PaymentOptions,
  PaymentShippingOption,
  PaymentItem,
  PaymentAddress,
  PaymentShippingType
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
import PaymentRequestUpdateEvent from './PaymentRequestUpdateEvent';

// Helpers
import { isValidDecimalMonetaryValu } from './helpers';

// Constants
import {
  MODULE_SCOPING,
  SHIPPING_ADDRESS_CHANGE_EVENT,
  SHIPPING_OPTION_CHANGE_EVENT,
  INTERNAL_SHIPPING_ADDRESS_CHANGE_EVENT,
  INTERNAL_SHIPPING_OPTION_CHANGE_EVENT,
  USER_DISMISS_EVENT,
  USER_ACCEPT_EVENT,
  SUPPORTED_METHOD_NAME
} from './constants';

const noop = () => {};

function processPaymentMethods(methodData, serializedMethodData) {
    // Check that at least one payment method is passed in
    if (methodData.length < 1) {
      throw new Error('At least one payment method is required.')
    }

    // Check that each payment method has at least one payment method identifier
    methodData.forEach((paymentMethod) => {
      if (paymentMethod.supportedMethods.length < 1) {
        throw new Error('Each payment method must include at least one payment method identifier.')
      }

      const serializedData = paymentMethod.data
        ? JSON.stringify(paymentMethod.data)
        : null;

      serializedMethodData.push([paymentMethod.supportedMethods, serializedData]);
    });
}

function processTotal(total) {
  const hasTotal = (total && total.amount && total.amount.value);
  // Check that there is a total
  if (!hasTotal) {
    throw new Error('A total value is required.');
  }

  // Check that total is a valid decimal monetary value.
  if (!isValidDecimalMonetaryValue(total.amount.value)) {
      throw new Error(Failed to construct 'PaymentRequest': '1.' is not a valid amount format for total
      throw new Error(`The total "${total.amount.value}" is not a valid decimal monetary value.`);
  }

  // Check that total isn't negative
  if (total.amount.value.charAt(0) === '-') {
    throw new Error(`The total can't be negative`);
  }
}

function processDisplayItems(displayItems) {
  // Check that the value of each display item is a valid decimal monetary value
  if (displayItems) {
    displayItems.forEach((item: PaymentItem) => {
      if (!isValidDecimalMonetaryValue(item && item.amount && item.amount.value)) {
        throw new Error(`"${item.amount.value}" is not a valid decimal monetary value.`);
      }
    });
  }
}

function processShippingOptions(details) {
    let selectedShippingOption = null;
    let shippingOptions = [];

    if (details.shippingOptions) {
      let seenIDs = [];
      shippingOptions = details.shippingOptions;

      shippingOptions.forEach((shippingOption: PaymentShippingOption) => {
        if (!isValidDecimalMonetaryValue(shippingOption.amount.value)) {
          throw new Error(`${shippingOption.amount.value} is not a valid decimal monetary value.`);
        }

        if (seenIDs.includes(shippingOption.id)) {
          seenIDs = [];
          return;
        }

        // TODO:
        // - set first selectedShippingOption
        if (shippingOption.selected === true) {
          selectedShippingOption = shippingOption.id;
        }
      });

      // if no `shippingOption` is set to selected, set first as the selected
      // This happens when you initialize the PaymentRequest with no selected shipping types
      if (shippingOptions.length > 0 && selectedShippingOption === null) {
        selectedShippingOption = shippingOptions[0].id
      }
    }

    return selectedShippingOption;
}

function processPaymentDetailsModifiers(details, serializedModifierData) {
    let modifiers = [];

    if (details.modifiers) {
      modifiers = details.modifiers;

      modifiers.forEach((modifier) => {
        if (modifier.total && modifier.total.amount && modifier.total.amount.value) {
          processTotal(modifier.total);
        }

        if (modifier.additionalDisplayItems) {
          modifier.additionalDisplayItems.forEach((displayItem) => {
            let value = displayItem && displayItem.amount.value && displayItem.amount.value;

            isValidDecimalMonetaryValue(value);
          });
        }

        let serializedData = modifier.data
          ? JSON.stringify(modifier.data)
          : null;

        serializedModifierData.push(serializedData);

        if (modifier.data) {
          delete modifier.data;
        }
      });
    }

    details.modifiers = modifiers;
}

function setInternalSlots(methodData, details, options, serializedModifierData) {
  // TODO
  // - Set these as non-enumerable keys.
  // 12. Set request.[[options]] to options.
  this._options = options;

  // 13. Set request.[[state]] to "created".
  this._state = 'created';

  // 14. Set request.[[updating]] to false.
  this._updating = false;

  // 15. Set request.[[details]] to details.
  this._details = details;

  // 16. Set request.[[serializedModifierData]] to serializedModifierData.
  this._serializedModifierData = serializedModifierData;

  // 17. Set request.[[serializedMethodData]] to serializedMethodData.
  this._serializedMethodData = JSON.stringify(methodData);
}

function getPlatformMethodData(methodData) {
  // TODO:
  // - Loop through methodData and grab the iOS/Android one
  // and error for anything else.
  return methodData[0].data;
}

export default class PaymentRequest {
  _id: string;
  _shippingAddress: null | PaymentAddress;
  _shippingOption: null | string;
  _shippingType: null | PaymentShippingType;

  // Internal Slots
  _serializedMethodData: string;
  _serializedModifierData: string;
  _details: Object;
  _options: Object;
  _state: 'created' | 'interactive' | 'closed';
  _updating: boolean;
  _acceptPromise: Promise<any>;
  _acceptPromiseResolver: (value: any) => void;
  _acceptPromiseRejecter: (reason: any) => void;
  _shippingAddressChangeSubscription: any; // TODO: - add proper type annotation
  _shippingOptionChangeSubscription: any; // TODO: - add proper type annotation
  _userDismissSubscription: any; // TODO: - add proper type annotation
  _userAcceptSubscription: any; // TODO: - add proper type annotation

  _shippingAddressChangeFn: (PaymentRequestUpdateEvent) => void // function provided by user
  _shippingOptionChangeFn: (PaymentRequestUpdateEvent) => void // function provided by user

  constructor(
    methodData: Array<PaymentMethodData> = [],
    details?: PaymentDetailsInit = [],
    options?: PaymentOptions = {}
  ) {
    // 1. If the current settings object's responsible document is not allowed to use the feature indicated by attribute name allowpaymentrequest, then throw a " SecurityError" DOMException.
    noop();

    // 2. Let serializedMethodData be an empty list.
    let serializedMethodData = [];

    // 3. Establish the request's id:
    if (!details.id) {
      details.id = uuid();
    }

    // 4. Process payment methods
    processPaymentMethods(methodData, serializedMethodData);

    // 5. Process the total
    processTotal(details.total);

    // 6. If the displayItems member of details is present, then for each item in details.displayItems:
    processDisplayItems(details.displayItems);

    // 7. Let selectedShippingOption be null.
    // happens in `processShippingOptions`

    // 8. Process shipping options
    const selectedShippingOption = processShippingOptions(details);

    // 9. Let serializedModifierData be an empty list.
    let serializedModifierData = [];

    // 10. Process payment details modifiers:
    processPaymentDetailsModifiers(details, serializedModifierData)

    // 11. Let request be a new PaymentRequest.

    // Set internal Slots (12-17)
    setInternalSlots.bind(this)(methodData, details, options, serializedModifierData);

    // Set attributes (18-20)
    this._id = details.id;

    // 18. Set the value of request's shippingOption attribute to selectedShippingOption.
    this._shippingOption = selectedShippingOption;

    // 19. Set the value of the shippingAddress attribute on request to null.
    this._shippingAddress = null;
    // 20. If options.requestShipping is set to true, then set the value of the shippingType attribute on request to options.shippingType. Otherwise, set it to null.
    this._shippingType = options.requestShipping === true
        ? options.shippingType
        : null

    // React Native Payments specific 👇
    // ---------------------------------

    // Setup event listeners
    this._setupEventListeners();

    const platformMethodData = getPlatformMethodData(methodData);

    NativePayments.createPaymentRequest(platformMethodData, details, options);
  }

  _setupEventListeners() {
    // Internal Events
    this._userDismissSubscription = DeviceEventEmitter
      .addListener(USER_DISMISS_EVENT, this._closePaymentRequest.bind(this));
    this._userAcceptSubscription = DeviceEventEmitter
      .addListener(USER_ACCEPT_EVENT, this._handleUserAccept.bind(this));

    // https://www.w3.org/TR/payment-request/#onshippingoptionchange-attribute
    this._shippingOptionChangeSubscription = DeviceEventEmitter
      .addListener(INTERNAL_SHIPPING_OPTION_CHANGE_EVENT, this._handleShippingOptionChange.bind(this));

    // https://www.w3.org/TR/payment-request/#onshippingaddresschange-attribute
    this._shippingAddressChangeSubscription = DeviceEventEmitter
      .addListener(INTERNAL_SHIPPING_ADDRESS_CHANGE_EVENT, this._handleShippingAddressChange.bind(this));
    // `details.shippingOptions` need to be `undefined` or an `empty array` upon initialization in order to receive shippingaddresschange event. Otherwise, the event won't be fired.
    // if (this._details.shippingOptions === undefined || this._details.shippingOptions === []) {
    // }
  }

  _handleShippingAddressChange(postalAddress: PaymentAddress) {
    // TODO:
    // - Use PaymentAddress type
    this._shippingAddress = postalAddress;

    const event = new PaymentRequestUpdateEvent(SHIPPING_ADDRESS_CHANGE_EVENT, this);

    // Eventually calls `PaymentRequestUpdateEvent._handleDetailsUpdate` when
    // after a details are returned
    this._shippingAddressChangeFn(event);
  }

  _handleShippingOptionChange({ selectedShippingOptionId }: Object) {

    // Update the `shippingOption`
    this._shippingOption = selectedShippingOptionId;

    const event = new PaymentRequestUpdateEvent(SHIPPING_OPTION_CHANGE_EVENT, this);

    this._shippingOptionChangeFn(event);
  }

  _getPlatformDetails(details: { transactionIdentifier: string, paymentData: string }) {
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
1
    return null;
  }

  _handleUserAccept(details: { transactionIdentifier: string, paymentData: string }) {
    const platformDetails = this._getPlatformDetails(details);
    const paymentResponse = new PaymentResponse({
      requestId: this.id,
      methodName: Platform.OS === 'ios' ? 'apple-pay' : 'android-pay',
      details: platformDetails
    });

    return this._acceptPromiseResolver(paymentResponse);
  }

  _closePaymentRequest() {
    this._state = 'closed';

    if (this._acceptPromise && this._acceptPromise.reject) {
      this._acceptPromiseRejecter(new Error('AbortError'));
    }

    // Remove event listeners before aborting.
    this._removeEventListeners();
  }

  _removeEventListeners() {
    DeviceEventEmitter.removeSubscription(this._shippingAddressChangeSubscription);
    DeviceEventEmitter.removeSubscription(this._shippingOptionChangeSubscription);

    // Internal Events
    DeviceEventEmitter.removeSubscription(this._userDismissSubscription);
    DeviceEventEmitter.removeSubscription(this._userAcceptSubscription);
  }

  // https://www.w3.org/TR/payment-request/#onshippingaddresschange-attribute
  // https://www.w3.org/TR/payment-request/#onshippingoptionchange-attribute
  addEventListener(eventName: 'shippingaddresschange' | 'shippingoptionchange' , fn: (e) => Promise<any>) {
    if (eventName === SHIPPING_ADDRESS_CHANGE_EVENT) {
      return this._shippingAddressChangeFn = fn.bind(this);
    }

    if (eventName === SHIPPING_OPTION_CHANGE_EVENT) {
      return this._shippingOptionChangeFn = fn.bind(this);
    }
  }

  // https://www.w3.org/TR/payment-request/#id-attribute
  get id(): string {
    return this._id;
  }

  // https://www.w3.org/TR/payment-request/#shippingaddress-attribute
  get shippingAddress(): null | PaymentAddress {
    return this._shippingAddress;
  }

  // https://www.w3.org/TR/payment-request/#shippingoption-attribute
  get shippingOption(): null | string {
    return this._shippingOption;
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

        this._closePaymentRequest();

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