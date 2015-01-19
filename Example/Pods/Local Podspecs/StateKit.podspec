#
# Be sure to run `pod lib lint StateKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "StateKit"
  s.version          = "0.1.0"
  s.summary          = "StateKit is a StateChart written for iOS/MacOSX Development"
  s.description      = <<-DESC
                       StateKit is a framework to model, capture, manipulate and interact with State.

                       StateKit models state in the form of a tree. 
                       This is different from a Finite State Machine (FSM) that models state as a graph
                       DESC
  s.homepage         = "https://github.com/sghiassy/StateKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Shaheen Ghiassy" => "shaheen@groupon.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/StateKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'StateKit' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
