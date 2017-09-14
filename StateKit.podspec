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
  s.version          = "0.2.0"
  s.summary          = "StateKit is a StateChart written for iOS/MacOSX/tvOS/watchOS Development"
  s.description      = <<-DESC
                       StateKit is a framework to model, capture, manipulate and interact with State.

                       StateKit models state in the form of a tree.
                       This is different from a Finite State Machine (FSM) that models state as a graph
                       DESC
  s.homepage         = "https://github.com/sghiassy/StateKit"
  s.license          = 'MIT'
  s.author           = { "Shaheen Ghiassy" => "shaheen@groupon.com" }
  s.source           = { :git => "https://github.com/sghiassy/StateKit.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

end
