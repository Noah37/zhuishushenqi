#
# Be sure to run `pod lib lint ZSExtension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZSExtension'
  s.version          = '1.0.15'
  s.summary          = 'ZSExtension.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
zhuishushenqi baseui module.
                       DESC

  s.homepage         = 'https://github.com/zssq/ZSExtension'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '2252055382@qq.com' => 'norycao' }
  s.source           = { :git => 'https://github.com/zssq/ZSExtension.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/norycao'

  s.ios.deployment_target = '10.0'
  
  s.swift_version = '5.0'

  s.source_files = 'ZSExtension/Classes/**/*'
  
   s.resource_bundles = {
     'ZSExtension' => ['ZSExtension/Assets/*.png']
   }

#s.frameworks = 'UIKit', 'SystemConfiguration', 'Security', 'CoreTelephony', 'CFNetwork', 'CoreGraphics', 'CoreText', 'QuartzCore', 'ImageIO', 'Photos'
#s.libraries = 'z', 'sqlite3.0', 'c++'

#s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency "Alamofire"
  s.dependency "SQLite.swift"
  s.dependency "PKHUD"
  s.dependency "MBProgressHUD"
  s.dependency "ZSAppConfig"
  s.dependency "Zip"
  s.dependency "HandyJSON"
  s.dependency "Kingfisher"
  s.dependency "YYCategories"
end
