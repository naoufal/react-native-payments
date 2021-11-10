const {
  mockReactNativeIOS,
  mockNativePaymentsSupportedIOS,
  mockNativePaymentsUnsupportedIOS
} = require('../__mocks__');

jest.mock('react-native', () => mockReactNativeIOS);
jest.mock('../../NativeBridge', () => mockNativePaymentsSupportedIOS);
const PaymentRequest = require('../').default;
const PaymentRequestUpdateEvent = require('../PaymentRequestUpdateEvent')
  .default;

// helpers
import {
  createCreatedPaymentRequest,
  createInteractivePaymentRequest,
  createInteractiveCreditPaymentRequest,
  createInteractiveDebitPaymentRequest,
  createClosedPaymentRequest,
  createUpdatingPaymentRequest,
  APPLE_PAY_DETAILS
} from './index.test.js';

// constants
const id = 'foo';
const total = {
  label: 'Total',
  amount: { currency: 'USD', value: '20.00' }
};
const displayItems = [
  {
    label: 'Subtotal',
    amount: { currency: 'USD', value: '20.00' }
  }
];
const shippingOptions = [
  {
    id: 'economy',
    label: 'Economy Shipping (5-7 Days)',
    amount: {
      currency: 'USD',
      value: '0.00'
    },
    selected: true
  }
];
const METHOD_DATA = [
  {
    supportedMethods: ['apple-pay'],
    data: {
      merchantId: '12345'
    }
  }
];
const DETAILS = {
  id,
  total,
  displayItems
};
const OPTIONS = {
  requestShipping: true
};

describe('PaymentRequestUpdateEvent', () => {
  const paymentRequest = new PaymentRequest(METHOD_DATA, DETAILS, OPTIONS);

  describe('constructor', () => {
    it("should throw if `name` isn't `shippingaddresschange` or `shippingoptionchange` or `paymentmethodchange`", () => {
      expect(() => {
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'foo',
          paymentRequest
        );
      }).toThrow();
    });
  });

  describe('attributes', () => {
    describe('name', () => {
      it('should return the event name', () => {
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange',
          paymentRequest
        );

        expect(paymentRequestUpdateEvent.name).toBe('shippingaddresschange');
      });
    });

    describe('target', () => {
      it('should return the PaymentRequest instance', () => {
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange',
          paymentRequest
        );

        expect(paymentRequestUpdateEvent.target).toBeInstanceOf(PaymentRequest);
      });
    });
  });

  describe('attributes', () => {
    describe('name', () => {
      it('should return the event name paymentmethodchange', () => {
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'paymentmethodchange',
          paymentRequest
        );

        expect(paymentRequestUpdateEvent.name).toBe('paymentmethodchange');
      });
    });

    describe('target', () => {
      it('should return the PaymentRequest instance paymentmethodchange', () => {
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'paymentmethodchange',
          paymentRequest
        );

        expect(paymentRequestUpdateEvent.target).toBeInstanceOf(PaymentRequest);
      });
    });
  });

  describe('methods', () => {
    describe('updateWith', () => {
      const updateDetails = {
        displayItems: [
          ...displayItems,
          {
            label: 'Shipping',
            amount: { currency: 'USD', value: '25.00' }
          }
        ],
        total: {
          label: 'Total',
          amount: { currency: 'USD', value: '25.00' }
        },
        shippingOptions: [
          {
            id: 'economy',
            label: 'Economy Shipping (5-7 Days)',
            amount: {
              currency: 'USD',
              value: '5.00'
            },
            selected: true
          }
        ],
        modifiers: 'foo' // Not sure how these are used yet
      };

      const updateCreditDetails = {
        id: 'credit_card_details',
        displayItems: [
          {
            label: 'Movie Ticket',
            amount: {currency: 'USD', value: '15.00'}
          },
          {
            label: 'Fee',
            amount: {currency: 'USD', value: '3.50'}
          }
        ],
        shippingOptions: [{
          id: 'economy',
          label: 'Economy Shipping',
          amount: {currency: 'USD', value: '0.00'},
          detail: 'Arrives in 3-5 days' // `detail` is specific to React Native Payments
        }],
        total: {
          label: 'Merchant Name',
          amount: {currency: 'USD', value: '18.50'},
        }
      };

      const updateDebitDetails = {
        id: 'debit_card_details',
        displayItems: [
          {
            label: 'Movie Ticket',
            amount: {currency: 'USD', value: '15.00'}
          },
          {
            label: 'Fee',
            amount: {currency: 'USD', value: '2.99'}
          }
        ],
        shippingOptions: [{
          id: 'economy',
          label: 'Economy Shipping',
          amount: {currency: 'USD', value: '0.00'},
          detail: 'Arrives in 3-5 days' // `detail` is specific to React Native Payments
        }],
        total: {
          label: 'Merchant Name',
          amount: {currency: 'USD', value: '17.99'},
        }
      };

      const DEFAULT_DETAILS = {
        id: 'default_details',
        displayItems: [
          {
            label: 'Rent',
            amount: {currency: 'USD', value: '15.00'}
          },
          {
            label: 'Fee',
            amount: {currency: 'USD', value: '0.00'}
          }
        ],
        shippingOptions: [{
          id: 'economy',
          label: 'Economy Shipping',
          amount: {currency: 'USD', value: '0.00'},
          detail: 'Arrives in 3-5 days' // `detail` is specific to React Native Payments
        }],
        total: {
          label: 'Merchant Name',
          amount: {currency: 'USD', value: '10'},
        }
      };

      const updatedCreditDetails = Object.assign({}, DEFAULT_DETAILS, updateCreditDetails);
      const updatedDebitDetails = Object.assign({}, DEFAULT_DETAILS, updateDebitDetails);

      const updatedDetails = Object.assign({}, DETAILS, updateDetails);

      it('should throw if `target` is not an instance of PaymentRequest', async () => {
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange'
        );

        let error = null;

        try {
          await paymentRequestUpdateEvent.updateWith(updateDetails);
        } catch(e) {
          error = e;
        }

        expect(error.message).toBe('TypeError');
      });

      it('should throw if `_waitForUpdate` is `true`', async () => {
        const interactivePaymentRequest = createInteractivePaymentRequest(
          METHOD_DATA,
          DETAILS,
          OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange',
          interactivePaymentRequest
        );

        let error = null;

        try {
          // While waiting for the first `updateWith` to resolve,
          // it's internal `_waitForUpdate` property gets set
          // to `true`.
          await paymentRequestUpdateEvent.updateWith();

          // When the second `updateWith` is fired, the class
          // throws.
          await paymentRequestUpdateEvent.updateWith(updateDetails);
        } catch(e) {
          error = e;
        }

        expect(error.message).toBe('InvalidStateError');
      });

      it('should throw if `target._state` is not equal to `interactive`', async () => {
        let error1 = null;

        try {
          const createdPaymentRequest = createCreatedPaymentRequest(
            METHOD_DATA,
            DETAILS,
            OPTIONS
          );
          const event1 = new PaymentRequestUpdateEvent(
            'shippingaddresschange',
            createdPaymentRequest
          );

          await event1.updateWith(updateDetails);
        } catch(e1) {
          error1 = e1;
        }

        expect(error1.message).toBe('InvalidStateError');

        let error2 = null;

        try {
          const closedPaymentRequest = createClosedPaymentRequest(
            METHOD_DATA,
            DETAILS,
            OPTIONS
          );
          const event2 = new PaymentRequestUpdateEvent(
            'shippingaddresschange',
            closedPaymentRequest
          );

          await event2.updateWith(updateDetails);
        } catch(e2) {
          error2 = e2;
        }

        expect(error2.message).toBe('InvalidStateError');
      });

      it('should throw if `target.updating` is `true`', async () => {
        const updatingPaymentRequest = createUpdatingPaymentRequest(
          METHOD_DATA,
          DETAILS,
          OPTIONS
        );

        let error = null;

        try {
          const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
            'shippingaddresschange',
            updatingPaymentRequest
          );

          await paymentRequestUpdateEvent.updateWith({});
        } catch(e) {
          error = e;
        }

        expect(error.message).toBe('InvalidStateError');
      });

      it('should successfully update target details when passed an Object', async () => {
        const interactivePaymentRequest = createInteractivePaymentRequest(
          METHOD_DATA,
          DETAILS,
          OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange',
          interactivePaymentRequest
        );

        await paymentRequestUpdateEvent.updateWith(updateDetails);

        expect(interactivePaymentRequest._details).toEqual(updatedDetails);
      });

      it('should successfully update target details for credit paymentmethodchange when passed an Object', async () => {
        const interactivePaymentRequest = createInteractiveCreditPaymentRequest(
          METHOD_DATA,
          APPLE_PAY_DETAILS,
          OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'paymentmethodchange',
          interactivePaymentRequest
        );

        await paymentRequestUpdateEvent.updateWith(updateCreditDetails);

        expect(interactivePaymentRequest._details).toEqual(updatedCreditDetails);
      });

      it('should successfully update target details for debit paymentmethodchange when passed an Object', async () => {
        const interactivePaymentRequest = createInteractiveDebitPaymentRequest(
            METHOD_DATA,
            APPLE_PAY_DETAILS,
            OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
            'paymentmethodchange',
            interactivePaymentRequest
        );

        await paymentRequestUpdateEvent.updateWith(updateDebitDetails);

        expect(interactivePaymentRequest._details).toEqual(updatedDebitDetails);
      });

      it('should successfully update target details when passed a Promise that returns an Object', async () => {
        const interactivePaymentRequest = createInteractivePaymentRequest(
          METHOD_DATA,
          DETAILS,
          OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange',
          interactivePaymentRequest
        );

        await paymentRequestUpdateEvent.updateWith(() => {
          return Promise.resolve(updateDetails);
        });

        expect(interactivePaymentRequest._details).toEqual(updatedDetails);
      });

      it('should successfully update target details for credit paymentmethodchange when passed a Promise that returns an Object', async () => {
        const interactivePaymentRequest = createInteractiveCreditPaymentRequest(
            METHOD_DATA,
            APPLE_PAY_DETAILS,
            OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
            'paymentmethodchange',
            interactivePaymentRequest
        );

        await paymentRequestUpdateEvent.updateWith(() => {
          return Promise.resolve(updateCreditDetails);
        });

        expect(interactivePaymentRequest._details).toEqual(updatedCreditDetails);
      });

      it('should successfully update target details for debit paymentmethodchange when passed a Promise that returns an Object', async () => {
        const interactivePaymentRequest = createInteractiveDebitPaymentRequest(
            METHOD_DATA,
            APPLE_PAY_DETAILS,
            OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
            'paymentmethodchange',
            interactivePaymentRequest
        );

        await paymentRequestUpdateEvent.updateWith(() => {
          return Promise.resolve(updateDebitDetails);
        });

        expect(interactivePaymentRequest._details).toEqual(updatedDebitDetails);
      });

      it('should return a rejected promise upon rejection of the details Promise', async () => {
        const interactivePaymentRequest = createInteractivePaymentRequest(
          METHOD_DATA,
          DETAILS,
          OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange',
          interactivePaymentRequest
        );

        let error = null;

        try {
          await paymentRequestUpdateEvent.updateWith(() => {
            return Promise.reject(new Error('Error fetching shipping prices.'));
          });
        } catch(e) {
          error = e;
        }

        expect(error.message).toBe('Error fetching shipping prices.');
      });
    });
  });
});
