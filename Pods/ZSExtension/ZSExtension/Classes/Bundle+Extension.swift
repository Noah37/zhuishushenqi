//
//  Bundle+Extension.swift
//  ZSExtension
//
//  Created by caony on 2019/6/20.
//

import Foundation

extension Bundle {
    public func imageBundle(for cls:AnyClass) ->Bundle? {
        if let bundlePath = imageBundlePath(for: cls) {
            return Bundle(path: bundlePath)
        }
        return nil
    }
    
    public func imageBundlePath(for cls:AnyClass) ->String? {
        let bundle = Bundle.init(for: cls)
        guard let info = bundle.infoDictionary else { return nil }
        guard let executableName = info[kCFBundleExecutableKey as String] else { return nil }
        var bundlePath = bundle.resourcePath ?? ""
        bundlePath = bundlePath.appending("/\(executableName).bundle")
        return bundlePath
    }
}
