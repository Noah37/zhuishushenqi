#
# Be sure to run `pod lib lint ZSBaseUIExt.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZSBaseUIExt'
  s.version          = '1.0.15'
  s.summary          = 'ZSBaseUIExt.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
zhuishushenqi baseui module.
                       DESC

  s.homepage         = 'https://github.com/zssq/ZSBaseUIExt'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '2252055382@qq.com' => 'norycao' }
  s.source           = { :git => 'https://github.com/zssq/ZSBaseUIExt.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/norycao'

  s.ios.deployment_target = '9.0'
  
  s.swift_version = '5.0'

  s.source_files = 'ZSBaseUIExt/Classes/**/*'
  
   s.resource_bundles = {
     'ZSBaseUIExt' => ['ZSBaseUIExt/Assets/*.png']
   }
   
#   s.vendored_libraries = 'ZSBaseUIExt/Classes/**/**/*.a'
#   s.vendored_libraries = 'ZSBaseUIExt/Classes/ThirdLoginSDK/WeChatSDK1.8.3/*.a'
#s.vendored_frameworks = 'ZSBaseUIExt/Classes/ZSThirdPartSDK.framework',
#   'ZSBaseUIExt/Classes/Alamofire.framework',
#    'ZSBaseUIExt/Classes/Alamofire.framework',
#    'ZSBaseUIExt/Classes/HandyJSON.framework',
#    'ZSBaseUIExt/Classes/Kingfisher.framework',
#    #'ZSBaseUIExt/Classes/MBProgressHUD.framework',
#    'ZSBaseUIExt/Classes/PKHUD.framework',
#    'ZSBaseUIExt/Classes/SQLite.framework',
#    #'ZSBaseUIExt/Classes/YYCategories.framework',
#    'ZSBaseUIExt/Classes/ZSAPI.framework',
#    #'ZSBaseUIExt/Classes/ZSAppConfig.framework',    #'ZSBaseUIExt/Classes/ZSExtension.framework'


#s.frameworks = 'UIKit', 'SystemConfiguration', 'Security', 'CoreTelephony', 'CFNetwork', 'CoreGraphics', 'CoreText', 'QuartzCore', 'ImageIO', 'Photos'
#s.libraries = 'z', 'sqlite3.0', 'c++'

#s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
s.dependency 'ZSThirdPartSDK'
s.dependency 'RxCocoa'
s.dependency 'RxSwift'
s.dependency 'Then'
s.dependency 'YYCategories'
s.dependency 'MJRefresh'
s.dependency 'ZSAPI'
s.dependency 'HandyJSON'
s.dependency 'Alamofire'
s.dependency 'Kingfisher'
s.dependency 'PKHUD'
s.dependency 'SQLite.swift'
s.dependency 'Alamofire'
s.dependency 'ZSExtension'
s.dependency 'ZSAppConfig'
s.dependency 'SnapKit'
s.dependency 'YYImage'


end
