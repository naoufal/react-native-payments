# react-native-apple-pay

[![npm version](https://img.shields.io/npm/v/react-native-apple-pay.svg?style=flat-square)](https://www.npmjs.com/package/react-native-apple-pay)
[![npm downloads](https://img.shields.io/npm/dm/react-native-apple-pay.svg?style=flat-square)](https://www.npmjs.com/package/react-native-apple-pay)
[![Code Climate](https://img.shields.io/codeclimate/github/naoufal/react-native-apple-pay.svg?style=flat-square)](https://codeclimate.com/github/naoufal/react-native-apple-pay)

__`react-native-apple-pay`__ is a React Native library for accepting payments with Apple Pay.

__Note: This library is still in progress.__

![react-native-apple-pay](https://cloud.githubusercontent.com/assets/1627824/8768439/d18959e2-2e4e-11e5-8103-d08230128fcd.gif)

## Documentation
- [Install](https://github.com/naoufal/react-native-apple-pay#install)
- [Supported Payment Processors](https://github.com/naoufal/react-native-apple-pay#supported-payment-processors)
- [Methods](https://github.com/naoufal/react-native-apple-pay#methods)
- [License](https://github.com/naoufal/react-native-apple-pay#license)

## Install
```shell
npm i --save react-native-apple-pay
```

## Supported Payment Processors
- [ ] Adyen
- [ ] Authorize.Net
- [ ] Bank of America Merchant Services
- [ ] Braintree
- [ ] Chase Paymentech
- [ ] CyberSource
- [ ] DataCash
- [ ] First Data
- [ ] Global Payments
- [ ] Judo Payments
- [ ] Simplify
- [x] Stripe
- [ ] TSYS
- [ ] Vantiv
- [ ] Worldpay

## Methods

### canMakePayments()
Checks if Apple Pay is available.

__Example__
```js

ApplePay.canMakePayments()
  .then(() => {
    // Success code
  })
  .catch(err => {
    // Failure code
  });
```

---

### canMakePaymentsWithNetworks(supportedNetworks)
Checks if the user's card is supported by the merchant.

__Arguments__
- [`supportedNetworks`](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/#//apple_ref/doc/constant_group/Payment_Networks) - An `Array` of `Strings` representing the payment processing protocols you support.

__Example__
```js
var merchantOptions = {
  paymentProcessor: 'stripe',
  merchantIdentifier: 'merchant.yourapp.you',
  supportedNetworks: ['PKPaymentNetworkMasterCard', 'PKPaymentNetworkVisa'],
  merchantCapabilities: ['PKMerchantCapability3DS', 'PKMerchantCapabilityEMV'],
  countryCode: 'US',
  currencyCode: 'USD'
};

ApplePay.canMakePaymentsWithNetworks(merchantOptions.supportedNetworks)
  .then(() => {
    // Success code
  })
  .catch(err => {
    // Failure code
  });
```

---

### paymentRequest(merchantOptions, paymentItems)
Initializes Apple Pay.

__Arguments__
- `merchantOptions` - An `Object` that will be served to setup the payment request.
- `summaryItems` - An `Array` containing the items the customer will be purchasing.

__merchantOptions__
- `paymentProcessor` - A `String` representing your payment processor.
- `paymentProcessorPublicKey` - A `String` representing your public key.
- [`merchantIdentifier`](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/#//apple_ref/occ/instp/PKPaymentRequest/merchantIdentifier) - A `String` representing your merchant identifier.
- [`supportedNetworks`](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/#//apple_ref/doc/constant_group/Payment_Networks) - An `Array` of `Strings` representing the payment processing protocols you support.
- [`merchantCapabilities`](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/#//apple_ref/c/tdef/PKMerchantCapability) -An `Array` of `Strings` representing the payment networks that you support.
- [`countryCode`](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/#//apple_ref/occ/instp/PKPaymentRequest/countryCode) - A `String` representing the two-letter `ISO 3166` country code for the country where the payment will be processed.
- [`currencyCode`](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/#//apple_ref/occ/instp/PKPaymentRequest/currencyCode) - A `String` representing the three-letter `ISO 4217` currency code of the currency you will use to charge the customer.

__summaryItem__
- `label` - A `String` representing the summary name.
- `amount` - A `Number` with two decimal places representing the summary price.

__Example__
```js
var merchantOptions = {
  paymentProcessor: 'stripe',
  merchantIdentifier: 'merchant.yourapp.you',
  supportedNetworks: ['PKPaymentNetworkMasterCard', 'PKPaymentNetworkVisa'],
  merchantCapabilities: ['PKMerchantCapability3DS', 'PKMerchantCapabilityEMV'],
  countryCode: 'US',
  currencyCode: 'USD'
};

var summaryItems = [
  {
    label: 'Hockey Stick',
    amount: 88.88
  }
];

ApplePay.paymentRequest(merchantOptions, summaryItems)
  .then(chargeTokenOnServer)
  .then(ApplePay.success)
  .catch(error => {
    // Log error
    ApplePay.failure();
  });

function chargeTokenOnServer(token) {...}
```

---

### success()
Displays a success animation to the user and dismisses the Apple Pay view.

__Example__
```js
ApplePay.success()
  .then(() => {
    this.props.navigator.push(successRoute);
  });
```

---

### failure()
Displays a failure animation to the user and dismisses the Apple Pay view.

__Example__
```js
ApplePay.failure()
  .then(() => {
    AlertIOS.alert('Payment Failed');
  });
```

---

### getTotal(summaryItems)
Returns the total charge of the summary items.

__Example__
```js
var summaryItems = [
  {
    label: 'Adult Batman Costume',
    amount: 79.99
  },
  {
    label: 'Child Batman Costume',
    amount: 59.99
  },
  {
    label: 'Discount',
    amount: -40
  },
];

ApplePay.getTotal(summaryItems) // 99.98
```

## License
Copyright (c) 2015, Naoufal Kadhom

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
