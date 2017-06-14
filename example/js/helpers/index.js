import ReactNativePayments from 'react-native-payments';

const METHOD_DATA = [{
    supportedMethods: ['apple-pay'],
    data: {
        merchantIdentifier: 'merchant.com.react-native-payments.naoufal',
        supportedNetworks: ['visa', 'mastercard'],
        countryCode: 'US',
        currencyCode: 'USD'
    }
}];

export const basicPR = () => {
    const details = {
        id: 'native-payments-basic-example',
        displayItems: [{
            label: 'Ultimate Warrior Shirt',
            amount: { currency: 'USD', value: '32.00' }
        }],
        total: {
            label: 'Naoufal Kadhom',
            amount: { currency: 'USD', value: '32.00' }
        }
    };

    const paymentRequest = new ReactNativePayments.PaymentRequest(METHOD_DATA, details);
    return paymentRequest.show()
      .then(paymentResponse => paymentResponse.complete('success'))
      .catch(e => paymentRequest.abort());
};

const prWithOptions = (options) => {
    const details = {
        id: 'native-payments-basic-example',
        displayItems: [{
            label: 'Ultimate Warrior Shirt',
            amount: { currency: 'USD', value: '32.00' }
        }],
        total: {
            label: 'Naoufal Kadhom',
            amount: { currency: 'USD', value: '32.00' }
        }
    };

    const paymentRequest = new ReactNativePayments.PaymentRequest(METHOD_DATA, details, options);
    return paymentRequest.show()
      .then(paymentResponse => paymentResponse.complete('success'))
      .catch(e => paymentRequest.abort());
};

export const requestPayerName = prWithOptions.bind(null, {
    requestPayerName: true
});

export const requestPayerPhone = prWithOptions.bind(null, {
    requestPayerPhone: true
});

export const requestPayerEmail = prWithOptions.bind(null, {
    requestPayerEmail: true
});

export const requestPayerAll = prWithOptions.bind(null, {
    requestPayerName: true,
    requestPayerPhone: true,
    requestPayerEmail: true
});

export const requestShippingDetails = prWithOptions.bind(null, {
    requestShipping: true
});