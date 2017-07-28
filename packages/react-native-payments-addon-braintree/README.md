# react-native-payments-addon-braintree
<a href="https://github.com/naoufal/react-native-payments">React Native Payments</a> add-on for processing payments with Braintree.

## Installation
First, download the package:

```bash
$ yarn add react-native-payments-addon-braintree
```

Second, install the [React Native Payments CLI](https://www.npmjs.com/package/react-native-payments-cli):
```bash
$ yarn add react-native-payments-cli
```

Lastly, link the native dependencies with the React Native Payments CLI:
```bash
$ yarn react-native-payments-cli -- link braintree
```

_NOTE: `react-native-payments-cli` adds a Build Phase Script to your Xcode project that depends on <a href="https://github.com/Carthage/Carthage">Carthage</a>._

## Usage
In order to receive chargeable Braintree tokens as part of your `PaymentResponse`, you'll need to add some Braintree specific parameters to your `PaymentMethodData`.

Here's an example of a Braintree enabled Payment Method Data:

```diff
const METHOD_DATA = [{
  supportedMethods: ['apple-pay'],
  data: {
    merchantIdentifier: 'merchant.com.your-app.namespace',
    supportedNetworks: ['visa', 'mastercard', 'amex'],
    countryCode: 'US',
    currencyCode: 'USD',
+   paymentMethodTokenizationParameters: {
+     parameters: {
+       gateway: 'braintree',
+       'braintree:tokenizationKey': 'your_tokenization_key'
+     }
+   }
  }
}];
```

## Resources
- [Creating an Apple Pay Certificate](https://developers.braintreepayments.com/guides/apple-pay/configuration/ios/v4#apple-pay-certificate-request-and-provisioning)
- [Obtaining a Tokentization Key](https://developers.braintreepayments.com/guides/authorization/tokenization-key/ios/v4#obtaining-a-tokenization-key)