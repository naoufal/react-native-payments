require "json"

package = JSON.parse(File.read(File.join(__dir__, "../../package.json")))
version = package["version"]
giturl = package["repository"]

Pod::Spec.new do |s|
  s.name         = "ReactNativePayments"
  s.version      = version
  s.summary      = "react-native-payments"
  s.description  = <<-DESC
                  Native Payments (Google and Apple Pay) from React-Native
                   DESC
  s.homepage     = giturl
  s.license      = "MIT"
  s.author       = "Naoufal Kadhom"
  s.platform     = :ios, "7.0"
  s.source       = { :git => giturl + ".git", :tag => version }
  s.source_files  = "*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end
