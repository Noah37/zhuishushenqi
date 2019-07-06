//
//  Network.swift
//  iflyDemo
//
//  Created by caony on 2018/9/19.
//  Copyright © 2018年 QSH. All rights reserved.
//

import Foundation
import Alamofire
import Zip

public typealias NetworkHandler<T> = (T?)->Void

//let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")/speakerres/3589709422/"

func download(urlString:String, handler:NetworkHandler<Any>?) {
    let pathURL = URL(fileURLWithPath: filePath, isDirectory: true)
    do {
        try FileManager.default.createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print(error)
    }
    let fileName = (urlString as NSString).lastPathComponent
    let fileURL = pathURL.appendingPathComponent(fileName)
    let destination: DownloadRequest.DownloadFileDestination = { temporaryURL, _ in
        
        return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
    }
    download(urlString, to: destination).response { (response) in
        if let error = response.error {
            handler?(error)
        } else {
            
            handler?(response.destinationURL)
        }
    }
    
}

func unzip(fileURL:URL) {
    do {
        let documentsDirectory = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0].appendingPathComponent("/speakerres/3589709422/", isDirectory: true)
        try Zip.unzipFile(fileURL, destination: documentsDirectory, overwrite: true, password: nil, progress: { (progress) -> () in
            print(progress)
        }) // Unzip
    }
    catch {
        print("Something went wrong")
    }
}
