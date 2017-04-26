// @flow

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
import { setReadOnlyAttributesOnObject } from './utils';

// Constants
const MODULE_SCOPING = 'NativePayments';
const SHIPPING_ADDRESS_CHANGE_EVENT = 'shippingaddresschange';
const SHIPPING_OPTION_CHANGE_EVENT = 'shippingoptionchange';
const INTERNAL_SHIPPING_ADDRESS_CHANGE_EVENT = `${MODULE_SCOPING}:on${SHIPPING_ADDRESS_CHANGE_EVENT}`;
const INTERNAL_SHIPPING_OPTION_CHANGE_EVENT = `${MODULE_SCOPING}:on${SHIPPING_OPTION_CHANGE_EVENT}`;
const USER_DISMISS_EVENT = `${MODULE_SCOPING}:onuserdismiss`;
const USER_ACCEPT_EVENT = `${MODULE_SCOPING}:onuseraccept`;
const SUPPORTED_METHOD_NAME = Platform.OS === 'ios' ? 'apple-pay' : 'android-pay';
const READ_ONLY_ATTRIBUTES = [
  'id',

  // The attributes below are optional
  'shippingAddress',
  'shippingOption',
  'shippingType'
];

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

// TODO:
// - implement this
function isValidDecimalMonetaryValue(value) {
  return true;
}

function processTotal(total) {
  const hasTotal = (total && total.amount && total.amount.value);
  // Check that there is a total
  if (!hasTotal) {
    throw new Error('A total value is required.');
  }

  // Check that total is a valid decimal monetary value.
  if (!isValidDecimalMonetaryValue(total.amount.value)) {
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

function processShippingOptions(details, selectedShippingOption) {
    let shippingOptions = [];

    if (details.shippingOptions) {
      let seenIDs = [];
      shippingOptions: Array = details.shippingOptions;

      shippingOptions.forEach((shippingOption: PaymentShippingOption) => {
        if (!isValidDecimalMonetaryValue(shippingOption.amount.value)) {
          throw new Error(`${shippingOption.amount.value} is not a valid decimal monetary value.`);
        }

        if (seenIDs.includes(shippingOption.id)) {
          seenIDs = [];
          return;
        }

        seenIDs.push(shippingOption.id);

        if (shippingOption.selected === true) {
          selectedShippingOption = shippingOption.id;
        }
      });
    }

    details.shippingOptions = shippingOptions;
}

function processPaymentDetailsModifiers(details, serializedModifierData) {
    let modifiers = [];

    if (details.modifiers) {
      modifiers: Array = details.modifiers;

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
    let selectedShippingOption = null;

    // 8. Process shipping options
    processShippingOptions(details, selectedShippingOption);

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

    // // details.shippingOptions need to be undefined or an empty array upon initialization in order to receive shippingaddresschange event. Otherwise, the event won't be fired.
    // if (this._details.shippingOptions !== undefined || this._details.shippingOptions !== []) {
    //   return;
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

  _handleShippingOptionChange(e) {
    alert('handleShippingOptionChange');
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

class PaymentRequestUpdateEvent {
  name: string;
  target: PaymentRequest;
  _waitForUpdate: boolean;
  _handleDetailsChange: (PaymentDetailsModifier) => Promise<any>;
  _resetEvent: any;

  constructor(name, target) {
    if (name !== SHIPPING_ADDRESS_CHANGE_EVENT && name !== SHIPPING_OPTION_CHANGE_EVENT) {
      throw new Error(`Only "${SHIPPING_ADDRESS_CHANGE_EVENT}" and "${SHIPPING_OPTION_CHANGE_EVENT}" event listeners are supported.`);
    }

    this.name = name;
    this.target = target;
    this._waitForUpdate = false;

    this._handleDetailsChange = this._handleDetailsChange.bind(this);
    this._resetEvent = this._resetEvent.bind(this);
  }

  _handleDetailsChange(value: PaymentDetailsBase) {
    const target = this.target;

    // 1. Let details be the result of converting value to a PaymentDetailsUpdate dictionary. If this throws an exception, abort the update with the thrown exception.
    // TODO: - actually
    const details: PaymentDetailsUpdate = Object.assign({}, value, {
      error: '' // can be a message displayed to the user
    });

    // 2. Let serializedModifierData be an empty list.
    let serializedModifierData = [];

    // 3. Let selectedShippingOption be null.
    let selectedShippingOption = null;

    // 4. Let shippingOptions be an empty sequence<PaymentShippingOption>.
    let shippingOptions = [];

    // 5. Validate and canonicalize the details:
    // TODO: implmentation

    // 6. Update the PaymentRequest using the new details:
    // 6.1 If the total member of details is present, then:
    if (details.total) {
      target._details = Object.assign({}, target._details, { total: details.total });
    }

    // 6.2 If the displayItems member of details is present, then:
    if (details.displayItems) {
      target._details = Object.assign({}, target._details, { displayItems: details.displayItems });
    }

    // 6.3 If the shippingOptions member of details is present, and target.[[options]].requestShipping is true, then:
    if (details.shippingOptions && target._options.requestShipping === true) {
      // 6.3.1 Set target.[[details]].shippingOptions to shippingOptions.
      target._details.shippingOptions = shippingOptions;
      target._details = Object.assign({}, target._details, { shippingOptions });

      // 6.3.2 Set the value of target's shippingOption attribute to selectedShippingOption.
      target._shippingOption = selectedShippingOption;
    }

    // 6.4 If the modifiers member of details is present, then:
    if (details.modifiers) {
      // 6.4.1 Set target.[[details]].modifiers to details.modifiers.
      target._details = Object.assign({}, target._details, { modifiers: details.modifiers });

      // 6.4.2 Set target.[[serializedModifierData]] to serializedModifierData.
      target._serializedModifierData = serializedModifierData;
    }

    // 6.5 If target.[[options]].requestShipping is true, and target.[[details]].shippingOptions is empty,
    // then the developer has signified that there are no valid shipping options for the currently-chosen shipping address (given by target's shippingAddress).
    // In this case, the user agent should display an error indicating this, and may indicate that that the currently-chosen shipping address is invalid in some way.
    // The user agent should use the error member of details, if it is present, to give more information about why there are no valid shipping options for that address.


    // TODO:
    // actually update the apple pay sheet
    return NativePayments.handleDetailsUpdate(target._details);
  }

  _resetEvent() {
    // 1. Set event.[[waitForUpdate]] to false.
    this._waitForUpdate = false;

    // 2. Set target.[[updating]] to false.
    this.target._updating = false;

    // 3. The user agent should update the user interface based on any changed values in target.
    // The user agent should re-enable user interface elements that might have been disabled in the steps above if appropriate.
    noop();
  }

  updateWith(fn: (PaymentDetailsModifier, PaymentAddress) => Promise<PaymentDetailsModifier>) {
    // 1. Let event be this PaymentRequestUpdateEvent instance.
    let event = this;

    // 2. Let target be the value of event's target attribute.
    let target = this.target;

    // 3. If target is not a PaymentRequest object, then throw a TypeError.
    if (!(target instanceof PaymentRequest)) {
      throw new Error('TypeError');
    }

    // 5. If event.[[waitForUpdate]] is true, then throw an "InvalidStateError" DOMException.
    if (event._waitForUpdate === true) {
      throw new Error('InvalidStateError');
    }

    // 6. If target.[[state]] is not " interactive", then throw an " InvalidStateError" DOMException.
    if (target._state !== 'interactive') {
      throw new Error('InvalidStateError');
    }

    // 7. If target.[[updating]] is true, then throw an "InvalidStateError" DOMException.
    if (target.updating === true) {
      throw new Error('InvalidStateError');
    }

    // 8. Set event's stop propagation flag and stop immediate propagation flag.
    noop();

    // 9. Set event.[[waitForUpdate]] to true.
    event._waitForUpdate = true;

    // 10. Set target.[[updating]] to true.
    target._updating = true;

    // 11. The user agent should disable the user interface that allows the user to accept the payment request.
    // This is to ensure that the payment is not accepted until the web page has made changes required by the change.
    // The web page must settle the detailsPromise to indicate that the payment request is valid again.
    // The user agent should disable any part of the user interface that could cause another update event to be fired.
    // Only one update may be processed at a time.
    noop(); // NativePayments does this for us (iOS does at the time of this comment)

    const args = this.name === SHIPPING_ADDRESS_CHANGE_EVENT
      ? [target._details, target.shippingAddress]
      : [target._details, target.shippingOption];

    // 12. Return from the method and perform the remaining steps in parallel.
    return fn(...args)
      // 14. Upon fulfillment of detailsPromise with value value
      .then(this._handleDetailsChange)
      .then(this._resetEvent())
      // 13. Upon rejection of detailsPromise:
      .catch(e => {
        this._resetEvent();

        console.log(e);
        throw new Error('AbortError');
      })
  }
}