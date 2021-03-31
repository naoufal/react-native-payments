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
  PaymentShippingType,
  PaymentDetailsIOS,
  PaymentDetailsIOSRaw,
} from '../types';
import type PaymentResponseType from './PaymentResponse';

// Modules
import { DeviceEventEmitter, Platform } from 'react-native';
import uuid from 'uuid/v1';

import NativePayments from '../NativeBridge';
import PaymentResponse from './PaymentResponse';
import PaymentRequestUpdateEvent from './PaymentRequestUpdateEvent';

// Helpers
import {
  isValidDecimalMonetaryValue,
  isNegative,
  convertDetailAmountsToString,
  getPlatformMethodData,
  validateTotal,
  validatePaymentMethods,
  validateDisplayItems,
  validateShippingOptions,
  getSelectedShippingOption,
  hasGatewayConfig,
  getGatewayName,
  validateGateway
} from './helpers';

import { ConstructorError, GatewayError } from './errors';

// Constants
import {
  MODULE_SCOPING,
  SHIPPING_ADDRESS_CHANGE_EVENT,
  SHIPPING_OPTION_CHANGE_EVENT,
  INTERNAL_SHIPPING_ADDRESS_CHANGE_EVENT,
  INTERNAL_SHIPPING_OPTION_CHANGE_EVENT,
  USER_DISMISS_EVENT,
  USER_ACCEPT_EVENT,
  GATEWAY_ERROR_EVENT,
  SUPPORTED_METHOD_NAME
} from './constants';

const noop = () => {};
const IS_ANDROID = Platform.OS === 'android';
const IS_IOS = Platform.OS === 'ios'

// function processPaymentDetailsModifiers(details, serializedModifierData) {
//     let modifiers = [];

//     if (details.modifiers) {
//       modifiers = details.modifiers;

//       modifiers.forEach((modifier) => {
//         if (modifier.total && modifier.total.amount && modifier.total.amount.value) {
//           // TODO: refactor validateTotal so that we can display proper error messages (should remove construct 'PaymentRequest')
//           validateTotal(modifier.total);
//         }

//         if (modifier.additionalDisplayItems) {
//           modifier.additionalDisplayItems.forEach((displayItem) => {
//             let value = displayItem && displayItem.amount.value && displayItem.amount.value;

//             isValidDecimalMonetaryValue(value);
//           });
//         }

//         let serializedData = modifier.data
//           ? JSON.stringify(modifier.data)
//           : null;

//         serializedModifierData.push(serializedData);

//         if (modifier.data) {
//           delete modifier.data;
//         }
//       });
//     }

//     details.modifiers = modifiers;
// }

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
  _gatewayErrorSubscription: any; // TODO: - add proper type annotation
  _shippingAddressChangesCount: number;

  _shippingAddressChangeFn: PaymentRequestUpdateEvent => void; // function provided by user
  _shippingOptionChangeFn: PaymentRequestUpdateEvent => void; // function provided by user

  constructor(
    methodData: Array<PaymentMethodData> = [],
    details?: PaymentDetailsInit = [],
    options?: PaymentOptions = {}
  ) {
    // 1. If the current settings object's responsible document is not allowed to use the feature indicated by attribute name allowpaymentrequest, then throw a " SecurityError" DOMException.
    noop();

    // 2. Let serializedMethodData be an empty list.
    // happens in `processPaymentMethods`

    // 3. Establish the request's id:
    if (!details.id) {
      details.id = uuid();
    }

    // 4. Process payment methods
    const serializedMethodData = validatePaymentMethods(methodData);

    // 5. Process the total
    validateTotal(details.total, ConstructorError);

    // 6. If the displayItems member of details is present, then for each item in details.displayItems:
    validateDisplayItems(details.displayItems, ConstructorError);

    // 7. Let selectedShippingOption be null.
    let selectedShippingOption = null;

    // 8. Process shipping options
    validateShippingOptions(details, ConstructorError);

    if (IS_IOS) {
      selectedShippingOption = getSelectedShippingOption(details.shippingOptions);
    }

    // 9. Let serializedModifierData be an empty list.
    let serializedModifierData = [];

    // 10. Process payment details modifiers:
    // TODO
    // - Look into how payment details modifiers are used.
    // processPaymentDetailsModifiers(details, serializedModifierData)

    // 11. Let request be a new PaymentRequest.

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

    // Set attributes (18-20)
    this._id = details.id;

    // 18. Set the value of request's shippingOption attribute to selectedShippingOption.
    this._shippingOption = selectedShippingOption;

    // 19. Set the value of the shippingAddress attribute on request to null.
    this._shippingAddress = null;
    // 20. If options.requestShipping is set to true, then set the value of the shippingType attribute on request to options.shippingType. Otherwise, set it to null.
    this._shippingType = IS_IOS && options.requestShipping === true
      ? options.shippingType
      : null;

    // React Native Payments specific 👇
    // ---------------------------------

    // Setup event listeners
    this._setupEventListeners();

    // Set the amount of times `_handleShippingAddressChange` has been called.
    // This is used on iOS to noop the first call.
    this._shippingAddressChangesCount = 0;

    const platformMethodData = getPlatformMethodData(methodData, Platform.OS);
    const normalizedDetails = convertDetailAmountsToString(details);

    // Validate gateway config if present
    if (hasGatewayConfig(platformMethodData)) {
      validateGateway(
        getGatewayName(platformMethodData),
        NativePayments.supportedGateways
      );
    }

    NativePayments.createPaymentRequest(
      platformMethodData,
      normalizedDetails,
      options
    );
  }

  // initialize acceptPromiseResolver/Rejecter
  // mainly for unit tests to work without going through the complete flow.
  _acceptPromiseResolver = () => {}
  _acceptPromiseRejecter = () => {}

  _setupEventListeners() {
    // Internal Events
    this._userDismissSubscription = DeviceEventEmitter.addListener(
      USER_DISMISS_EVENT,
      this._closePaymentRequest.bind(this)
    );
    this._userAcceptSubscription = DeviceEventEmitter.addListener(
      USER_ACCEPT_EVENT,
      this._handleUserAccept.bind(this)
    );

    if (IS_IOS) {
      this._gatewayErrorSubscription = DeviceEventEmitter.addListener(
        GATEWAY_ERROR_EVENT,
        this._handleGatewayError.bind(this)
      );

      // https://www.w3.org/TR/payment-request/#onshippingoptionchange-attribute
      this._shippingOptionChangeSubscription = DeviceEventEmitter.addListener(
        INTERNAL_SHIPPING_OPTION_CHANGE_EVENT,
        this._handleShippingOptionChange.bind(this)
      );

      // https://www.w3.org/TR/payment-request/#onshippingaddresschange-attribute
      this._shippingAddressChangeSubscription = DeviceEventEmitter.addListener(
        INTERNAL_SHIPPING_ADDRESS_CHANGE_EVENT,
        this._handleShippingAddressChange.bind(this)
      );
    }
  }

  _handleShippingAddressChange(postalAddress: PaymentAddress) {
    this._shippingAddress = postalAddress;

    const event = new PaymentRequestUpdateEvent(
      SHIPPING_ADDRESS_CHANGE_EVENT,
      this
    );
    this._shippingAddressChangesCount++;

    // On iOS, this event fires when the PKPaymentRequest is initialized.
    // So on iOS, we track the amount of times `_handleShippingAddressChange` gets called
    // and noop the first call.
    if (IS_IOS && this._shippingAddressChangesCount === 1) {
      return event.updateWith(this._details);
    }

    // Eventually calls `PaymentRequestUpdateEvent._handleDetailsUpdate` when
    // after a details are returned
    this._shippingAddressChangeFn && this._shippingAddressChangeFn(event);
  }

  _handleShippingOptionChange({ selectedShippingOptionId }: Object) {
    // Update the `shippingOption`
    this._shippingOption = selectedShippingOptionId;

    const event = new PaymentRequestUpdateEvent(
      SHIPPING_OPTION_CHANGE_EVENT,
      this
    );

    this._shippingOptionChangeFn && this._shippingOptionChangeFn(event);
  }

  _getPlatformDetails(details: *) {
    return IS_IOS
      ? this._getPlatformDetailsIOS(details)
      : this._getPlatformDetailsAndroid(details);
  }

  _getPlatformDetailsIOS(details: PaymentDetailsIOSRaw): PaymentDetailsIOS {
    const {
      paymentData: serializedPaymentData,
      billingContact: serializedBillingContact,
      shippingContact: serializedShippingContact,
      paymentToken,
      transactionIdentifier,
      paymentMethod
    } = details;

    const isSimulator = transactionIdentifier === 'Simulated Identifier';

    let billingContact = null;
    let shippingContact = null;

    if (serializedBillingContact && serializedBillingContact !== ""){
      try{
        billingContact = JSON.parse(serializedBillingContact);
      }catch(e){}
    }

    if (serializedShippingContact && serializedShippingContact !== ""){
      try{
        shippingContact = JSON.parse(serializedShippingContact);
      }catch(e){}
    }

    return {
      paymentData: isSimulator ? null : JSON.parse(serializedPaymentData),
      billingContact,
      shippingContact,
      paymentToken,
      transactionIdentifier,
      paymentMethod
    };
  }

  _getPlatformDetailsAndroid(details: {
    googleTransactionId: string,
    payerEmail: string,
    paymentDescription: string,
    shippingAddress: Object,
  }) {
    const {
      googleTransactionId,
      paymentDescription
    } = details;

    return {
      googleTransactionId,
      paymentDescription,
      // On Android, the recommended flow is to have user's confirm prior to
      // retrieving the full wallet.
      getPaymentToken: () => NativePayments.getFullWalletAndroid(
        googleTransactionId,
        getPlatformMethodData(JSON.parse(this._serializedMethodData, Platform.OS)),
        convertDetailAmountsToString(this._details)
      )
    };
  }

  _handleUserAccept(details: {
    transactionIdentifier: string,
    paymentData: string,
    shippingAddress: Object,
    payerEmail: string,
    paymentToken?: string,
    paymentMethod: Object
  }) {
    // On Android, we don't have `onShippingAddressChange` events, so we
    // set the shipping address when the user accepts.
    //
    // Developers will only have access to it in the `PaymentResponse`.
    if (IS_ANDROID) {
      const { shippingAddress } = details;
      this._shippingAddress = shippingAddress;
    }

    const paymentResponse = new PaymentResponse({
      requestId: this.id,
      methodName: IS_IOS ? 'apple-pay' : 'android-pay',
      shippingAddress: this._options.requestShipping ? this._shippingAddress : null,
      details: this._getPlatformDetails(details),
      shippingOption: IS_IOS ? this._shippingOption : null,
      payerName: this._options.requestPayerName ? this._shippingAddress.recipient : null,
      payerPhone: this._options.requestPayerPhone ? this._shippingAddress.phone : null,
      payerEmail: IS_ANDROID && this._options.requestPayerEmail
        ? details.payerEmail
        : null
    });

    return this._acceptPromiseResolver(paymentResponse);
  }

  _handleGatewayError(details: { error: string }) {
    return this._acceptPromiseRejecter(new GatewayError(details.error));
  }

  _closePaymentRequest() {
    this._state = 'closed';

    this._acceptPromiseRejecter(new Error('AbortError'));

    // Remove event listeners before aborting.
    this._removeEventListeners();
  }

  _removeEventListeners() {
    // Internal Events
    DeviceEventEmitter.removeSubscription(this._userDismissSubscription);
    DeviceEventEmitter.removeSubscription(this._userAcceptSubscription);

    if (IS_IOS) {
      DeviceEventEmitter.removeSubscription(
        this._shippingAddressChangeSubscription
      );
      DeviceEventEmitter.removeSubscription(
        this._shippingOptionChangeSubscription
      );
    }
  }

  // https://www.w3.org/TR/payment-request/#onshippingaddresschange-attribute
  // https://www.w3.org/TR/payment-request/#onshippingoptionchange-attribute
  addEventListener(
    eventName: 'shippingaddresschange' | 'shippingoptionchange',
    fn: e => Promise<any>
  ) {
    if (eventName === SHIPPING_ADDRESS_CHANGE_EVENT) {
      return (this._shippingAddressChangeFn = fn.bind(this));
    }

    if (eventName === SHIPPING_OPTION_CHANGE_EVENT) {
      return (this._shippingOptionChangeFn = fn.bind(this));
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


      // These arguments are passed because on Android we don't call createPaymentRequest.
      const platformMethodData = getPlatformMethodData(JSON.parse(this._serializedMethodData), Platform.OS);
      const normalizedDetails = convertDetailAmountsToString(this._details);
      const options = this._options;

      // Note: resolve will be triggered via _acceptPromiseResolver() from somwhere else
      return NativePayments.show(platformMethodData, normalizedDetails, options).catch(reject);
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
      NativePayments.abort()
        .then((_bool) => {
          this._closePaymentRequest();
          // Return `undefined` as proposed in the spec.
          return resolve(undefined);
        })
        .catch((_err) => reject(new Error('InvalidStateError')));
    });
  }

  // https://www.w3.org/TR/payment-request/#canmakepayment-method
  canMakePayments(): Promise<boolean> {
    return NativePayments.canMakePayments(
      getPlatformMethodData(JSON.parse(this._serializedMethodData), Platform.OS)
    );
  }

  static canMakePaymentsUsingNetworks = NativePayments.canMakePaymentsUsingNetworks;
}

