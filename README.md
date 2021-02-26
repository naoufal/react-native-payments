# react-native-payments

[![Build Status](https://travis-ci.org/naoufal/react-native-payments.svg?branch=master)](https://travis-ci.org/naoufal/react-native-payments) [![Codeship Status for freeman-industries/react-native-payments](https://app.codeship.com/projects/d6d17e65-23f0-4154-b7ce-33ce59471b08/status?branch=master)](https://app.codeship.com/projects/418096)

Welcome to the best and most comprehensive library for integrating payments like Apple Pay and Google Pay into your React Native app.

This library is designed to be fully compatible with React Native 0.61 and onwards.

<div>
<img width="200px" src="https://user-images.githubusercontent.com/1627824/27758096-9fc6bf9a-5dc1-11e7-9d8f-b2d409302fc7.gif" />
<img width="200px" src="https://user-images.githubusercontent.com/1627824/30039983-d75d1b3e-91d8-11e7-9ac9-71d2ed12958c.png" />
</div>

# Installation

```
npm install --save react-native-payments
```

You'll need to autolink on each platform:

### Android

```
npx jetify
```

### iOS

```
cd ios
pod install
```

# Guides

## Example projects

- [iOS](https://github.com/freeman-industries/react-native-payments-example-ios)

## Live demo

For a step by step guide, check out this talk by @naoufal.

https://www.youtube.com/watch?v=XrmUuir9OHc&t=652

## API Spec

Down below we have a detailed specification for PaymentRequest and instructions for configuring Apple Pay and Google Pay, which is hopefully enough to get you started.

We also have some legacy example projects in the `examples` directory that will be rewritten soon and linked above.

Bear with us while we organize things a bit.

# Roadmap

## Completed

- Apple Pay Stripe

## Completed, untested

- Apple Pay Braintree
- Google Pay (Stripe, Braintree)
- Web

## In progress

- Stripe: Payment Intents (for SCA)

## Planned

- Tutorial docs

Naoufal, the original author of this library, has done a lot of the hard work integrating iOS, Android, Web platforms and Stripe and Braintree gateways.

The library has fallen out of regular maintenance and we're working to test and update all parts to be compatible for RN in the 2020s.

If you're feeling brave give the untested platforms a try and let us know how it worked.

# Contributors

Many people have contributed to the development of `react-native-payments` over time. The people below are currently available to help.

- [@nabilfreeman](https://github.com/nabilfreeman) ⚙️ ✏️
- [@runticle](https://github.com/runticle) ✏️

---
Merge PRs: ⚙️ | Review issues: ✏️

## Join us!

All contributions, big or small are welcomed.

For large PRs, please open an issue and have a discussion with us first before you dive in.

Our plan for this library is for it to be useful to all React Native developers so we want to architect it carefully.

# In the wild

These amazing people use `react-native-payments` in their projects.

- [LeSalon (@lesalonapp)](https://github.com/lesalonapp)
- [Truphone (My Truphone App)](https://truphone.com/consumer/esim-for-smartphone)

To add your organization, open a PR updating this list.

---

🚧

🚧

🚧

🚧

🚧

---

> This project is currently in __beta and APIs are subject to change.__

# React Native Payments
[![react-native version](https://img.shields.io/badge/react--native-0.41-0ba7d3.svg?style=flat-square)](http://facebook.github.io/react-native/releases/0.40)
[![npm](https://img.shields.io/npm/v/react-native-payments.svg?style=flat-square)](https://www.npmjs.com/package/react-native-payments)
[![npm](https://img.shields.io/npm/dm/react-native-payments.svg?style=flat-square)](https://www.npmjs.com/package/react-native-payments)
[![styled with prettier](https://img.shields.io/badge/styled_with-prettier-ff69b4.svg?style=flat-square)](https://github.com/prettier/prettier)

Accept Payments with Apple Pay and Android Pay using the [Payment Request API](https://paymentrequest.show).

__Features__
- __Simple.__ No more checkout forms.
- __Effective__. Faster checkouts that increase conversion.
- __Future-proof__. Use a W3C Standards API, supported by companies like Google, Firefox and others.
- __Cross-platform__. Share payments code between your iOS, Android, and web apps.
- __Add-ons__. Easily enable support for Stripe or Braintree via add-ons.

---

## Table of Contents
- [Demo](#demo)
- [Installation](#installation)
- [Usage](#usage)
- [Testing Payments](#testing-payments)
- [Apple Pay button](#apple-pay-button)
- [Add-ons](#add-ons)
- [API](#api)
- [Resources](#resources)
- [License](#license)

## Demo
You can run the demo by cloning the project and running:

```shell
$ yarn run:demo
```

In a rush? Check out the [browser version](https://rnp.nof.me) of the demo.

_Note that you'll need to run it from a browser with [Payment Request support](https://caniuse.com/#search=payment%20request)._

## Installation
First, download the package:
```shell
$ yarn add react-native-payments
```
Second, link the native dependencies:
```shell
$ react-native link react-native-payments
```

## Usage
- [Setting up Apple Pay/Android Pay](#setting-up-apple-payandroid-pay)
- [Importing the Library](#importing-the-library)
- [Initializing the Payment Request](#initializing-the-payment-request)
- [Displaying the Payment Request](#displaying-the-payment-request)
- [Aborting the Payment Request](#aborting-the-payment-request)
- [Requesting Contact Information](#requesting-contact-information)
- [Requesting a Shipping Address](#requesting-a-shipping-address)
- [Processing Payments](#processing-payments)
- [Dismissing the Payment Request](#dismissing-the-payment-request)


### Setting up Apple Pay/Android Pay
Before you can start accepting payments in your App, you'll need to setup Apple Pay and/or Android Pay.

#### Apple Pay
1. Register as an Apple Developer
1. Obtain a merchant ID
1. Enable Apple Pay in your app

Apple has a documentation on how to do this in their _[Configuring your Environment](https://developer.apple.com/library/content/ApplePay_Guide/Configuration.html)_ guide.

#### Android Pay

1. Add Android Pay and Google Play Services to your dependencies
1. Enable Android Pay in your Manifest

Google has documentation on how to do this in their _[Setup Android Pay](https://developers.google.com/pay/api/android/guides/setup)_ guide.

### Importing the Library
Once Apple Pay/Android Pay is enabled in your app, jump into your app's entrypoint and make the `PaymentRequest` globally available to your app.

```es6
// index.ios.js
global.PaymentRequest = require('react-native-payments').PaymentRequest;
```

### Initializing the Payment Request
To initialize a Payment Request, you'll need to provide `PaymentMethodData` and `PaymentDetails`.

#### Payment Method Data
The Payment Method Data is where you defined the forms of payment that you accept.  To enable Apple Pay, we'll define a `supportedMethod` of `apple-pay`.  We're also required to pass a `data` object to configures Apple Pay.  This is where we provide our merchant id, define the supported card types and the currency we'll be operating in.

```es6
const METHOD_DATA = [{
  supportedMethods: ['apple-pay'],
  data: {
    merchantIdentifier: 'merchant.com.your-app.namespace',
    supportedNetworks: ['visa', 'mastercard', 'amex'],
    countryCode: 'US',
    currencyCode: 'USD'
  }
}];
```

<details>
<summary><strong>See Android Pay Example</strong></summary>
<br/>

```es6
const METHOD_DATA = [{
  supportedMethods: ['android-pay'],
  data: {
    supportedNetworks: ['visa', 'mastercard', 'amex'],
    currencyCode: 'USD',
    environment: 'TEST', // defaults to production
    paymentMethodTokenizationParameters: {
      tokenizationType: 'NETWORK_TOKEN',
      parameters: {
        publicKey: 'your-pubic-key'
      }
    }
  }
}];
```

</details>

#### Payment Details
Payment Details is where define transaction details like display items, a total and optionally shipping options.

Google has excellent documentation for [Defining Payment Details](https://developers.google.com/web/fundamentals/discovery-and-monetization/payment-request/deep-dive-into-payment-request#defining_payment_details).

```es6
const DETAILS = {
  id: 'basic-example',
  displayItems: [
    {
      label: 'Movie Ticket',
      amount: { currency: 'USD', value: '15.00' }
    }
  ],
  total: {
    label: 'Merchant Name',
    amount: { currency: 'USD', value: '15.00' }
  }
};
```

Once you've defined your `methodData` and `details`, you're ready to initialize your Payment Request.

```es6
const paymentRequest = new PaymentRequest(METHOD_DATA, DETAILS);
```

🚨 _Note: On Android, display items are not displayed within the Android Pay view.  Instead, the _[User Flows documentation](https://developers.google.com/android-pay/payment-flows)_ suggests showing users a confirmation view where you list the display items.  When using React Native Payments, show this view after receiving the `PaymentResponse`._

### Displaying the Payment Request
Now that you've setup your Payment Request, displaying it is as simple as calling the `show` method.

```es6
paymentRequest.show();
```

<details>
<summary><strong>See Screenshots</strong></summary>
<br/>
<img width="250px" src="https://user-images.githubusercontent.com/1627824/27548765-be9121c0-5a4e-11e7-8e45-4b460e314e6a.png" />
<img width="250px" src="https://user-images.githubusercontent.com/1627824/30039982-d565c68c-91d8-11e7-9cb9-2a0e58fffe6a.png" />

</details>

### Aborting the Payment Request
You can abort the Payment Request at any point by calling the `abort` method.

```es6
paymentRequest.abort();
```

🚨 _Note: Not yet implemented on Android Pay_

### Requesting Contact Information
Some apps may require contact information from a user.  You can do so by providing a [`PaymentOptions`]() as a third argument when initializing a Payment Request. Using Payment Options, you can request a contact name, phone number and/or email.

#### Requesting a Contact Name
Set `requestPayerName` to `true` to request a contact name.

```es6
const OPTIONS = {
  requestPayerName: true
};
```

<details>
<summary><strong>See Screenshots</strong></summary>
<br/>
<img width="250px" src="https://user-images.githubusercontent.com/1627824/27549933-9be15be6-5a52-11e7-868a-abcfc8867968.png" />
<img width="250px" src="https://user-images.githubusercontent.com/1627824/30039983-d75d1b3e-91d8-11e7-9ac9-71d2ed12958c.png" />

</details>
<br/>

🚨 _Note: On Android, requesting a contact name will present the user with a shipping address selector. If you're not shipping anything to the user, consider capturing the contact name outside of Android Pay._

#### Requesting a Phone Number
Set `requestPayerPhone` to `true` to request a phone number.

```es6
const OPTIONS = {
  requestPayerPhone: true
};
```

<details>
<summary><strong>See Screenshots</strong></summary>
<br/>
<img width="250px" src="https://user-images.githubusercontent.com/1627824/27549958-b6732160-5a52-11e7-8813-3beeeed03b9c.png" />
<img width="250px" src="https://user-images.githubusercontent.com/1627824/30039983-d75d1b3e-91d8-11e7-9ac9-71d2ed12958c.png" />

</details>
<br/>

🚨 _Note: On Android, requesting a phone number will present the user with a shipping address selector. If you're not shipping anything to the user, consider capturing the phone number outside of Android Pay._

#### Requesting an Email Address
Set `requestPayerEmail` to `true` to request an email address.

```es6
const OPTIONS = {
  requestPayerEmail: true
};
```

<details>
<summary><strong>See Screenshots</strong></summary>
<br/>
<img width="250px" src="https://user-images.githubusercontent.com/1627824/27549968-c172ac34-5a52-11e7-973d-8d06a3beb5ce.png" />
<img width="250px" src="https://user-images.githubusercontent.com/1627824/30039982-d565c68c-91d8-11e7-9cb9-2a0e58fffe6a.png" />

</details>
<br/>

You can also request all three by setting them all to `true`.

```es6
const OPTIONS = {
  requestPayerName: true,
  requestPayerPhone: true,
  requestPayerEmail: true
};
```

### Requesting a Shipping Address
Requesting a shipping address is done in three steps.

First, you'll need to set `requestShipping` to `true` within `PaymentOptions`.

```es6
const OPTIONS = {
  requestShipping: true
};
```

Second, you'll need to include `shippingOptions` in your Payment Details.

```diff
const DETAILS = {
  id: 'basic-example',
  displayItems: [
    {
      label: 'Movie Ticket',
      amount: { currency: 'USD', value: '15.00' }
    }
  ],
+ shippingOptions: [{
+   id: 'economy',
+   label: 'Economy Shipping',
+   amount: { currency: 'USD', value: '0.00' },
+   detail: 'Arrives in 3-5 days' // `detail` is specific to React Native Payments
+ }],
  total: {
    label: 'Merchant Name',
    amount: { currency: 'USD', value: '15.00' }
  }
};
```

Lastly, you'll need to register event listeners for when a user selects a `shippingAddress` and/or a `shippingOption`.  In the callback each event, you'll need to provide new `PaymentDetails` that will update your PaymentRequest.

```es6
paymentRequest.addEventListener('shippingaddresschange', e => {
  const updatedDetails = getUpdatedDetailsForShippingAddress(paymentRequest.shippingAddress;

  e.updateWith(updatedDetails);
});

paymentRequest.addEventListener('shippingoptionchange', e => {
  const updatedDetails = getUpdatedDetailsForShippingOption(paymentRequest.shippingOption);

  e.updateWith(updatedDetails);
});
```

For a deeper dive on handling shipping in Payment Request, checkout Google's _[Shipping in Payment Request](https://developers.google.com/web/fundamentals/discovery-and-monetization/payment-request/deep-dive-into-payment-request#shipping_in_payment_request_api)_.

🚨 _Note: On Android, there are no `shippingaddresschange` and `shippingoptionchange` events.  To allow users to update their shipping address, you'll need to trigger a new `PaymentRequest`.  Updating shipping options typically happens after the receiving the `PaymentResponse` and before calling its `getPaymentToken` method._

### Processing Payments
Now that we know how to initialize, display, and dismiss a Payment Request, let's take a look at how to process payments.

When a user accepts to pay, `PaymentRequest.show` will resolve to a Payment Response.

```es6
paymentRequest.show()
  .then(paymentResponse => {
    // Your payment processing code goes here

    return processPayment(paymentResponse);
  });
```

There are two ways to process Apple Pay/Android Pay payments -- on your server or using a payment processor.

#### Processing Payments on Your Server
If you're equipped to process Apple Pay/Android Pay payments on your server, all you have to do is send the Payment Response data to your server.

> ⚠️ **Note:** When running Apple Pay on simulator, `paymentData` equals to `null`.

```es6
import { NativeModules } from 'react-native';

paymentRequest.show()
  .then(paymentResponse => {
    const { transactionIdentifier, paymentData } = paymentResponse.details;

    return fetch('...', {
      method: 'POST',
      body: {
        transactionIdentifier,
        paymentData
      }
    })
    .then(res => res.json())
    .then(successHandler)
    .catch(errorHandler)
  });
```

<details>
<summary><strong>See Android Pay Example</strong></summary>
<br/>

```es6
paymentRequest.show()
  .then(paymentResponse => {
    const { getPaymentToken } = paymentResponse.details;

    return getPaymentToken()
      .then(paymentToken => {
        const { ephemeralPublicKey, encryptedMessage, tag } = paymentResponse.details;

        return fetch('...', {
          method: 'POST',
          body: {
            ephemeralPublicKey,
            encryptedMessage,
            tag
          }
        })
        .then(res => res.json())
        .then(successHandler)
        .catch(errorHandler)
      });
  });
```

</details>
<br/>

You can learn more about server-side decrypting of Payment Tokens on Apple's [Payment Token Format Reference](https://developer.apple.com/library/content/documentation/PassKit/Reference/PaymentTokenJSON/PaymentTokenJSON.html) documentation.

#### Processing Payments with a Payment Processor
When using a payment processor, you'll receive a `paymentToken` field within the `details` of the `PaymentResponse`.  Use this token to charge customers with your payment processor.

```es6
paymentRequest.show()
  .then(paymentResponse => {
    const { paymentToken } = paymentResponse.details; // On Android, you need to invoke the `getPaymentToken` method to receive the `paymentToken`.

    return fetch('...', {
      method: 'POST',
      body: {
        paymentToken
      }
    })
    .then(res => res.json())
    .then(successHandler)
    .catch(errorHandler);
  });
```

<details>
<summary><strong>See Android Pay Example</strong></summary>
<br/>

```es6
paymentRequest.show()
  .then(paymentResponse => {
    const { getPaymentToken } = paymentResponse.details;

    return getPaymentToken()
      .then(paymentToken => fetch('...', {
        method: 'POST',
        body: {
          paymentToken
        }
      })
      .then(res => res.json())
      .then(successHandler)
      .catch(errorHandler);
    });
  });
```

</details>
<br/>

For a list of supported payment processors and how to enable them, see the [Add-ons](#add-ons) section.

### Dismissing the Payment Request
Dismissing the Payment Request is as simple as calling the `complete` method on of the `PaymentResponse`.

```es6
paymentResponse.complete('success'); // Alternatively, you can call it with `fail` or `unknown`
```

🚨 _Note: On Android, there is no need to call `paymentResponse.complete` -- the PaymentRequest dismisses itself._

## Testing Payments

### Apple Pay

The sandbox environment is a great way to test offline implementation of Apple Pay for apps, websites, and point of sale systems. Apple offers [detailed guide](https://developer.apple.com/support/apple-pay-sandbox/) for setting up sandbox environment.
> ⚠️ **Note:** It is also important to test Apple Pay in your production environment. Real cards must be used in the production environment. Test cards will not work.
>
> ⚠️ **Note:** There are known differences when running Apple Pay on simulator and real device. Make sure you test Apple Pay on real device before going into production.

## Apple Pay Button

Provides a button that is used either to trigger payments through Apple Pay or to prompt the user to set up a card.
[Detailed docs and examples](docs/ApplePayButton.md)

## Add-ons
Here's a list of Payment Processors that you can enable via add-ons:
- [Stripe](https://github.com/naoufal/react-native-payments/blob/master/packages/react-native-payments-addon-stripe)
- [Braintree](https://github.com/naoufal/react-native-payments/blob/master/packages/react-native-payments-addon-braintree)

🚨 _Note: On Android, Payment Processors are enabled by default._

## API
### [NativePayments](docs/NativePayments.md)
### [PaymentRequest](docs/PaymentRequest.md)
### [PaymentRequestUpdateEvent](docs/PaymentRequestUpdateEvent.md)
### [PaymentResponse](docs/PaymentResponse.md)

## Resources
### Payment Request
- [Introducing the Payment Request API](https://developers.google.com/web/fundamentals/discovery-and-monetization/payment-request)
- [Deep Dive into the Payment Request API](https://developers.google.com/web/fundamentals/discovery-and-monetization/payment-request/deep-dive-into-payment-request)
- [W3C API Working Draft](https://www.w3.org/TR/payment-request/)
- [Web Payments](https://www.youtube.com/watch?v=U0LkQijSeko)
- [The Future of Web Payments](https://www.youtube.com/watch?v=hU89pPBmhds)

### Apple Pay
- [Getting Started with Apple Pay](https://developer.apple.com/apple-pay/get-started)
- [Configuring your Environment](https://developer.apple.com/library/content/ApplePay_Guide/Configuration.html)
- [Processing Payments](https://developer.apple.com/library/content/ApplePay_Guide/ProcessPayment.html#//apple_ref/doc/uid/TP40014764-CH5-SW4)
- [Payment Token Format Reference](https://developer.apple.com/library/content/documentation/PassKit/Reference/PaymentTokenJSON/PaymentTokenJSON.html#//apple_ref/doc/uid/TP40014929)

### Android Pay
- [Setup Android Pay](https://developers.google.com/pay/api/android/guides/setup)
- [Tutorial](https://developers.google.com/pay/api/android/guides/tutorial)
- [Brand Guidelines](https://developers.google.com/pay/api/android/guides/brand-guidelines)
- [Gateway Token Approach](https://developers.google.com/web/fundamentals/discovery-and-monetization/payment-request/android-pay#gateway_token_approach)
- [Network Token Approach](https://developers.google.com/web/fundamentals/discovery-and-monetization/payment-request/android-pay#network_token_approach)

# License
Licensed under the MIT License, Copyright © 2017, [Naoufal Kadhom](https://twitter.com/naoufal).

See [LICENSE](https://github.com/naoufal/react-native-payments/blob/master/LICENSE) for more information.