'use strict';

jest.mock('react-native');
jest.mock('../NativePayments');

import PaymentRequest from '../PaymentRequest';

describe('PaymentRequest', () => {
    const METHOD_DATA = [{
        supportedMethods: ['apple-pay'],
        data: {
            merchantId: '12345'
        }
    }];
    const DETAILS = {
        id: 'foo',
        total: {
            label: 'Total',
            amount: { currency: 'USD', amount: '9.99' },
        }
    };

    describe('constructor', () => {
        it('should have the same id as details.id', () => {
            const request = new PaymentRequest(METHOD_DATA, DETAILS);

            expect(request.id).toBe('foo');
        });

        it('should have a null default shippingAddress', () => {
            const request = new PaymentRequest(METHOD_DATA, DETAILS);

            expect(request.shippingAddress).toBe(null);
        });

        it('should have a null default shippingOption', () => {
            const request = new PaymentRequest(METHOD_DATA, DETAILS);

            expect(request.shippingOption).toBe(null);
        });
    });

    describe('show', () => {
        it('should return a PaymentResponse with a requestId, methodName, and details', (done) => {
            const request = new PaymentRequest(METHOD_DATA, DETAILS);

            request.show()
                .then(paymentResponse => {
                    expect(paymentResponse).toHaveProperty('requestId');
                    expect(paymentResponse).toHaveProperty('methodName');
                    expect(paymentResponse).toHaveProperty('details');

                    done();
                });
        });
    });

    describe('canMakePayments', () => {
        it('should return true when Payments is available', () => {
            const request = new PaymentRequest(METHOD_DATA, DETAILS);

            return expect(request.canMakePayments()).resolves.toBe(true);
        });

    it('should return false when Payments is available', (done) => {
            const request = new PaymentRequest(METHOD_DATA, DETAILS);

            return expect(request.canMakePayments()).resolves.toBe(false);
        });
    });
});