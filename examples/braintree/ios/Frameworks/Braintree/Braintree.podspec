Pod::Spec.new do |s|
  s.name             = "Braintree"
  s.version          = "4.8.4"
  s.summary          = "Braintree v.zero: A modern foundation for accepting payments"
  s.description      = <<-DESC
                       Braintree is a full-stack payments platform for developers

                       This CocoaPod will help you accept payments in your iOS app.

                       Check out our development portal at https://developers.braintreepayments.com.
  DESC
  s.homepage         = "https://www.braintreepayments.com/how-braintree-works"
  s.documentation_url = "https://developers.braintreepayments.com/ios/start/hello-client"
  s.screenshots      = "https://raw.githubusercontent.com/braintree/braintree_ios/master/screenshot.png"
  s.license          = "MIT"
  s.author           = { "Braintree" => "code@getbraintree.com" }
  s.source           = { :git => "https://github.com/braintree/braintree_ios.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/braintree"

  s.platform         = :ios, "7.0"
  s.requires_arc     = true
  s.compiler_flags = "-Wall -Werror -Wextra"

  s.default_subspecs = %w[Core Card PayPal UI]

  s.subspec "Core" do |s|
    s.source_files  = "BraintreeCore/**/*.{h,m}"
    s.public_header_files = "BraintreeCore/Public/*.h"
    s.frameworks = "AddressBook"
    s.weak_frameworks = "Contacts"
  end

  s.subspec "Apple-Pay" do |s|
    s.source_files  = "BraintreeApplePay/**/*.{h,m}"
    s.public_header_files = "BraintreeApplePay/Public/*.h"
    s.dependency "Braintree/Core"
    s.frameworks = "PassKit"
  end

  s.subspec "Card" do |s|
    s.source_files  = "BraintreeCard/**/*.{h,m}"
    s.public_header_files = "BraintreeCard/Public/*.h"
    s.dependency "Braintree/Core"
  end

  s.subspec "DataCollector" do |s|
    s.source_files = "BraintreeDataCollector/**/*.{h,m}"
    s.public_header_files = "BraintreeDataCollector/Public/*.h"
    s.vendored_library = "BraintreeDataCollector/Kount/libDeviceCollectorLibrary.a"
    s.dependency "Braintree/Core"
  end

  s.subspec "PayPal" do |s|
    s.source_files = "BraintreePayPal/*.{h,m}", "BraintreePayPal/Public/*.h"
    s.public_header_files = "BraintreePayPal/Public/*.h"
    s.dependency "Braintree/Core"
    s.dependency "Braintree/PayPalOneTouch"
  end

  s.subspec "Venmo" do |s|
    s.source_files = "BraintreeVenmo/**/*.{h,m}"
    s.public_header_files = "BraintreeVenmo/Public/*.h"
    s.dependency "Braintree/Core"
    s.dependency "Braintree/PayPalDataCollector"
  end

  s.subspec "UI" do |s|
    s.source_files  = "BraintreeUI/**/*.{h,m}"
    s.public_header_files = "BraintreeUI/Public/*.h"
    s.frameworks = "UIKit"
    s.resource_bundles = {
      "Braintree-UI-Localization" => ["BraintreeUI/Localization/*.lproj"],
      "Braintree-Drop-In-Localization" => ["BraintreeUI/Drop-In/Localization/*.lproj"] }
    s.dependency "Braintree/Card"
    s.dependency "Braintree/Core"
  end

  s.subspec "UnionPay" do |s|
    s.source_files  = "BraintreeUnionPay/**/*.{h,m}"
    s.public_header_files = "BraintreeUnionPay/Public/*.h"
    s.frameworks = "UIKit"
    s.dependency "Braintree/Card"
    s.dependency "Braintree/Core"
  end

  s.subspec "3D-Secure" do |s|
    s.source_files = "Braintree3DSecure/**/*.{h,m}"
    s.public_header_files = "Braintree3DSecure/Public/*.h"
    s.frameworks = "UIKit"
    s.dependency "Braintree/Card"
    s.dependency "Braintree/Core"
    s.resource_bundle = { "Braintree-3D-Secure-Localization" => "Braintree3DSecure/Localization/*.lproj" }
  end

  s.subspec "PayPalOneTouch" do |s|
    s.source_files = "BraintreePayPal/PayPalOneTouch/**/*.{h,m}"
    s.public_header_files = "BraintreePayPal/PayPalOneTouch/Public/*.h"
    s.frameworks = "UIKit"
    s.weak_frameworks = "SafariServices"
    s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC -lc++" }
    s.dependency "Braintree/Core"
    s.dependency "Braintree/PayPalDataCollector"
    s.dependency "Braintree/PayPalUtils"
  end

  s.subspec "PayPalDataCollector" do |s|
    s.source_files = "BraintreePayPal/PayPalDataCollector/**/*.{h,m}"
    s.public_header_files = "BraintreePayPal/PayPalDataCollector/Public/*.h", "BraintreePayPal/PayPalDataCollector/Risk/*.h"
    s.frameworks = "MessageUI", "SystemConfiguration", "CoreLocation", "UIKit"
    s.vendored_library = "BraintreePayPal/PayPalDataCollector/Risk/libPPRiskComponent.a"
    s.dependency "Braintree/Core"
    s.dependency "Braintree/PayPalUtils"
  end

  s.subspec "PayPalUtils" do |s|
    s.source_files = "BraintreePayPal/PayPalUtils/**/*.{h,m}"
    s.public_header_files = "BraintreePayPal/PayPalUtils/Public/*.h"
    s.frameworks = "MessageUI", "SystemConfiguration", "CoreLocation", "UIKit"
  end
end

