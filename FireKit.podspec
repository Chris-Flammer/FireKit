Pod::Spec.new do |s|
 s.name         = "FireKit"
  s.version      = "0.0.1"
  s.summary      = "A set of helper objects to synchronize Firebase data with UIKit controls."
  s.homepage     = "https://github.com/davideast/FireKit"
  s.license      = "MIT"
  s.author             = { "David East" => "david@firebase.com" }
  s.social_media_url   = "http://twitter.com/_davideast"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/davideast/FireKit.git", :tag => s.version }
  s.source_files = '*.swift'
  s.framework  = "UIKit"
  s.requires_arc = true
  s.dependency 'Firebase', '~> 2.3'
end
