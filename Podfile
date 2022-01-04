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

# DoraemonKit不支持模拟器
#pod 'DoraemonKit/Core', '~> 3.0.4', :configurations => ['Debug'] #必选
#pod 'DoraemonKit/WithGPS', '~> 3.0.4', :configurations => ['Debug'] #可选
#pod 'DoraemonKit/WithLoad', '~> 3.0.4', :configurations => ['Debug'] #可选
#pod 'DoraemonKit/WithLogger', '~> 3.0.4', :configurations => ['Debug'] #可选
#pod 'DoraemonKit/WithDatabase', '~> 3.0.4', :configurations => ['Debug'] #可选
#pod 'DoraemonKit/WithMLeaksFinder', '~> 3.0.4', :configurations => ['Debug'] #可选
#pod 'DoraemonKit/WithWeex', '~> 3.0.4', :configurations => ['Debug'] #可选

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
pod 'RCBacktrace', '~> 0.1.6'
pod 'Google-Mobile-Ads-SDK','~> 7.69'
pod 'Ads-CN'
pod 'YungCache', :git => 'https://github.com/Noah37/YungCache.git'
pod 'YungNetworkTool', :git => 'https://github.com/Noah37/YungNetworkTool.git'

# local pods
pod 'ZSAPI', :path => "zhuishushenqi/NewVersion/ZSAPI"
pod 'ZSAppConfig', :path => "zhuishushenqi/NewVersion/ZSAppConfig"
pod 'ZSExtension', :path => "zhuishushenqi/NewVersion/ZSExtension"

end

post_install do |installer|

  ## Fix for XCode 12.5
  find_and_replace("Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm",
                      "layoutCache[currentClass] = ivars;", "layoutCache[(id<NSCopying>)currentClass] = ivars;")
    
#  installer.pods_project.targets.each do |target|
#    # 我們也可以懶惰不用 if，讓所有 pod 的版本都設為一樣的
#    target.build_configurations.each do |config|
#      config.build_settings['SWIFT_VERSION'] = '5.0'
#    end
    
#    if ['RxSwift', 'RxSwiftExt', 'RxCocoa', 'RxDataSources', 'ProtocolBuffers-Swift'].include? target.name
#    end
#  end
end

def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
      text = File.read(name)
      replace = text.gsub(findstr,replacestr)
      if text != replace
          puts "Fix: " + name
          File.open(name, "w") { |file| file.puts replace }
          STDOUT.flush
      end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end
