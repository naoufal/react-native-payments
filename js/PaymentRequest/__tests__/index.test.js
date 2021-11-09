const {
  mockReactNativeIOS,
  mockNativePaymentsSupportedIOS,
  mockNativePaymentsUnsupportedIOS
} = require('../__mocks__');

jest.mock('react-native', () => mockReactNativeIOS);
jest.mock('../../NativeBridge', () => mockNativePaymentsSupportedIOS);
const PaymentRequest = require('../').default;

// helpers
export function createCreatedPaymentRequest(methodData, details, options) {
  const paymentRequest = new PaymentRequest(methodData, details, options);

  return paymentRequest;
}

export function createInteractivePaymentRequest(methodData, details, options) {
  const paymentRequest = new PaymentRequest(methodData, details, options);
  paymentRequest._state = 'interactive';

  return paymentRequest;
}

export function createInteractiveCreditPaymentRequest(methodData, details, options) {
  const paymentRequest = new PaymentRequest(methodData, details, options);
  paymentRequest._state = 'interactive';
  paymentRequest._paymentMethod = 'PKPaymentMethodTypeCredit';

  return paymentRequest;
}

export function createInteractiveDebitPaymentRequest(methodData, details, options) {
  const paymentRequest = new PaymentRequest(methodData, details, options);
  paymentRequest._state = 'interactive';
  paymentRequest._paymentMethod = 'PKPaymentMethodTypeDebit';

  return paymentRequest;
}

export function createClosedPaymentRequest(methodData, details, options) {
  const paymentRequest = new PaymentRequest(methodData, details, options);
  paymentRequest._state = 'closed';

  return paymentRequest;
}

export function createUpdatingPaymentRequest(methodData, details, options) {
  const paymentRequest = new PaymentRequest(methodData, details, options);
  paymentRequest._state = 'interactive';
  paymentRequest._updating = true;

  return paymentRequest;
}

// constants
const METHOD_DATA = [
  {
    supportedMethods: ['apple-pay'],
    data: {
      merchantId: '12345'
    }
  }
];
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
const DETAILS = {
  id,
  total,
  displayItems
};

export const APPLE_PAY_DETAILS =
    {
      default: {
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
      },
      credit: {
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
      },
      debit: {
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
      }
    };

describe('PaymentRequest', () => {
  describe('constructor', () => {});

  describe('attributes', () => {
    describe('id', () => {
      it('should have the same id as `details.id`', () => {
        const request = new PaymentRequest(METHOD_DATA, DETAILS);

        expect(request.id).toBe('foo');
      });

      it('should generate id when `details.id` is not provided', () => {
        const request = new PaymentRequest(METHOD_DATA, DETAILS);

        expect(request.id).toBeTruthy();
      });
    });

    describe('id', () => {
      it('should have the same id as `details.id`', () => {
        const request = new PaymentRequest(METHOD_DATA, APPLE_PAY_DETAILS);

        expect(request.id).toBe('default_details');
      });
    });

    describe('shippingAddress', () => {
      it('should have a `null` default shippingAddress', () => {
        const request = new PaymentRequest(METHOD_DATA, DETAILS);

        expect(request.shippingAddress).toBe(null);
      });
    });

    describe('shippingOption', () => {
      it('should have a `null` default shippingOption', () => {
        const request = new PaymentRequest(METHOD_DATA, DETAILS);

        expect(request.shippingOption).toBe(null);
      });

      it('should default to first `shippingOption.id`', () => {
        const shippingOptions = [
          {
            id: 'next-day',
            label: 'Next Day Delivery',
            amount: { currency: 'USD', value: '12.00' }
          }
        ];
        const detailsWithShippingOptions = Object.assign({}, DETAILS, {
          shippingOptions
        });

        const request = new PaymentRequest(
          METHOD_DATA,
          detailsWithShippingOptions
        );

        expect(request.shippingOption).toBe('next-day');
      });
    });
  });

  describe('methods', () => {
    describe('show', () => {
      it('should set `_state` to `interactive`', () => {});

      it('should set `_acceptPromise` to a `Promise`', () => {});

      it('should return a `PaymentResponse` with a `requestId`, `methodName`, and `details`', () => {});
    });

    describe('abort', () => {
      it('should reject `_state` is not equal to `interactive`', async () => {
        const createdPaymentRequest = createCreatedPaymentRequest(
          METHOD_DATA,
          DETAILS
        );

        let error = null;

        try {
          await createdPaymentRequest.abort();
        } catch(e) {
          error = e;
        }

        expect(error.message).toBe('InvalidStateError');
      });

      it('should resolve to `undefined`', async () => {
        const interactivePaymentRequest = createInteractivePaymentRequest(
          METHOD_DATA,
          DETAILS
        );

        const result = await interactivePaymentRequest.abort();

        expect(result).toBe(undefined);
      });

      it('should set `_state` to `closed`', async () => {
        const interactivePaymentRequest = createInteractivePaymentRequest(
          METHOD_DATA,
          DETAILS
        );

        await interactivePaymentRequest.abort();

        expect(interactivePaymentRequest._state).toBe('closed');
      });
    });

    describe('canMakePayments', () => {
      it('should return true when Payments is available', async () => {
        const request = new PaymentRequest(METHOD_DATA, DETAILS);

        const result = await request.canMakePayments();

        expect(result).toBe(true);
      });
    });
  });
});
