source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/sinaweibosdk/weibo_ios_sdk.git'

# 对于Swift应用来说下面两句是必须的
platform :ios, '10.0'
use_frameworks!
# Swift静态库方式
#use_modular_headers!
inhibit_all_warnings!
branch = ENV['sha']

# target的名字一般与你的项目名字相同
target 'zhuishushenqi' do
project './zhuishushenqi.xcodeproj'

pod 'YYText'
pod 'YYModel'
pod 'YYImage'
pod 'MBProgressHUD'
pod 'MJRefresh'
pod 'CocoaAsyncSocket'
pod 'CocoaLumberjack', '3.4.2'
pod 'YYCategories'
pod 'FMDB'
pod 'WechatOpenSDK', '1.8.3'
pod "Weibo_SDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
pod 'FLEX', :configurations => ['Debug']
pod 'MLeaksFinder'
pod 'FBRetainCycleDetector'

# swift libraries
pod 'Alamofire'
pod 'Cache'
pod 'HandyJSON'
#pod 'Kingfisher'
pod 'PKHUD'
pod 'SnapKit', '5.0.0'
pod 'SQLite.swift'
#pod 'Then'
pod 'Zip'
pod 'RxAlamofire'
pod 'RxCocoa'
pod 'UICircularProgressRing'
pod 'YungCache', :git => 'https://github.com/Noah37/YungCache.git'
pod 'YungNetworkTool', :git => 'https://github.com/Noah37/YungNetworkTool.git'

# local pods
pod 'ZSAPI', :path => "zhuishushenqi/NewVersion/ZSAPI"
pod 'ZSAppConfig', :path => "zhuishushenqi/NewVersion/ZSAppConfig"
pod 'ZSExtension', :path => "zhuishushenqi/NewVersion/ZSExtension"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    # 我們也可以懶惰不用 if，讓所有 pod 的版本都設為一樣的
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
    
#    if ['RxSwift', 'RxSwiftExt', 'RxCocoa', 'RxDataSources', 'ProtocolBuffers-Swift'].include? target.name
#    end
  end
end
