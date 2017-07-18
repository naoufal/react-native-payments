# This podspec is here to add BraintreeDropIn to the demo without including the dependencies on Braintree
Pod::Spec.new do |s|
  s.name             = "BraintreeDropIn"
  s.version          = "99.99.99-github-master"
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
  s.source           = { :git => "https://github.com/braintree/braintree-ios-drop-in.git", :branch => 'master' }
  s.social_media_url = "https://twitter.com/braintree"

  s.platform         = :ios, "9.0"
  s.requires_arc     = true
  s.compiler_flags = "-Wall -Werror -Wextra"

  s.subspec "DropIn" do |sub|
    sub.source_files  = "BraintreeDropIn/**/*.{h,m}"
    sub.public_header_files = "BraintreeDropIn/Public/*.h"
    sub.frameworks = "UIKit"
    sub.dependency "BraintreeDropIn/UIKit"
  end

  s.subspec "UIKit" do |sub|
    sub.source_files  = "BraintreeUIKit/**/*.{h,m}"
    sub.public_header_files = "BraintreeUIKit/Public/*.h"
    sub.frameworks = "UIKit"
    sub.resource_bundles = {
      "Braintree-UIKit-Localization" => ["BraintreeUIKit/Localization/*.lproj"] }
  end
end

