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

import PaymentRequest from './PaymentRequest';
import NativePayments from './NativePayments';


export default class PaymentRequestUpdateEvent {
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
    const details: PaymentDetailsUpdate = Object.assign({}, value);

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
      shippingOptions = details.shippingOptions;
      target._details = Object.assign({}, target._details, { shippingOptions });

      // 6.3.2 Set the value of target's shippingOption attribute to selectedShippingOption.
      selectedShippingOption = target.shippingOption;
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



    // React Native Payments specific 👇
    // ---------------------------------
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

  updateWith(PaymentDetailsModifierOrFn: PaymentDetailsUpdate | (PaymentDetailsModifier, PaymentAddress) => Promise<PaymentDetailsUpdate>) {
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
    if (target._updating === true) {
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

    if (typeof PaymentDetailsModifierOrFn === 'object') {
      const paymentDetailsModifier = PaymentDetailsModifierOrFn;

      return this._handleDetailsChange(paymentDetailsModifier);
    }

    const fn = PaymentDetailsModifierOrFn;

    // 12. Return from the method and perform the remaining steps in parallel.
    return fn()
      // 14. Upon fulfillment of detailsPromise with value value
      .then(this._handleDetailsChange)
      .then(this._resetEvent())
      // 13. Upon rejection of detailsPromise:
      .catch(e => {
        this._resetEvent();

        throw new Error('AbortError');
      })
  }
}