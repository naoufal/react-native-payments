# Braintree Demo

This is a universal iOS app that exercises just about every feature of Braintree iOS.

You can take a look at the classes under [Features](./Features) to get a sense of how this SDK can be used.

## Usage

This app allows you to switch between the different features, or sample integrations, that it showcases. Each integration starts with loading a client token from a sample merchant server. This happens automatically when you open the app. Once the client token is loaded, the current integration is shown.

You can switch between features using the `Settings` menu. This app will remember which feature you last looked at; the in-app settings are synchronized with the iOS Settings app.

You can reload the current integration by tapping on the the reload button on the upper left.

The current status is shown on the bottom toolbar. If you've created a payment method nonce, you tap on the status toolbar to create a transaction.

### Compatibility

This app should be compiled with a 8.x Base SDK (Xcode 6.x) and has a deployment target of iOS 7.0.

## Implementation

This codebase has three primary sections:

* **Demo Base** - contains boilerplate code that facilitates switching between demo integrations.
* **Merchant API Client** - contains an API client that might be similar to one found in a real app; note that it consumes a _hypothetical merchant_ API, not Braintree's API.
* **Features** - contains a number of Braintree iOS demo integrations.

Each demo integration must provide a `BraintreeDemoBaseViewController` subclass. Most importantly, the demo provides a `paymentButton`, which is presented to the user when the demo is selected.

To add a new demo, you will additionally need to register the demo in the [Settings bundle](./Demo Base/Settings/Settings.bundle/Root.plist), identifying the view controller by class name.

The most common class of integration, which involves presenting the user with a single button—to trigger whatever type of payment experience you choose—can be powered by another base class, `BraintreeDemoPaymentButtonBaseViewController`.

Your demo view controller may call its `progressBlock` or `completionBlock` in order to update the rest of the app (and the user) about the payment method creation lifecycle.

### Steps to Add a New Demo

1. Create a new `BraintreeDemoBaseViewController` subclass in a new directory under Features.
2. Utilize `self.braintree` to implement a Braintree integration, and call `completionBlock` upon successfully creating a payment method.
3. Register this class in the Settings bundle, by adding new items in the `Integration` multi value item, under `titles` and `values`.

💸👍🏻
