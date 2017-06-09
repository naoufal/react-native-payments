const {
    mockReactNativeIOS,
    mockNativePaymentsSupportedIOS,
    mockNativePaymentsUnsupportedIOS
} = require('../__mocks__');

// constants
const METHOD_DATA = [{
    supportedMethods: ['apple-pay'],
    data: {
        merchantId: '12345'
    }
}];
const id = 'foo';
const total = {
    label: 'Total',
    amount: { currency: 'USD', value: '20.00' }
};
const displayItems = [{
    label: 'Subtotal',
    amount: { currency: 'USD', value: '20.00' }
}];
const DETAILS = {
    id,
    total,
    displayItems
};

describe('PaymentRequest', () => {
    let PaymentRequest;

    beforeAll(() => {
        jest.mock('react-native', () => mockReactNativeIOS);
        jest.mock('../NativePayments', () => mockNativePaymentsSupportedIOS);
        PaymentRequest = require('../PaymentRequest').default;
    });

    describe('constructor', () => {

    });

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

        describe('shippingAddress', () => {
            it('should have a null default shippingAddress', () => {
                const request = new PaymentRequest(METHOD_DATA, DETAILS);

                expect(request.shippingAddress).toBe(null);
            });
        });

        describe('shippingOption', () => {
            it('should have a null default shippingOption', () => {
                const request = new PaymentRequest(METHOD_DATA, DETAILS);

                expect(request.shippingOption).toBe(null);
            });

            it('should default to first `shippingOption.id`', () => {
                const shippingOptions = [{
                    id: 'next-day',
                    label: 'Next Day Delivery',
                    amount: { currency: 'USD', value: '12.00' },
                }];
                const detailsWithShippingOptions = Object.assign({}, DETAILS, {
                    shippingOptions
                });

                const request = new PaymentRequest(METHOD_DATA, detailsWithShippingOptions);

                expect(request.shippingOption).toBe('next-day');
            });
        });
    });

    describe('methods', () => {
        describe('show', () => {
        //     it('should return a PaymentResponse with a requestId, methodName, and details', (done) => {
        //         const request = new PaymentRequest(METHOD_DATA, DETAILS);

        //         request.show()
        //             .then(paymentResponse => {
        //                 expect(paymentResponse).toHaveProperty('requestId');
        //                 expect(paymentResponse).toHaveProperty('methodName');
        //                 expect(paymentResponse).toHaveProperty('details');

        //                 done();
        //             });
        //     });
        });

        describe('abort', () => {
            it('should fail to abort if no sheet is shown', () => {
                const request = new PaymentRequest(METHOD_DATA, DETAILS);

                // TODO:
                // - use proper error types
                return expect(request.abort()).rejects.toBeInstanceOf(Error);
            });

            // it('should abort successfully', () => {
            //     const request = new PaymentRequest(METHOD_DATA, DETAILS);

            //     expect(false).toBe(true);
            // });
        });

        describe('canMakePayments', () => {
            it('should return true when Payments is available', () => {
                const request = new PaymentRequest(METHOD_DATA, DETAILS);

                return expect(request.canMakePayments()).resolves.toBe(true);
            });
        });
    });
});