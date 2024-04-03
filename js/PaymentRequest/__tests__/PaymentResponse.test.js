const { mockNativePaymentsSupportedIOS } = require('../__mocks__');

jest.mock('react-native', () => mockReactNativeIOS);
jest.mock('../../NativeBridge', () => mockNativePaymentsSupportedIOS);
const PaymentResponse = require('../PaymentResponse').default;

// helpers
function createCompletedPaymentResponse(paymentResponseData) {
  const paymentResponse = new PaymentResponse(paymentResponseData);
  paymentResponse._completeCalled = true;

  return paymentResponse;
}

// constants
const paymentResponseData = {
  requestId: 'bar',
  methodName: 'apple-pay',
  details: {},
  shippingAddress: null,
  shippingOption: 'next-day',
  payerName: 'Drake',
  payerPhone: '555-555-5555',
  payerEmail: 'drizzy@octobersveryown.com'
};

describe('PaymentResponse', () => {
  describe('attributes', () => {
    const paymentRequest = new PaymentResponse(paymentResponseData);

    describe('requestId', () => {
      it('should return `requestId`', () => {
        expect(paymentRequest.requestId).toBe(paymentResponseData.requestId);
      });

      // it('should throw if user attempts to assign value', () => {
      //   expect(() => {
      //     paymentRequest.requestId = 'foo';
      //   }).toThrow();
      // });
    });

    describe('methodName', () => {
      it('should return `methodName`', () => {
        expect(paymentRequest.methodName).toBe(paymentResponseData.methodName);
      });

      // it('should throw if user attempts to assign value', () => {
      //   expect(() => {
      //     paymentRequest.methodName = 'foo';
      //   }).toThrow();
      // });
    });

    describe('details', () => {
      it('should return `details`', () => {
        expect(paymentRequest.details).toEqual(paymentResponseData.details);
      });

      // it('should throw if user attempts to assign value', () => {
      //   expect(() => {
      //     paymentRequest.details = 'foo';
      //   }).toThrow();
      // });
    });

    describe('shippingAddress', () => {
      it('should return `shippingAddress`', () => {
        expect(paymentRequest.shippingAddress).toBe(
          paymentResponseData.shippingAddress
        );
      });

      // it('should throw if user attempts to assign value', () => {
      //   expect(() => {
      //     paymentRequest.shippingAddress = 'foo';
      //   }).toThrow();
      // });
    });

    describe('shippingOption', () => {
      it('should return `shippingOption`', () => {
        expect(paymentRequest.shippingOption).toBe(
          paymentResponseData.shippingOption
        );
      });

      // it('should throw if user attempts to assign value', () => {
      //   expect(() => {
      //     paymentRequest.shippingOption = 'foo';
      //   }).toThrow();
      // });
    });

    describe('payerName', () => {
      it('should return `payerName`', () => {
        expect(paymentRequest.payerName).toBe(paymentResponseData.payerName);
      });

      // it('should throw if user attempts to assign value', () => {
      //   expect(() => {
      //     paymentRequest.payerName = 'foo';
      //   }).toThrow();
      // });
    });

    describe('payerPhone', () => {
      it('should return `payerPhone`', () => {
        expect(paymentRequest.payerPhone).toBe(paymentResponseData.payerPhone);
      });

      // it('should throw if user attempts to assign value', () => {
      //   expect(() => {
      //     paymentRequest.payerPhone = 'foo';
      //   }).toThrow();
      // });
    });

    describe('payerEmail', () => {
      it('should return `payerEmail`', () => {
        expect(paymentRequest.payerEmail).toBe(paymentResponseData.payerEmail);
      });

      // it('should throw if user attempts to assign value', () => {
      //   expect(() => {
      //     paymentRequest.payerEmail = 'foo';
      //   }).toThrow();
      // });
    });
  });

  describe('methods', () => {
    describe('complete', () => {
      it('should throw if `_completeCalled` is already true', () => {
        const completedPaymentResponse = createCompletedPaymentResponse(
          paymentResponseData
        );

        expect(() => {
          completedPaymentResponse.complete();
        }).toThrow(new Error('InvalidStateError'));
      });

      it('should toggle `_completeCalled` to true', done => {
        const paymentResponse = new PaymentResponse(paymentResponseData);

        paymentResponse.complete().then(() => {
          expect(paymentResponse._completeCalled).toBe(true);
          done();
        });
      });

      it('should resolve to `undefined`', () => {
        const paymentResponse = new PaymentResponse(paymentResponseData);

        expect(paymentResponse.complete()).resolves.toBe(undefined);
      });
    });
  });
});
