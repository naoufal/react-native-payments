const {
  mockReactNativeIOS,
  mockNativePaymentsSupportedIOS,
  mockNativePaymentsUnsupportedIOS
} = require('../__mocks__');

jest.mock('react-native', () => mockReactNativeIOS);
jest.mock('../NativePayments', () => mockNativePaymentsSupportedIOS);
const PaymentRequest = require('../PaymentRequest').default;
const PaymentRequestUpdateEvent = require('../PaymentRequestUpdateEvent')
  .default;

// helpers
import {
  createCreatedPaymentRequest,
  createInteractivePaymentRequest,
  createClosedPaymentRequest,
  createUpdatingPaymentRequest
} from './PaymentRequest-test.js';

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
    it("should throw if `name` isn't `shippingaddresschange` or `shippingoptionchange`", () => {
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
      const updatedDetails = Object.assign({}, DETAILS, updateDetails);

      it('should throw if `target` is not an instance of PaymentRequest', () => {
        expect(() => {
          const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
            'shippingaddresschange'
          );
          paymentRequestUpdateEvent.updateWith(updateDetails);
        }).toThrow(new Error('TypeError'));
      });

      it('should throw if `_waitForUpdate` is `true`', () => {
        expect(() => {
          const interactivePaymentRequest = createInteractivePaymentRequest(
            METHOD_DATA,
            DETAILS,
            OPTIONS
          );
          const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
            'shippingaddresschange',
            interactivePaymentRequest
          );

          // While waiting for the first `updateWith` to resolve,
          // it's internal `_waitForUpdate` property gets set
          // to `true`.
          //
          // When the second `updateWith` is fired, the class
          // throws.
          paymentRequestUpdateEvent.updateWith(() => {
            paymentRequestUpdateEvent.updateWith(updateDetails);
            return Promise.resolve(updateDetails);
          });
        }).toThrow(new Error('InvalidStateError'));
      });

      it('should throw if `target._state` is not equal to `interactive`', () => {
        expect(() => {
          const createdPaymentRequest = createCreatedPaymentRequest(
            METHOD_DATA,
            DETAILS,
            OPTIONS
          );
          const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
            'shippingaddresschange',
            createdPaymentRequest
          );

          paymentRequestUpdateEvent.updateWith(updateDetails);
        }).toThrow(new Error('InvalidStateError'));

        expect(() => {
          const closedPaymentRequest = createClosedPaymentRequest(
            METHOD_DATA,
            DETAILS,
            OPTIONS
          );
          const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
            'shippingaddresschange',
            closedPaymentRequest
          );

          paymentRequestUpdateEvent.updateWith(updateDetails);
        }).toThrow(new Error('InvalidStateError'));
      });

      it('should throw if `target.updating` is `true`', () => {
        const updatingPaymentRequest = createUpdatingPaymentRequest(
          METHOD_DATA,
          DETAILS,
          OPTIONS
        );

        expect(() => {
          const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
            'shippingaddresschange',
            updatingPaymentRequest
          );

          paymentRequestUpdateEvent.updateWith({});
        }).toThrow(new Error('InvalidStateError'));
      });

      it('should successfully update target details when passed an Object', () => {
        const interactivePaymentRequest = createInteractivePaymentRequest(
          METHOD_DATA,
          DETAILS,
          OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange',
          interactivePaymentRequest
        );

        paymentRequestUpdateEvent.updateWith(updateDetails);

        expect(interactivePaymentRequest._details).toEqual(updatedDetails);
      });

      it('should successfully update target details when passed a Promise that returns an Object', done => {
        const interactivePaymentRequest = createInteractivePaymentRequest(
          METHOD_DATA,
          DETAILS,
          OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange',
          interactivePaymentRequest
        );

        paymentRequestUpdateEvent
          .updateWith(() => {
            return Promise.resolve(updateDetails);
          })
          .then(() => {
            expect(interactivePaymentRequest._details).toEqual(updatedDetails);
            done();
          });
      });

      it('should return a rejected promise upon rejection of the details Promise', done => {
        const interactivePaymentRequest = createInteractivePaymentRequest(
          METHOD_DATA,
          DETAILS,
          OPTIONS
        );
        const paymentRequestUpdateEvent = new PaymentRequestUpdateEvent(
          'shippingaddresschange',
          interactivePaymentRequest
        );

        return paymentRequestUpdateEvent
          .updateWith(() => {
            return Promise.reject(new Error('Error fetching shipping prices.'));
          })
          .catch(e => {
            expect(e.message).toBe('AbortError');
            done();
          });
      });
    });
  });
});
