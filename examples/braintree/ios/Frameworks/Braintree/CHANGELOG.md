# Braintree iOS SDK Release Notes

## 4.8.4 (2017-06-26)

* Update to Kount 3.2
* Update Demo to support Xcode9 (Beta 1) and iOS11
* Update README

## 4.8.3 (2017-05-30)

* Fix Pay with Venmo bug

## 4.8.2 (2017-05-11)

* Add PayPal Credit support to PayPal Billing Agreements flow
* Add V3 Client Token support
* Enable client side vaulting of Venmo nonces
* Fix potential memory leak issue [#312](https://github.com/braintree/braintree_ios/issues/312)
* Fix bug causing random crashes in 3DS flow [#329](https://github.com/braintree/braintree_ios/issues/329)

## 4.8.1 (2017-04-07)

* Optimize BTAPIClient:initWithAuthorization: when using a client token
* Fix invalid documentation tags

## 4.8.0 (2017-03-30)

* Enable PayPal Credit
* Add support for `displayName` and `landing_page_type` PayPal options
* Fix issue with 3DS error callbacks [#318](https://github.com/braintree/braintree_ios/issues/318)
* Resolve build error in Xcode 8.3

## 4.7.5 (2017-02-22)

* Fix issue where PayPal correlation_id was not set correctly
* Add support for custom PayPal authentication handler
* Update docs to specify Xcode 8+ requirement
* Fix header import in BTAnalyticsMetadata.m
* Additional tuning for Travis CI

## 4.7.4 (2017-01-13)

* Update UnitTests to Swift 3
* Update PayPal header docs
* Update CocoaDocs and remove styling

## 4.7.3 (2016-11-18)

* Allow `BraintreeCore` to be compatible with App Extensions
* Fix `BraintreePayPal` use of `queryItems` for iOS 7 compatibility
* Present SFSafariViewControllers from the top UIViewController via Drop-in to avoid blank SFSafariViewController
  * Set `BTPaymentRequest` `presentViewControllersFromTop` to `YES` to opt in to this behavior
* Fix `@param` warning for incorrect argument name
* Fix CocoaDocs and add styling

## 4.7.2 (2016-11-08)

* Update Apple-Pay
  * Fix issue when using `BTConfiguration:applePaySupportedNetworks` with `Discover` enabled on devices `<iOS 9`
  * Add `BTApplePayClient:paymentRequest:` - creates a `PKPaymentRequest` with values from your Braintree Apple Pay configuration
* Update documentation and README

## 4.7.1 (2016-10-18)

* Update to Kount 3.1
* Update libPPRiskComponent to latest version
* Refactored ACKNOWLEDGEMENTS.md with links instead of text
* Re-add new Drop-In demo from BraintreeDropIn
* Fix fbinfer warnings

## 4.7.0 (2016-09-23)

* Move `BraintreeDropIn` and `BraintreeUIKit` to a new [separate repository](https://github.com/braintree/braintree-ios-drop-in)
  to allow cleaner separation and iteration for newer versions of Drop-In.
  * Please see the new repository for updated integration instructions if you were using the Beta Drop-In Update.
  * If you were using Drop-In from `BraintreeUI`, you do not have to update. However, you may want to check out the
    new Drop-In for an updated experience.
* Fix issue with `DataCollector` setting the merchant ID automatically to configure Kount

## 4.6.1 (2016-09-15)

* Fix conflicting private API name Fixes #265
* Fix deprecation warnings for Xcode 8 Fixes #267
* Fix target membership for static library Fixes #264
* Improve Maestro card number recognition

## 4.6.0 (2016-09-09)

* Fix nullability annotations for Xcode 8 Fixes #260
* Add `userAction` property to `BTPayPalRequest`
* (BETA) Updates to `BraintreeDropIn`

## 4.5.0 (2016-08-05)

* Update `DataCollector` API
  * Add initializer and new data collection methods that take a completion block
    * New data collection methods use Braintree gateway configuration to configure Kount
  * Previous API for `BTDataCollector` has been deprecated
* Remove Venmo user whitelist – all Venmo users may now make merchant purchases using Venmo.

## 4.4.1 (2016-07-22)

* Update and fix issues in `BraintreeDropIn` based on feedback
* Make more headers public in `BraintreeUIKit`
* Fix `BraintreeUIKit` module name for Cocoapods
* Add support for 3D Secure to `BraintreeDropIn` (see Drop-In docs)
* Update the [Drop-In docs](Docs/Drop-In-Update.md)
* Add features to support vaulting Venmo when using Drop-In (coming soon)

## 4.4.0 (2016-07-14)

* (BETA) Release of new `BraintreeDropIn` and `BraintreeUIKit` frameworks
  * `BraintreeDropIn` bundles our new UI components and Braintree API's for a whole new Drop-In experience
  * UI components, helpers, vector art and localizations are now public and fully accessible via `BraintreeUIKit`
  * [Learn more about our Drop-In Update](Docs/Drop-In-Update.md)
  * Note that our legacy Drop-In (`BraintreeUI`) has not changed
* (BETA) Various updates to the UnionPay component
* Improve error messages when Braintree gateway returns 422 validation errors

## 4.3.2 (2016-06-09)

* Update Pay with Venmo to use merchant ID and environment from configuration
* PayPal Checkout supports an intent option, which can be authorize or sale
  * See `BTPayPalRequest`'s `intent` property
* Provide better `NSError` descriptions when Braintree services return a 4xx or 5xx HTTP error

## 4.3.1 (2016-05-25)

* Add public method to fetch a customer's vaulted payment method nonces
* Drop-in bug fixes
  * Do not show mobile phone number field
  * Fix issue where American Express display text is truncated
* Merge [#241](https://github.com/braintree/braintree_ios/pull/241) - Add missing source files to Braintree static library target. (Thanks @AlexDenisov!)

## 4.3.0 (2016-05-03)

* Add support for UnionPay cards
  * UnionPay is now in private beta. To request access, email [unionpay@braintreepayments.com](mailto:unionpay@braintreepayments.com).
* Drop-in displays vaulted payment methods by default first
  * Payment method nonces have an `isDefault` property
* Add `BTHTTPErrorCodeRateLimitError` to indicate when Braintree is rate-limiting your app's API requests
* Update support for static library integrations
  * Fix issues with missing classes in the Braintree static library target
  * Add [guide for Static Library integrations](Docs/Braintree-Static-Integration-Guide.md)
* Use in-memory `NSURLCache` for configuration caching
* Analytics events are batched together for better performance
* Update theme of card form child components when using custom theme
* `PayPalOneTouch` is less chatty when logging to console
* Add ACKNOWLEDGEMENTS.md
* Update `PayPalDataCollector` to include latest `libPPRiskComponent.a`
* Remove unused targets and schemes: `Demo-StaticLibrary`, `UnitTests-CocoaPods`, and `UnitTests-StaticLibrary`

## 4.2.3 (2016-02-22)

* Remove assertion from PayPal One Touch Core when reading from Keychain fails
* Remove NSLog() from PayPal One Touch Core
* Fix nullability annotation in `PPFPTITracker.h` to squelch error in Xcode 7.3 Beta

## 4.2.2 (2016-02-11)

* Fix crash that occurs when downgrading Braintree from 4.2.x to previous versions

## 4.2.1 (2016-02-05)

* Fix deprecation warning/error in PayPal One Touch for apps that target >= iOS 9.0

## 4.2.0 (2016-02-04)

* Open source PayPal One Touch library
  * Source code for PayPal One Touch library is now included in Braintree iOS SDK repository
  * Added CocoaPods subspecs for PayPalOneTouch and PayPalDataCollector
* Improve `BTPaymentButton`
  * Payment button displays payment options based on configuration
  * Shows loading activity indicator when fetching configuration
  * Updated style for PayPal button when PayPal is the only available payment option
  * Can manually configure available payment options via `enabledPaymentOptions` property
* Added `setCardNumber:` and `setCardExpirationMonth:year:` to `BTDropInViewController`
  * Drop-in card form can be prepopulated, e.g. by card.io
* Deprecate `BTDataCollector` `payPalClientMetadataID` and `collectPayPalClientMetadataId`
  * Use `PPDataCollector` `collectPayPalDeviceData` when you only need to collect PayPal device data
* Add Travis CI to run tests

## 4.1.3 (2016-01-08)

* Prevent crash when `BTPayPalDriver` instantiates `SFSafariViewController` with an invalid URL, and return an error instead
* Update `BTTokenizationService` `allTypes` property to be `NSArray <NSString *>`

## 4.1.2 (2015-12-09)

* Workaround for Swift compiler bug that causes `BTJSON` to conflict with Alamofire (see Issue [#195](https://github.com/braintree/braintree_ios/issues/195))
  * For the merchant apps that read their configuration directly from `BTJSON` via Objective-C, you may need to switch from dot syntax to square brackets to call `BTJSON` methods
* Ignore `UIAlertView` deprecation warning in `BTDropInErrorAlert`

## 4.1.1 (2015-12-08)

* Bug fix for Drop-in view controller showing empty `BTPaymentButton`
* Update Kount to 2.6.2

## 4.1.0 (2015-12-07)

* Limited release of Pay With Venmo
  * Contact [pay-with-venmo@braintreepayments.com](mailto:pay-with-venmo@braintreepayments.com) if you are interested in early access
* Fix for Carthage integrations: remove reference to Braintree developer team from Xcode framework targets
* Streamlined vector graphics for JCB logo to reduce build time of BraintreeUI

## 4.0.2 (2015-11-30)

* If the Client Token has a Customer ID, Drop-in will automatically fetch the customer's vaulted payment methods.
  * A bug in 4.0.0-4.0.1 prevented Drop-in from fetching payment methods even if a Customer ID is provided in the Client Token; apps needed to call `fetchPaymentMethodsOnCompletion` before presenting Drop-in.
  * You can still call `fetchPaymentMethodsOnCompletion` to pre-fetch payment methods, so that Drop-in doesn't need to show its own loading activity indicator.
* Prevent calling requestsDismissalOfViewController on iOS 8 when there is nothing to dismiss. (Merge [#199](https://github.com/braintree/braintree_ios/pull/199) - thanks, @Reflejo!)
* Drop-in Add Payment Method fixes
  * Show/hide CVV and postal code fields without flicker
  * Use Save bar button item in upper right to add additional payment methods
* `BTPayPalDriver` will not call `BTAppSwitchDelegate` callback methods when `SFSafariViewController` is presented (Issue [#188](https://github.com/braintree/braintree_ios/issues/188))

## 4.0.1 (2015-11-17)

* Drop-in fixes
  * Fixed a bug that prevented cards from being vaulted.
    * Note: [BTCard's behavior has changed slightly](https://github.com/braintree/braintree_ios/commit/18b67d3).
  * Fixed a bug that prevented card types from being parsed.
  * Updated Demo to use paymentRequest and always call completionBlock.
* Resolved an analyzer warning in BTAPIClient.m.

## 4.0.0 (2015-11-09)

* Remodel the iOS SDK into frameworks with smaller filesize and greater flexibility.
* The public API has changed significantly in this release. For details, see the [v4 Migration Guide](Docs/Braintree-4.0-Migration-Guide.md) and the public header files.
* APIs have been refactored to use completion blocks instead of delegate methods.
* BTPaymentProvider has been removed. Instead, use payment option frameworks. For example, import BraintreeApplePay and use BTApplePayClient.
* Added support for [Tokenization Keys](https://developers.braintreepayments.com/guides/authorization/tokenization-key) in addition to Client Tokens.
* All methods and properties have been updated with nullability annotations.
* Added support for Carthage in addition to CocoaPods.
* PayPal One Touch is greatly improved in this release. It's slimmer and provides a better user experience, with browser switch on iOS 8 and SFSafariViewController on iOS 9.
* Added support for PayPal billing agreements (the New Vault Flow) and one-time payments.
* Drop-in is now part of the new BraintreeUI framework. BraintreeUI has been refactored for greater flexibility; it will automatically exclude any payment options that are not included in your build (as determined by CocoaPods subspecs or Carthage frameworks).
* Venmo One Touch has been excluded from this version. To join the beta for Pay with Venmo, contact Braintree Support.
* BTData has been renamed to BTDataCollector.
* BTPaymentMethod has been renamed to BTPaymentMethodNonce.

As always, feel free to [open an Issue](https://github.com/braintree/braintree_ios/issues/new) with any questions or suggestions that you have.

## 3.9.7 (2015-12-21)

* Ignore `UIAlertView` deprecation warning in `BTDropInErrorAlert`

## 3.9.6 (2015-10-08)

* Update Kount DeviceCollectorSDK to v2.6.2 to [fix #175](https://github.com/braintree/braintree_ios/issues/175) (thanks, @keith)

## 3.9.5 (2015-10-05)

* Add runtime checks before using new features in Apple Pay iOS 9
  * Bug in 3.9.4 caused `shippingContact`, `billingContact`, and `paymentMethod` to be used on < iOS 9 devices, which causes unrecognized selector crashes

## 3.9.4 (2015-09-25)

* :rotating_light: This version requires Xcode 7 and iOS SDK 9.0+
* Update README.md and Braintree Demo app for iOS 9 and Xcode 7
* Update PayPal mSDK to 2.12.1 with bitcode
* Update Kount library with bitcode support
* Update Apple Pay support for iOS 9. `BTApplePayPaymentMethod` changes:
  * Deprecate `ABRecordRef` properties: `billingAddress` and `shippingAddress`
  * Add `PKContact` properties: `billingContact` and `shippingContact`

## 3.9.2-pre6 (2015-08-28)
* PayPal
  * Fix canOpenUrl warnings in iOS9
* Added `PayerId` and `ClientMetadataId` to `BTPayPalPaymentMethod`

## 3.9.2-pre5 (2015-08-19)
* PayPal
  * Fix Billing Agreements support
  * Update PayPal One Touch Core

## 3.9.2-pre4 (2015-08-04)
* PayPal
  * Update support for PayPal Checkout
  * Add support for PayPal Billing Agreement authorization
  * Update PayPal One Touch Core

## 4.0.0-pre2 (2015-06-23)

* PayPal
  * For single payments, `BTPayPalPaymentMethod` now provides `firstName`, `lastName`, `phone`, `billingAddress`, and `shippingAddress` properties.
  * For future payments, add support for additional scopes.
  * Add demo for PayPal Checkout and scopes.
* Change @import to #import (#124).
* Add accessibility label to BTUICTAControl.

## 4.0.0-pre1

* Replace mSDK with One Touch Core
  * This replaces PayPal in-app login with browser switch for future payments consent
  * This adds the capability to perform checkout (single payments) with One Touch

## 3.9.3 (2015-08-31)

* Xcode 7 support
* Improved Swift interface with nullability annotations and lightweight generics
* Update PayPal mSDK to 2.11.4-bt1
  * Remove checking via canOpenURL:
* Bug fix for `BTPaymentButton` edge case where it choose the wrong payment option when the option availability changes after UI setup.

## 3.9.2 (2015-07-08)

* :rotating_light: This version requires Xcode 6.3+ (otherwise you'll get duplicate symbol errors)
* :rotating_light: New: `Accelerate.framework` must be linked to your project (CocoaPods should do this automatically)
* Remove Coinbase CocoaPods library as an external dependency
  * Integrating Coinbase SDK is no longer a prerequisite for manual integrations
  * No change to Braintree Coinbase support; existing integrations remain unaffected
  * Braintree iOS SDK now vendors Coinbase SDK
* Add session ID to analytics tracking data
* Add `BTPayPalScopeAddress`
* Update PayPal mSDK to 2.11.1-bt1
  * Requires Xcode 6.3+
  * Fix an iPad display issue
  * Improve mSDK screen blurring when app is backgrounded. NOTE: This change requires that you add `Accelerate.framework` to your project
  * Bug fixes

## 3.9.1 (2015-06-12)

* Add support for additional scopes during PayPal authorization
  * Specifically supporting the `address` scope
  * BTPayPalPaymentMethod now has a `billingAddress` property that is set when an address is present. This property is of type `BTPostalAddress`.

## 3.8.2 (2015-06-04)

* Fix bug in Demo app
  * Menu button now works correctly
* Fix bug with PayPal app switching
  * The bug occurred when installing a new app after the Braintree SDK had been initialized. When attempting to authorize with PayPal in this scenario, the SDK would switch to the `wallet` and launch the `in-app` authorization. 

## 3.8.1 (2015-05-22)

* 3D Secure only: :rotating_light: Breaking API Changes for 3D Secure :rotating_light:
  * Fix a bug in native mobile 3D Secure that, in some cases, prevented access to the new nonce.
  * Your delegate will now receive `-paymentMethodCreator:didCreatePaymentMethod:` even when liability shift is not possible and/or liability was not shifted.
  * You must check `threeDSecureInfo` to determine whether liability shift is possible and liability was shifted. This property is now of type `BTThreeDSecureInfo`. Example:

```objectivec
- (void)paymentMethodCreator:(__unused id)sender didCreatePaymentMethod:(BTPaymentMethod *)paymentMethod {

    if ([paymentMethod isKindOfClass:[BTCardPaymentMethod class]]) {
        BTCardPaymentMethod *cardPaymentMethod = (BTCardPaymentMethod *)paymentMethod;
        if (cardPaymentMethod.threeDSecureInfo.liabilityShiftPossible &&
            cardPaymentMethod.threeDSecureInfo.liabilityShifted) {

            NSLog(@"liability shift possible and liability shifted");

        } else {

            NSLog(@"3D Secure authentication was attempted but liability shift is not possible");

        }
    }
}
```

* Important: Since `cardPaymentMethod.threeDSecureInfo.liabilityShiftPossible` and `cardPaymentMethod.threeDSecureInfo.liabilityShifted` are client-side values, they should be used for UI flow only. They should not be trusted for your server-side risk assessment. To require 3D Secure in cases where the buyer's card is enrolled for 3D Secure, set the `required` option to `true` in your server integration. [See our 3D Secure docs for more details.](https://developers.braintreepayments.com/guides/3d-secure)

## 3.8.0 (2015-05-21)

* Work around iOS 8.0-8.2 bug in UITextField
  * Fix subtle bug in Drop-in and BTUICardFormView float label behavior
* It is now possible to set number, expiry, cvv and postal code field values programmatically in BTUICardFormView
  * This is useful for making the card form compatible with card.io

## 3.8.0-rc3 (2015-05-11)

* Upgrade PayPal mSDK to 2.10.1
* Revamp Demo app
* Merge with 3.7.x changes

## 3.8.0-rc2 (2015-04-20)

* Coinbase improvements
  * Resolved: Drop-in will now automatically save Coinbase accounts in the vault
  * Coinbase accounts now appear correctly in Drop-in
  * Expose method to disable Coinbase in Drop-in
* Demo app: Look sharp on iPhone 6 hi-res displays
* Modified `BTUIPayPalWordmarkVectorArtView`, `BTUIVenmoWordmarkVectorArtView` slightly to
  help logo alignment in `BTPaymentButton` and your payment buttons

## 3.8.0-rc1 (2015-04-03)

* Coinbase integration - beta release
  * Coinbase is now available in closed beta. See [the Coinbase page on our website](https://www.braintreepayments.com/features/coinbase) to join the beta.
  * Coinbase UI is integrated with Drop-in and BTPaymentButton
  * Known issue: Drop-in vaulting behavior for Coinbase accounts
* [Internal only] Introduced a new asynchronous initializer for creating the `Braintree` object

## 3.7.2 (2015-04-23)

* Bugfixes
  * Fix recognition of Discover, JCB, Maestro and Diners Club in certain cases ([Thanks, @RyPoints!](https://github.com/braintree/braintree_ios/pull/117))
  * Fix a bug in Drop-in that prevented Venmo from appearing if PayPal was disabled
  * Revise text for certain Venmo One Touch errors in Drop-in
  * Fix [compile error](https://github.com/braintree/braintree_ios/issues/106) that could occur when 'No Common Blocks' is Yes
* Demo app
  * Look sharp on iPhone 6 hi-res displays
  * Improve direct Apple Pay integration: use recommended tokenization method and handle Cancel gracefully
* Update tooling for Xcode 6.3
* Improve Apple Pay error handling
* Localization helpers now fall-back to [NSBundle mainBundle] if the expected i18n bundle resource is not found

## 3.7.1 (2015-03-27)

* Update PayPal Mobile SDK to new version (PayPal-iOS-SDK 2.8.5-bt1)
  * Change "Send Payment" button to simply "Pay"
  * Minor fixes
* Remove `en_UK` from Braintree-Demo-Info.plist (while keeping `en_GB`)
* Fix for Venmo button in BTPaymentButton [#103](https://github.com/braintree/braintree_ios/issues/103)
* Fix issue with wrapping text in Drop-in ([thanks nirinchev](https://github.com/braintree/braintree_ios/pull/107))
* Update [manual integration doc](Docs/Manual%20Integration.md)

## 3.7.0 (2015-03-02)

* Refactor and improve SSL Pinning code
* Update PayPal Mobile SDK to new version (PayPal-iOS-SDK 2.8.4-bt1) that does not include card.io.
  * :rotating_light: Please note! :rotating_light:  

      This change breaks builds that depend on a workaround introduced in 3.4.0 that added card.io headers to fix [card.io duplicate symbol issues](https://github.com/braintree/braintree_ios/issues/53). 

      Since card.io is not officially part of the Braintree API, and since the headers were only included as part of a workaround for use by a small group of developers, this potentially-breaking change is not accompanied by a major version release. 

      If your build breaks due to this change, you can re-add card.io to your project's Podfile: 

          pod 'CardIO', '~> 4.0'

      And adjust your card.io imports to:

          #import <CardIO/CardIO.h>

## 3.6.1 (2015-02-24)

* Fixes
  * Remove `GCC_TREAT_WARNINGS_AS_ERRORS` and `GCC_WARN_ABOUT_MISSING_NEWLINE` config from podspec.

## 3.6.0 (2015-02-20)

* Features
  * Beta support for native mobile 3D Secure
    * Requires additional import of a new subspec in your Podfile, `pod "Braintree/3d-secure"`
    * See `BTThreeDSecure` for full more details
  * Make Apple Pay a build option, enabled via `Braintree/Apple-Pay` subspec,
    which adds a `BT_ENABLE_APPLE_PAY=1` preprocesor macro.
    * Addresses an issue [reported by developers attempting to submit v.zero integrations without Apple Pay to the app store](https://github.com/braintree/braintree_ios/issues/60).
* Enhancements
  * Minor updates to UK localization
  * Expose a new `status` property on `BTPaymentProvider`, which exposes the current status of payment method creation (Thanks, @Reflejo!)
* Bug fixes
  * Fix swift build by making BTClient_Metadata.h private (https://github.com/braintree/braintree_ios/pull/84 and https://github.com/braintree/braintree_ios/pull/85)
  * Drop-in - Auto-correction and auto-capitalization improvements for postal code field in BTUICardFormView
  * Remove private header `BTClient_Metadata.h` from public headers
* Internal changes
  * Simplifications to API response parsing logic

## 3.5.0 (2014-12-03)

* Add localizations to UI and Drop-in subspecs:
  * Danish (`da`)
  * German (`de`)
  * Additional English locales (`en_AU`, `en_CA`, `en_UK`, `en_GB`)
  * Spanish (`es` and `es_ES`)
  * French (`fr`, `fr_CA`, `fr_FR`)
  * Hebrew (`he`)
  * Italian (`it`)
  * Norwegian (`nb`)
  * Dutch (`nl`)
  * Polish (`pl`)
  * Portugese (`pt`)
  * Russian (`ru`)
  * Swedish (`sv`)
  * Turkish (`tr`)
  * Chinese (`zh-Hans`)
* Add newlines to all files to support `GCC_WARN_ABOUT_MISSING_NEWLINE`

## 3.4.2 (2014-11-19)

* Upgrade PayPal Mobile SDK to version 2.7.1
  * Fixes symbol conflicts with 1Password
  * Upgrades embedded card.io library to version 3.10.1 

## 3.4.1 (2014-11-05)

* Bug fixes
  * Remove duplicate symbols with 1Password SDK by upgrading internal PayPal SDK

## 3.4.0 (2014-10-27)

* Features
  * Stable Apple Pay support
    * New method in `Braintree` for tokenizing a `PKPayment` into a nonce
      * This is useful for merchants who integrate with Apple Pay using `PassKit`, rather than `BTPaymentProvider`
    * `BTPaymentProvider` support for Apple Pay
    * `BTApplePayPaymentMethod` with nonce and address information
  * `BTData` now includes PayPal application correlation ID in device data blob
  * Card.IO headers are now included in SDK
  * In-App PayPal login now supports 1Password

* API Changes and Deprecations
  * `-[Braintree tokenizeCard:completion:]` and `-[BTClient saveCardWithRequest:success:failure:]` now take an extensible "request" object as an argument to pass the various raw card details:
    * The previous signatures that accepted raw details in the arguments are now deprecated.
    * These will be removed in the next major version (4.0.0).

* Integration
  * This SDK now officially supports integration without CocoaPods
    * Please see `docs/Manual Integration.md`
    * Report bugs with these new integration instructions via [Github](https://github.com/braintree/braintree_ios/issues/new)
  * Project Organization
    * All library code is now located under `/Braintree`

* Bug fixes
  * Fix a number of minor static analysis recommendations
  * Avoid potential nil-block crasher
  * Fix iOS 8 `CoreLocation` deprecation in `BTData`
  * Fix double-dismisal bug in presentation of in-app PayPal login in Drop-in

* New minimum requirements
  * Xcode 6+
  * Base SDK iOS 8+ (still compatible with iOS 7+ deployment target)

## 3.3.1 (2014-09-16)

* Enhancements
  * Update Kount library to 2.5.3, which removes use of IDFA
  * Use @import for system frameworks
* Fixes
  * Crasher in Drop-in that treats BTPaymentButton like a UIControl
  * Xcode 6 and iOS 8 deprecations
  * Bug in BTPaymentButton intrinsic size height calculation
  * Autolayout ambiguity in demo app

## 3.3.0 (2014-09-08)

* Features
  * App switch based payments for Venmo and PayPal ("One Touch")
    * New methods for registering a URL Scheme: `+[Braintree setReturnURLScheme:]` and `+[Braintree handleOpenURL:]`
      * PayPal continues to have a view controller option for in-app login
      * Both providers can be enabled via the Control Panel and client-side overrides
    * See [the docs](https://developers.braintreepayments.com/ios/guides/one-touch) for full upgrade instructions
  * Unified Payment Button (`BTPaymentButton`) for Venmo and/or PayPal payments
    * New UI and API designs for PayPal button
    * All new Venmo button
  * Unified mechanism for custom (headless) multi-provider payments (`BTPaymentProvider`)

* Enhancements
  * Minor fixes
  * Test improvements
  * Internal API tweaks
  * Update PayPal implementation to always support PayPal display email/phone across client and server
    * Your PayPal app (client ID) must now have the email scope capability. This is default for Braintree-provisioned PayPal apps. 
  * Improved Braintree-Demo app that demonstrates many integration styles
  * Upgraded underlying PayPal Mobile SDK

* Deprecations (For each item: deprecated functionality -> suggested replacement)
  * `BTPayPalButton` -> `BTPaymentButton`
  * `-[Braintree payPalButtonWithDelegate:]` -> `-[Braintree paymentButtonWithDelegate:]`
  * `BTPayPalButtonDelegate` -> `BTPaymentCreationDelegate`

* Known Issues
  * Crasher when app switching to Venmo and `CFBundleDisplayName` is unavailable.
    * Workaround: add a value for `CFBundleDisplayName` in your `Info.plist`

## 3.2.0 (2014-09-02)

* Update BTData (fraud) API to match Braintree-Data.js
  * New method `collectDeviceData` provides a device data format that is identical to the JSON generated by Braintree-Data.js
* Minor improvements to developer demo app (Braintree Demo)

## 3.1.3 (2014-08-22)

* Fix another PayPal payment method display issue in Drop-in UI

## 3.1.2 (2014-08-21)

* Fixes
  * Minor internationalization issue
  * PayPal payment method display issue in Drop-in UI

## 3.1.1 (2014-08-17)

* Enhancements
  * Accept four digit years in expiry field
  * Internationalize
  * Support iOS 8 SDK
* Integration changes
  * Merge `api` and `API` directory content
  * Deprecate `savePaypalPaymentMethodWithAuthCode:correlationId:success:failure` in favor of
    `savePaypalPaymentMethodWithAuthCode:applicationCorrelationID:success:failure`

## 3.1.0 (2014-07-22)

* Integration Change:
  * `Braintree/data` is no longer a default subspec. If you are currently using `BTData`, please add `pod "Braintree/data"` to your `Podfile`.

## 3.0.1 (2014-07-21)

* Enhancements
  * Add support for [PayPal Application Correlation ID](https://github.com/paypal/PayPal-iOS-SDK/blob/master/docs/future_payments_mobile.md#obtain-an-application-correlation-id)

## 3.0.0 (2014-07-09)

Initial release of 3.0.0

https://www.braintreepayments.com/v.zero

* Enhancements since rc8
  * Added details to DEVELOPMENT.md
  * Updated demo app to not use removed card properties
  * Updated PayPal acceptance tests

## 3.0.0-rc8

* Breaking Change
  * Renamed a method in `BTDropInViewControllerDelegate` to send
    cancelation messages to user. All errors within Drop-in are now
    handled internally with user interaction.
  * Removed completion block interface on `BTDropInViewController`
  * Removed crufty `BTMerchantIntegrationErrorUnknown` which was unused
* Enhancements
  * Added basic analytics instrumentation
  * Improved Drop-in's error handling
  * BTPayPalPaymentMethod now implements `NSMutableCopying`

## 3.0.0-rc7

* Breaking Change
  * Based on feedback from our beta developers, we have removed the block-based interfaces from
    Braintree and BTPayPalButton.
    * If you were previously relying on the completion block for receiving a payment method nonce,
      you should replace that code with a delegate method implementation which reads the nonce from
      the BTPaymentMethod object it receives.

* Bug fixes:
  * Fix Braintree/PayPal subspec build

## 3.0.0-rc6

* Bug fixes:
  * Fix issue with incorrect nesting of credit-card params in API requests, which caused
    incorrect behavior while validating credit cards in custom and Drop-in.
  * Bugfixes and improvements to demo app
  * Fix crasher in demo app when PayPal is not enabled
  * Demo App now points to a publicly accessible merchant server

* Enhancements:
  * Drop-in now supports server-side validation, including CVV/AVS verification failure
  * Drop-in's customer-facing error handling is now consistent and allows for retry
  * Increased robustness of API layer

* Features:
  * :new: `BTData` - Advanced fraud solution based on Kount SDK

## 3.0.0-rc5

* :rotating_light: Remove dependency on AFNetworking!
* :rotating_light: Rename `BTPayPalControl` -> `BTPayPalButton`.
* Security - Enforce SSL Pinning against a set of vendored SSL certificates
* Drop-in
  * Improve visual customizability and respect tint color
  * UI and Layout improvements
  * Detailing and polish
* UI
  * Float labels on credit card form fields
  * Vibration upon critical validation errors :vibration_mode:

Thanks for the feedback so far. Keep it coming!

## 3.0.0-rc4

* UX/UI improvements in card form and Drop-in
  * PayPal button and payment method view are full width
  * Vibration on invalid entry
  * Improved spinners and loading states
  * Detailing and polish
* Add support for v2 client tokens, which are base64 encoded
  * Reverse compatibility with v1 client tokens is still supported
* Clean up documentation

## 3.0.0-rc3

* Fix crashes when adding PayPal an additional payment method, when displaying PayPal as a payment method, and in offline mode
* Add `dropInViewControllerWillComplete` delegate method.
* Add transitions, activity indicators, and streamline some parts of UI.
* Simplify implementation of `BTPayPalButton`.
* :rotating_light: Remove `BTDropInViewController shouldDisplayPaymentMethodsOnFile` property.

## 3.0.0-rc2

* :rotating_light: Breaking API Changes :rotating_light:
    * Reduce BTPayPalButton API
    * Rename a number of classes, methods, and files, e.g. `BTCard` -> `BTCardPaymentMethod`.

## 3.0.0-rc1

* First release candidate of the 3.0.0 version of the iOS SDK.
* Known issues:
    * Pre-release public APIs
    * SSL pinning not yet added
    * Incomplete / unpolished UI
        * Minor UX card validation issues in the card form
        * Drop-in UX flow issues and unaddressed edge cases

