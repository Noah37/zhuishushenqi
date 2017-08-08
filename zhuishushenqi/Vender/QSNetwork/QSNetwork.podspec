#
#  Be sure to run `pod spec lint QSNetwork.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name         = "QSNetwork"
s.version      = "0.0.1"
s.summary      = "a network tool"
s.homepage     = 'https://github.com/NoryCao/'
s.license      = 'MIT'
s.author       = { 'albertjson ' => 'https://github.com/NoryCao' }
s.platform     = :ios
s.source       = { :git => "../QSNetwork" }
s.source_files  = '**/*.{h,m,swift}'
end
