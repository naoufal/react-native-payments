import { Platform } from 'react-native';
import { getShippingOptions } from '../services/shipping';

// helpers
function addStringAmounts(...prices) {
  return prices
    .reduce((acc, stringAmount) => {
      return acc + parseFloat(stringAmount);
    }, 0)
    .toString();
}

function prDisplayHandler(paymentRequest) {

  return paymentRequest
    .show()
    .then(paymentResponse => {
      if (Platform.OS === 'android') {
        // Fetch PaymentToken
        paymentResponse.details.getPaymentToken().then(console.log);
      }

      paymentResponse.complete('success');
    })
    .catch(console.warn);
}

function initPR(methodData, details, options = {}) {
  return new PaymentRequest(methodData, details, options);
}

function addDisplayItems(displayItems) {
  return displayItems.reduce((acc, displayItem) => {
    return acc + parseFloat(displayItem.amount.value);
  }, 0);
}

function getTaxFromSubTotal(subTotal, tax = 0.15) {
  return subTotal * tax;
}

function getPlatformTotalLabel(platformOS) {
  return platformOS === 'ios' ? 'Merchant' : 'Total';
}

const METHOD_DATA = [
  {
    supportedMethods: ['basic-card'],
    data: {
      supportedNetworks: ['visa', 'mastercard', 'amex']
    }
  },
  {
    supportedMethods: ['apple-pay'],
    data: {
      merchantIdentifier: 'merchant.com.react-native-payments.naoufal',
      supportedNetworks: ['visa', 'mastercard', 'amex'],
      countryCode: 'US',
      currencyCode: 'USD'
    }
  },
  {
    supportedMethods: ['android-pay'],
    data: {
      supportedNetworks: ['visa', 'mastercard', 'amex'],
      countryCode: 'US',
      currencyCode: 'USD',
      environment: 'TEST',
      paymentMethodTokenizationParameters: {
        tokenizationType: 'NETWORK_TOKEN',
        parameters: {
          publicKey: 'BOdoXP+9Aq473SnGwg3JU1aiNpsd9vH2ognq4PtDtlLGa3Kj8TPf+jaQNPyDSkh3JUhiS0KyrrlWhAgNZKHYF2Y='
        }
      }
    }
  }
];

const DISPLAY_ITEMS = [
  {
    label: 'Movie Ticket',
    amount: { currency: 'USD', value: '15.00' }
  }
];
const TOTAL = {
  label: getPlatformTotalLabel(Platform.OS),
  amount: { currency: 'USD', value: '15.00' }
};

export function oneItem() {
  const details = {
    id: 'oneItem',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    }
  };
  const paymentRequest = initPR(METHOD_DATA, details);

  return prDisplayHandler(paymentRequest);
}

export function twoItems() {
  const displayItems = [
    {
      label: 'Movie Ticket',
      amount: { currency: 'USD', value: 15.0 }
    },
    {
      label: 'Popcorn',
      amount: { currency: 'USD', value: 10.0 }
    }
  ];
  const details = {
    id: 'twoItems',
    displayItems,
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: addDisplayItems(displayItems) }
    }
  };
  const paymentRequest = initPR(METHOD_DATA, details);

  return prDisplayHandler(paymentRequest);
}

export function twoItemsPlusTax() {
  const displayItems = [
    {
      label: 'Movie Ticket',
      amount: { currency: 'USD', value: 15.0 }
    },
    {
      label: 'Popcorn',
      amount: { currency: 'USD', value: 10.0 }
    }
  ];
  const subtotal = addDisplayItems(displayItems);
  const tax = getTaxFromSubTotal(subtotal);

  const details = {
    id: 'twoItemsPlusTax',
    displayItems: [
      ...displayItems,
      {
        label: 'Tax',
        amount: { currency: 'USD', value: tax }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: subtotal + tax }
    }
  };
  const paymentRequest = initPR(METHOD_DATA, details);

  return prDisplayHandler(paymentRequest);
}

export function requestPayerName() {
  const details = {
    id: 'requestPayerName',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    }
  };
  const options = { requestPayerName: true };
  const paymentRequest = initPR(METHOD_DATA, details, options);

  return prDisplayHandler(paymentRequest);
}

export function requestPayerPhone() {
  const details = {
    id: 'requestPayerPhone',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    }
  };
  const options = { requestPayerPhone: true };
  const paymentRequest = initPR(METHOD_DATA, details, options);

  return prDisplayHandler(paymentRequest);
}

export function requestPayerEmail() {
  const details = {
    id: 'requestPayerEmail',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    }
  };
  const options = { requestPayerEmail: true };
  const paymentRequest = initPR(METHOD_DATA, details, options);

  return prDisplayHandler(paymentRequest);
}

export function requestPayerAll() {
  const details = {
    id: 'requestPayerAll',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    }
  };
  const options = {
    requestPayerName: true,
    requestPayerPhone: true,
    requestPayerEmail: true
  };
  const paymentRequest = initPR(METHOD_DATA, details, options);

  return prDisplayHandler(paymentRequest);
}

export function staticShipping() {
  let details = {
    id: 'staticShipping',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      },
      {
        label: 'Shipping',
        amount: { currency: 'USD', value: '0.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    },
    shippingOptions: [
      {
        id: 'economy',
        label: 'Economy Shipping',
        amount: { currency: 'USD', value: '0.00' },
        detail: 'Arrives in 3-5 days'
      },
      {
        id: 'express',
        label: 'Express Shipping',
        amount: { currency: 'USD', value: '5.00' },
        detail: 'Arrives tomorrow'
      }
    ]
  };
  const options = { requestShipping: true };

  const paymentRequest = new PaymentRequest(METHOD_DATA, details, options);
  paymentRequest.addEventListener('shippingaddresschange', e => {
    e.updateWith(details);
  });

  paymentRequest.addEventListener('shippingoptionchange', e => {
    // Set selected `shippingOption`
    details.shippingOptions = details.shippingOptions.map(shippingOption =>
      Object.assign({}, shippingOption, {
        selected: shippingOption.id === paymentRequest.shippingOption
      })
    );

    const selectedShippingOption = details.shippingOptions.find(
      shippingOption => shippingOption.selected === true
    );

    // Update shipping price in displayItems
    details.displayItems = details.displayItems.map(displayItem => {
      if (displayItem.label === 'Shipping') {
        return Object.assign({}, displayItem, {
          amount: {
            currency: 'USD',
            value: selectedShippingOption
              ? selectedShippingOption.amount.value
              : '0.00'
          }
        });
      }

      return displayItem;
    });

    // Update total
    details.total = Object.assign({}, details.total, {
      amount: {
        currency: details.total.amount.currency,
        value: addDisplayItems(details.displayItems)
      }
    });

    e.updateWith(details);
  });

  return prDisplayHandler(paymentRequest);
}

function getShippingOptionsForState(state) {
  const isCalifornia = state === 'CA';

  return [
    {
      id: 'economy',
      label: 'Economy Shipping',
      amount: { currency: 'USD', value: isCalifornia ? '0.00' : '3.00' },
      detail: 'Arrives in 3-5 days'
    },
    {
      id: 'express',
      label: 'Express Shipping',
      amount: { currency: 'USD', value: isCalifornia ? '5.00' : '10.00' },
      detail: 'Arrives tomorrow'
    }
  ];
}

export function dynamicShipping() {
  let details = {
    id: 'dynamicShipping',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      },
      {
        label: 'Shipping',
        amount: { currency: 'USD', value: '0.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    },
    shippingOptions: getShippingOptionsForState()
  };
  const options = { requestShipping: true };

  const paymentRequest = new PaymentRequest(METHOD_DATA, details, options);
  paymentRequest.addEventListener('shippingaddresschange', e => {
    console.log(paymentRequest.shippingAddress);
    const updateDetailsWithPromise = new Promise((resolve, reject) => {
      updateDetailsWithMutation(
        paymentRequest,
        details,
        getShippingOptionsForState(paymentRequest.shippingAddress.region)
      );

      // Simulating a 2 second update
      setTimeout(() => {
        return resolve(details);
      }, 2000);
    });

    e.updateWith(updateDetailsWithPromise);
  });

  paymentRequest.addEventListener('shippingoptionchange', e => {
    updateDetailsWithMutation(
      paymentRequest,
      details,
      getShippingOptionsForState(paymentRequest.shippingAddress.region)
    );

    e.updateWith(details);
  });

  return prDisplayHandler(paymentRequest);
}

function updateDetailsWithMutation(
  paymentRequest,
  details,
  nextShippingOptions
) {
  // Update `shippingOptions` prices for selected state
  details.shippingOptions = nextShippingOptions;

  // Set selected `shippingOption`
  details.shippingOptions = details.shippingOptions.map(shippingOption =>
    Object.assign({}, shippingOption, {
      selected: shippingOption.id === paymentRequest.shippingOption
    })
  );

  const selectedShippingOption = details.shippingOptions.find(
    shippingOption => shippingOption.selected === true
  );

  // Update shipping price in displayItems
  details.displayItems = details.displayItems.map(displayItem => {
    if (displayItem.label === 'Shipping') {
      return Object.assign({}, displayItem, {
        amount: {
          currency: 'USD',
          value: selectedShippingOption
            ? selectedShippingOption.amount.value
            : '0.00'
        }
      });
    }

    return displayItem;
  });

  // Update total
  details.total = Object.assign({}, details.total, {
    amount: {
      currency: details.total.amount.currency,
      value: addDisplayItems(details.displayItems)
    }
  });

  return details;
}

function getShippingOptionsForCountry(countryCode) {
  if (countryCode !== 'US') {
    return [];
  }

  return [
    {
      id: 'economy',
      label: 'Economy Shipping',
      amount: { currency: 'USD', value: '0.00' },
      detail: 'Arrives in 3-5 days'
    },
    {
      id: 'express',
      label: 'Express Shipping',
      amount: { currency: 'USD', value: '5.00' },
      detail: 'Arrives tomorrow.'
    }
  ];
}
export function noInternationalShipping() {
  let details = {
    id: 'noInternationalShipping',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      },
      {
        label: 'Shipping',
        amount: { currency: 'USD', value: '0.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    },
    shippingOptions: getShippingOptionsForCountry()
  };
  const options = { requestShipping: true };

  const paymentRequest = new PaymentRequest(METHOD_DATA, details, options);

  paymentRequest.addEventListener('shippingaddresschange', e => {
    const updateDetailsWithPromise = new Promise((resolve, reject) => {
      updateDetailsWithMutation(
        paymentRequest,
        details,
        getShippingOptionsForCountry(paymentRequest.shippingAddress.country)
      );

      // Simulating a 2 second update
      setTimeout(() => {
        return resolve(details);
      }, 2000);
    });

    e.updateWith(updateDetailsWithPromise);
  });
  paymentRequest.addEventListener('shippingoptionchange', e => {
    updateDetailsWithMutation(
      paymentRequest,
      details,
      getShippingOptionsForCountry(paymentRequest.shippingAddress.country)
    );

    e.updateWith(details);
  });

  return prDisplayHandler(paymentRequest);
}

// Error Examples
export function errorNoTotal() {
  let details = {
    id: 'errorNoTotal',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      }
    ],
    total: null
  };
  const paymentRequest = new PaymentRequest(METHOD_DATA, details);

  return prDisplayHandler(paymentRequest);
}

export function errorNegativeTotal() {
  let details = {
    id: 'errorNegativeTotal',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '-15.00' }
    }
  };
  const paymentRequest = new PaymentRequest(METHOD_DATA, details);

  return prDisplayHandler(paymentRequest);
}

export function errorInvalidTotalAmount() {
  let details = {
    id: 'errorNoShippingOptions',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '10.' }
    }
  };
  const paymentRequest = new PaymentRequest(METHOD_DATA, details);

  return prDisplayHandler(paymentRequest);
}

export function errorInvalidDisplayItemAmount() {
  let details = {
    id: 'errorNoShippingOptions',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '10.' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '10.00' }
    }
  };
  const paymentRequest = new PaymentRequest(METHOD_DATA, details);

  return prDisplayHandler(paymentRequest);
}

export function errorNoShippingOptions() {
  let details = {
    id: 'errorNoShippingOptions',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      },
      {
        label: 'Shipping',
        amount: { currency: 'USD', value: '0.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    }
  };
  const options = { requestShipping: true };

  const paymentRequest = new PaymentRequest(METHOD_DATA, details, options);
  paymentRequest.addEventListener('shippingaddresschange', e =>
    e.updateWith(details)
  );

  paymentRequest.addEventListener('shippingoptionchange', e =>
    e.updateWith(details)
  );

  return prDisplayHandler(paymentRequest);
}

export function errorInvalidShippingOptionsAmount() {
  let details = {
    id: 'errorInvalidShippingOptionsAmount',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      },
      {
        label: 'Shipping',
        amount: { currency: 'USD', value: '0.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    },
    shippingOptions: [
      {
        id: 'next-day',
        label: 'Next Day',
        amount: { currency: 'USD', value: '10.' },
        detail: 'Arrives tomorrow.'
      }
    ]
  };
  const options = { requestShipping: true };

  const paymentRequest = new PaymentRequest(METHOD_DATA, details, options);
  paymentRequest.addEventListener('shippingaddresschange', e =>
    e.updateWith(details)
  );

  paymentRequest.addEventListener('shippingoptionchange', e =>
    e.updateWith(details)
  );

  return prDisplayHandler(paymentRequest);
}

export function errorDuplicateShippingOptionsId() {
  let details = {
    id: 'errorDuplicateShippingOptionsId',
    displayItems: [
      {
        label: 'Movie Ticket',
        amount: { currency: 'USD', value: '15.00' }
      },
      {
        label: 'Shipping',
        amount: { currency: 'USD', value: '0.00' }
      }
    ],
    total: {
      label: getPlatformTotalLabel(Platform.OS),
      amount: { currency: 'USD', value: '15.00' }
    },
    shippingOptions: [
      { id: null, label: 'foo', amount: { currency: 'USD', value: '0.00' } },
      { id: null, label: 'bar', amount: { currency: 'USD', value: '1.00' } }
    ]
  };
  const options = { requestShipping: true };

  const paymentRequest = new PaymentRequest(METHOD_DATA, details, options);
  paymentRequest.addEventListener('shippingaddresschange', e =>
    e.updateWith(details)
  );

  paymentRequest.addEventListener('shippingoptionchange', e =>
    e.updateWith(details)
  );

  return prDisplayHandler(paymentRequest);
}

export function errorGatewayNotSupported() {
  const methodData = [
    {
      supportedMethods: ['apple-pay'],
      data: {
        merchantIdentifier: 'merchant.com.react-native-payments.naoufal',
        supportedNetworks: ['visa', 'mastercard', 'amex'],
        countryCode: 'US',
        currencyCode: 'USD',
        paymentMethodTokenizationParameters: {
          parameters: {
            gateway: 'stripe',
            'stripe:stripe:publishableKey': 'pk_test_foo'
          }
        }
      }
    }
  ];

  const details = {
    displayItems: DISPLAY_ITEMS,
    total: TOTAL
  };

  const paymentRequest = new PaymentRequest(methodData, details);

  return prDisplayHandler(paymentRequest);
}
