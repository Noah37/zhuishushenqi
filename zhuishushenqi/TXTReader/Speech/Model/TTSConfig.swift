//
//  TTSConfig.swift
//  iflyDemo
//
//  Created by caony on 2018/9/18.
//  Copyright © 2018年 QSH. All rights reserved.
//

import Foundation

let filePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")/speakerres/3589709422/"

public class TTSConfig {
    
    var speed:String = "50"
    var volume:String = "50"
    var pitch:String = "50"
    var sampleRate:String = "16000"
    var vcnName:String = "xiaoyan"
    // the engine type of Text-to-Speech:"auto","local","cloud"
    var engineType:String = "cloud"
    
    var voiceID:String = "51200"
    
    var ent:String = ""
    
    var ttsPath:String = ""
    
    var next_text_len:Int = 0
    var next_text:String = ""
    
    var speakerPath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/speakerres/3589709422/xiaoyan.jet"
    var commonPath = "\(Bundle.main.resourcePath ?? "")/TTSResource/common.jet"
    
    var fileName:String = "tts.pcm"
    
    let tts_res_path = "tts_res_path"
    let unicode = "unicode"
    
    private init() {}
    static var share = TTSConfig()
    
    var allSpeakers:[Speaker] = []
    
    func availableSpeakers() ->[Speaker] {
        let files = (try? FileManager.default.contentsOfDirectory(atPath: filePath)) ?? []
        var jets:[String] = []
        for file in files {
            let jet = (file as NSString).lastPathComponent.contains(".jet")
            if jet {
                jets.append(file)
            }
        }
        var speakers:[Speaker] = []
        for jet in jets {
            let file = (jet as NSString).lastPathComponent
            let fileArr = file.components(separatedBy: ".")
            if fileArr.count > 1 {
                 let name = fileArr[0]
                for speak in allSpeakers {
                    if speak.name == name {
                        speakers.append(speak)
                    }
                }
            }
        }
        return speakers
    }
    
    func getSpeakers() {
        ZSBookManager.calTime {
            let filePath = Bundle.main.path(forResource: "speakers.plist", ofType: nil) ?? ""
            if let dict = NSDictionary(contentsOfFile: filePath) {
                if let speakers = dict["speakers"] as? [Any] {
                    if let models = [Speaker].deserialize(from: speakers) as? [Speaker] {
                        self.allSpeakers = models
                    }
                }
            }
        }
        print("")
    }
    
    func parseJSONFile(path:String) ->[Speaker] {
        var models:[Speaker] = []
        ZSBookManager.calTime {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe) {
                let str = String(data: data, encoding: .utf8) ?? ""
                
                if let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    if let dict = obj as? [String:Any] {
//                        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
//
//                        dict.write(toFile: "\(filePath)/speakers.plist", atomically: true)
                        if let speakers = dict["speakers"] as? [Any] {
                            if let speakersModel = [Speaker].deserialize(from: speakers) as? [Speaker] {
                                models = speakersModel
                            }
                        }
                    }
                }
            }
        }
        return models
    }
}
