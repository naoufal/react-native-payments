# Frameworks

The Braintree iOS SDK is organized into a family of frameworks.

### Differences from Braintree-iOS 3.x
* Frameworks and Carthage support
* Client key and JWT instead of client token
* `BTAPIClient` instead of `BTClient`
* `BTTokenized` instead of `BTPaymentMethod`
* Refactored tests and added tests in Swift


## BraintreeCore

This is the core set of models and networking needed to use Braintree in an app or extension. All other frameworks depend on this.

<sub>PRIMARY CLASS:</sub>
### `BTAPIClient`: Braintree API client
* Authentication with client key / JWT
* Access configuration from gateway
* Analytics
* HTTP methods on Braintree API endpoints

#### Other Classes

* `BTAppSwitch`: Class and protocol for authentication via app switch
* `BTJSON`: JSON parser

## Payment Options

The Braintree iOS SDK currently supports 6 payment options.

1. `BraintreeCard`: Credit and debit card
  * No dependencies other than `BraintreeCore`
2. `BraintreeApplePay`: Apple Pay
  * Depends on `PassKit`
3. `BraintreePayPal`: PayPal
  * No dependencies other than `BraintreeCore`
  * Use `BTPaymentDriverDelegate` to receive app switch lifecycle events
4. `BraintreeVenmo`: Venmo
  * Depends on `BraintreeCard`
5. `Braintree3DSecure`: 3D Secure
  * Depends on `BraintreeCard`
  * Use `BTViewControllerPresentingDelegate` (required) for cases when a view controller must be presented for buyer verification
6. `BraintreeCoinbase`: Coinbase
  * No dependencies other than `BraintreeCore`


## BraintreeCard

Tokenizes credit or debit cards.

<sub>PRIMARY CLASS:</sub>
### `BTCardTokenizationClient`: Tokenizes credit and debit card info

#### Other Classes

* `BTCardTokenizationRequest`: Raw credit or debit card data provided by the customer
* `BTTokenizedCard`: A tokenized card that contains a payment method nonce


## BraintreeUI

A pre-built payment form and payment button.

Optionally uses these payment option frameworks, if present: `BraintreeCard`, `BraintreePayPal`, `BraintreeVenmo`, `BraintreeCoinbase`.

### Features

* UI
  * Card form
* Drop-in


## BraintreePayPal

Accept payments with PayPal app via PayPal One Touch.

### Features

* `BTPayPalDriver`: Coordinates paying with PayPal by switching to the PayPal app or the web browser
* **Future payments** via `-authorizeAccount...`
  * `BTTokenizedPayPalAccount`: A tokenized PayPal account that contains a payment method nonce
* **Single payments** via `-checkoutWithCheckoutRequest...`
  * `BTTokenizedPayPalCheckout`: A tokenized PayPal checkout that contains a payment method nonce
* `BTPayPalCheckoutRequest`: Options for a PayPal checkout flow


## BraintreeVenmo

**Depends on BraintreeCard.**

Accept payments with a credit or debit card from the Venmo app via Venmo One Touch.

### Features

* `BTVenmoDriver`: Coordinates switching to the Venmo app for the buyer to select a card
* `BTVenmoTokenizedCard`: A tokenized card from Venmo that contains a payment method nonce


## BraintreeCoinbase

Accept bitcoin payments via Coinbase.

## Features

* `BTCoinbaseDriver`: Coordinates paying with Coinbase by switching to the Coinbase app or the web browser
* `BTTokenizedCoinbaseAccount`: A tokenized Coinbase account that contains a payment method nonce


## BraintreeApplePay

**Depends on `PassKit`.**

Accept Apple Pay by using Braintree to process payments.

### Features

* `BTApplePayTokenizationClient`: Performs tokenization of a `PKPayment` and returns a tokenized Apple Pay payment instrument
* `BTTokenizedApplePayPayment`: A tokenized Apple Pay payment that contains a payment method nonce


## Braintree3DSecure

**Depends on `BraintreeCard`.**

Perform 3D Secure verification.

### Features

* `BTThreeDSecureDriver`: Coordinates 3D Secure verification via in-app web view
* `BTThreeDSecureVerification`: Card/transactions details to be verified
* `BTThreeDSecureTokenizedCard`: A tokenized card that contains a payment method nonce
  * `liabilityShifted`: 3D Secure worked and authentication succeeded. This will also be true if the issuing bank does not support 3D Secure, but the payment method does
  * `liabilityShiftPossible`: The payment method was eligible for 3D Secure
  * These parameters pass through the client-side first and should not be trusted for your server-side risk assessment

