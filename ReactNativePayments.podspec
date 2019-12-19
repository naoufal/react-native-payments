require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
version = package["version"]
giturl = package["repository"]

Pod::Spec.new do |s|
  s.name         = "ReactNativePayments"
  s.version      = package["version"]
  s.summary      = "react-native-payments"
  s.description  = <<-DESC
                  Native Payments (Google and Apple Pay) from React-Native
                   DESC
  s.homepage     = giturl
  s.license      = "MIT"
  s.authors      = "Naoufal Kadhom", "Andrej Badin"
  s.platform     = :ios, '9.2'
  s.source       = { :git => "https://github.com/naoufal/react-native-payments.git", :tag => "#{s.version}" }
  s.source_files  = 'lib/ios/*.{h,m}'
  s.requires_arc = true

  s.dependency "React"

end
