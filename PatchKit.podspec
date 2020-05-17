#
#  Be sure to run `pod spec lint PatchKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "PatchKit"
  spec.version      = "0.0.1"
  spec.summary      = "A lightweight iOS plugin for in-app bug reports, feature requests, and customer service"

  spec.homepage     = "https://github.com/cuappdev/chat-ios"
  spec.license      = "MIT"
  spec.author       = { "Cornell AppDev" => "team@cornellappdev.com" }
  spec.platform     = :ios, "13.0"
  spec.swift_version = "5.0"
  
  spec.source       = { :git => "https://github.com/cuappdev/chat-ios.git", :tag => "#{spec.version}" }
  spec.source_files  = "SupportClient/SupportClient/**/*.swift"
  
  spec.static_framework = true
  spec.frameworks = "Foudation", "UIKit"
  
  spec.dependency "BSImagePicker", "~> 3.1"
  spec.dependency "Firebase/Firestore"
  spec.dependency "Firebase/Storage"
  spec.dependency "FirebaseCore"
  spec.dependency "FirebaseCoreDiagnostics"
  spec.dependency "FirebaseFirestore"
  spec.dependency "FirebaseFirestoreSwift"
  spec.dependency "FirebaseStorage"
  spec.dependency "GoogleDataTransport"
  spec.dependency "GoogleDataTransportCCTSupport"

end
