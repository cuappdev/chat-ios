#
# Be sure to run `pod lib lint PatchKt.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = 'PatchKit'
  s.version      = '0.0.1'
  s.summary      = 'A lightweight iOS plugin for in-app bug reports, feature requests, and customer service'


# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'Testing'
                       DESC

  s.homepage     = 'https://github.com/cuappdev/chat-ios'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Cornell AppDev' => 'team@cornellappdev.com' }
  # s.platform     = :ios, "13.0"
  s.ios.deployment_target = '13.2'
  # s.swift_version = '5.0'
  
  s.source       = { :git => "https://github.com/cuappdev/chat-ios.git", :tag => "#{s.version}" }
  s.source_files  = 'SupportClient/SupportClient/**/*'
  
  # s.static_framework = true
  s.frameworks = "Foudation", "UIKit"
  
  s.dependency "BSImagePicker", "~> 3.1"
  s.dependency "Firebase/Firestore"
  s.dependency "Firebase/Storage"
  s.dependency "FirebaseCore"
  s.dependency "FirebaseCoreDiagnostics"
  s.dependency "FirebaseFirestore"
  s.dependency "FirebaseFirestoreSwift"
  s.dependency "FirebaseStorage"
  s.dependency "GoogleDataTransport"
  s.dependency "GoogleDataTransportCCTSupport"

end
