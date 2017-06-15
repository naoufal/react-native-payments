import ReactNativePayments from 'react-native-payments';
import { getShippingOptions } from '../services/shipping';

const METHOD_DATA = [{
    supportedMethods: ['apple-pay'],
    data: {
        merchantIdentifier: 'merchant.com.react-native-payments.naoufal',
        supportedNetworks: ['visa', 'mastercard'],
        countryCode: 'US',
        currencyCode: 'USD'
    }
}];
const DISPLAY_ITEMS = [{
    label: 'BoJack Sweater',
    amount: { currency: 'USD', value: '99.99' }
}];
const TOTAL = {
    label: 'Netflix',
    amount: { currency: 'USD', value: '99.99' }
};

function addStringAmounts(...prices) {
    return prices.reduce((acc, stringAmount) => {
        return acc + parseFloat(stringAmount);
    }, 0).toString();
}

function prDisplayHandler(paymentRequest) {
    return paymentRequest.show()
      .then(paymentResponse => paymentResponse.complete('success'))
      .catch(e => paymentRequest.abort());
}

function initPR(methodData, details, options = {}) {
    return new ReactNativePayments.PaymentRequest(methodData, details, options);
};

export function displayItemAndTotal() {
    const details = {
        id: 'displayItemAndTotal',
        displayItems: DISPLAY_ITEMS,
        total: TOTAL
    };
    const paymentRequest = initPR(METHOD_DATA, details);

    return prDisplayHandler(paymentRequest);
}

export function requestPayerName() {
    const details = {
        id: 'requestPayerName',
        displayItems: DISPLAY_ITEMS,
        total: TOTAL
    };
    const options = { requestPayerName: true };
    const paymentRequest = initPR(METHOD_DATA, details, options);

    return prDisplayHandler(paymentRequest);
}

export function requestPayerPhone() {
    const details = {
        id: 'requestPayerPhone',
        displayItems: DISPLAY_ITEMS,
        total: TOTAL
    };
    const options = { requestPayerPhone: true };
    const paymentRequest = initPR(METHOD_DATA, details, options);

    return prDisplayHandler(paymentRequest);
}

export function requestPayerEmail() {
    const details = {
        id: 'requestPayerEmail',
        displayItems: DISPLAY_ITEMS,
        total: TOTAL
    };
    const options = { requestPayerEmail: true };
    const paymentRequest = initPR(METHOD_DATA, details, options);

    return prDisplayHandler(paymentRequest);
}

export function requestPayerAll() {
    const details = {
        id: 'requestPayerAll',
        displayItems: DISPLAY_ITEMS,
        total: TOTAL
    };
    const options = {
        requestPayerName: true,
        requestPayerPhone: true,
        requestPayerEmail: true
    };
    const paymentRequest = initPR(METHOD_DATA, details, options);

    return prDisplayHandler(paymentRequest);
}

export function requestShippingDetails() {
    const details = {
        id: 'requestShippingDetails',
        displayItems: DISPLAY_ITEMS,
        total: TOTAL
    };
    const options = { requestShipping: true };
    const paymentRequest = initPR(METHOD_DATA, details, options);

    return prDisplayHandler(paymentRequest);
}

export function handleShippingChanges() {
    const shippingOptions = getShippingOptions();
    const displayItems = [...DISPLAY_ITEMS, {
        label: 'Shipping',
        amount: shippingOptions[0].amount
    }];
    const details = {
        id: 'handleShippingAddressChange',
        shippingOptions,
        displayItems,
        total: TOTAL
    };
    const options = { requestShipping: true };

    const paymentRequest = new ReactNativePayments.PaymentRequest(METHOD_DATA, details, options);
    paymentRequest.addEventListener('shippingaddresschange', e => {
        console.log(paymentRequest.shippingAddress);

        // Typically `getShippingOptions` would be calculated
        // based on the `shippingAddress`.
        const newShippingOptions = getShippingOptions();

        e.updateWith({
            total: TOTAL,
            shippingOptions: newShippingOptions
        });
    });

    paymentRequest.addEventListener('shippingoptionchange', e => {
        const nextShippingOptions = shippingOptions.map(shippingOption => {
            return Object.assign({}, shippingOption, {
                selected: shippingOption.id === paymentRequest.shippingOption
            });
        });
        const selectedShippingOption = nextShippingOptions.find(shippingOption => shippingOption.selected);
        const nextDisplayItems = displayItems.map(displayItem => {
            return (displayItem.label !== 'Shipping')
                ? displayItem
                : Object.assign({}, displayItem, {
                    amount: selectedShippingOption.amount
                });
        });

        e.updateWith({
            displayItems: nextDisplayItems,
            shippingOptions: nextShippingOptions,
            total: {
                label: 'Netflix',
                amount: {
                    currency: 'USD',
                    value: addStringAmounts(
                        selectedShippingOption.amount.value,
                        details.total.amount.value
                    )
                }
            }
        });
    });

    return prDisplayHandler(paymentRequest);
}