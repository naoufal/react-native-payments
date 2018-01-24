# react-native-payments-addon-stripe
<a href="https://github.com/naoufal/react-native-payments">React Native Payments</a> add-on for processing payments with Stripe.

## Installation
First, download the package:

```bash
$ yarn add react-native-payments-addon-stripe
```

Second, install the [React Native Payments CLI](https://www.npmjs.com/package/react-native-payments-cli):
```bash
$ yarn add react-native-payments-cli
```

Then, complete the Carthage dependency. Otherwise the next step fails:
```bash
$ cd node_modules/react-native-payments-addon-stripe
$ carthage update
```

Lastly, link the native dependencies with the React Native Payments CLI:
```bash
$ yarn react-native-payments-cli -- link stripe
```

_NOTE: `react-native-payments-cli` adds a Build Phase Script to your Xcode project that depends on <a href="https://github.com/Carthage/Carthage">Carthage</a>._

## Usage
In order to receive chargeable Stripe tokens as part of your `PaymentResponse`, you'll need to add some Stripe specific parameters to your `PaymentMethodData`.

Here's an example of a Stripe enabled Payment Method Data:

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
+       gateway: 'stripe',
+       'stripe:publishableKey': 'your_publishable_key',
+       'stripe:version': '5.0.0' // Only required on Android
+     }
+   }
  }
}];
```

## Resources
- [Creating an Apple Pay Certificate](https://stripe.com/docs/apple-pay/apps#csr)
- [About Publishable Keys](https://stripe.com/docs/dashboard#api-keys)
