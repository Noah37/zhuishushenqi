//
//  VoiceBook.swift
//  iflyDemo
//
//  Created by caony on 2018/9/18.
//  Copyright © 2018年 QSH. All rights reserved.
//

import Foundation

typealias VoiceBookHandler<T> = (T?)->Void

class VoiceBook:NSObject {
    
    private var iflySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance()
    private var audioPlayer = PcmPlayer()
    
    public var config:TTSConfig = TTSConfig.share
    
    public var beginHandler:VoiceBookHandler<Void>?
    
    public var completeHandler:VoiceBookHandler<IFlySpeechError>?
    
    public var bufferProgress:VoiceBookHandler<Int32>?
    
    public var speakProgress:VoiceBookHandler<Int32>?
    
    public var speakCancel:VoiceBookHandler<Void>?
    
    public var speakResume:VoiceBookHandler<Void>?
    
    public var speakPause:VoiceBookHandler<Void>?
    
    private let zhuishushenqi = "566551f4"
    
    public var text:String = "科大讯飞作为中国最大的智能语音技术提供商，在智能语音技术领域有着长期的研究积累、并在中文语音合成、语音识别、口语评测等多项技术上拥有国际领先的成果。科大讯飞是我国唯一以语音技术为产业化方向的“国家863计划成果产业化基地”、“国家规划布局内重点软件企业”、“国家火炬计划重点高新技术企业”、“国家高技术产业化示范工程”，并被信息产业部确定为中文语音交互技术标准工作组组长单位，牵头制定中文语音技术标准。2003年，科大讯飞获迄今中国语音产业唯一的“国家科技进步奖（二等）”，2005年获中国信息产业自主创新最高荣誉“信息产业重大技术发明奖”。2006年至2009年，连续四届英文语音合成国际大赛（Blizzard Challenge）荣获第一名。2008年获国际说话人识别评测大赛（美国国家标准技术研究院—NIST 2008）桂冠，2009年获得国际语种识别评测大赛（NIST 2009）高难度混淆方言测试指标冠军、通用测试指标亚军。"
    
    override init() {
        super.init()
        iflySpeechSynthesizer?.delegate = self
    }

    private func setupSpeech() {
        
        iflySpeechSynthesizer?.setParameter(config.engineType, forKey: IFlySpeechConstant.engine_TYPE())
        iflySpeechSynthesizer?.setParameter(config.speed, forKey: IFlySpeechConstant.speed())
        iflySpeechSynthesizer?.setParameter(config.fileName, forKey: IFlySpeechConstant.tts_AUDIO_PATH())
        iflySpeechSynthesizer?.setParameter(config.volume, forKey: IFlySpeechConstant.volume())
        iflySpeechSynthesizer?.setParameter(config.pitch, forKey: IFlySpeechConstant.pitch())
        iflySpeechSynthesizer?.setParameter(config.sampleRate, forKey: IFlySpeechConstant.sample_RATE())
        iflySpeechSynthesizer?.setParameter(config.vcnName, forKey: IFlySpeechConstant.voice_NAME())
        iflySpeechSynthesizer?.setParameter("unicode", forKey: IFlySpeechConstant.text_ENCODING())
        
    }
    
    private func setupLocalSpeech() {
        //设置协议委托对象
        //设置语音合成的启动参数
//        IFlySpeechUtility.getUtility()?.setParameter("tts", forKey: IFlyResourceUtil.engine_START())
        iflySpeechSynthesizer?.setParameter("\(config.commonPath);\(config.speakerPath)", forKey: config.tts_res_path)
        let xfyj2 = "591a4d99"
        iflySpeechSynthesizer?.setParameter(xfyj2, forKey: "caller.appid")
//        domain=iat,language=en_us
//        iflySpeechSynthesizer?.setParameter("iat", forKey: "domain")
//        iflySpeechSynthesizer?.setParameter("zh_cn", forKey: "language")
//        iflySpeechSynthesizer?.setParameter("cantonese", forKey: IFlySpeechConstant.accent())
        iflySpeechSynthesizer?.setParameter(config.ent, forKey: "ent")
iflySpeechSynthesizer?.setParameter("http://yuji.xf-yun.com/msp.do", forKey: "server_url")
        //设置本地引擎类型
       iflySpeechSynthesizer?.setParameter(config.voiceID, forKey:IFlySpeechConstant.voice_ID())
//        iflySpeechSynthesizer?.setParameter("http://yuji.xf-yun.com/msp.do", forKey: "server_url")
        iflySpeechSynthesizer?.setParameter(IFlySpeechConstant.type_LOCAL(), forKey: IFlySpeechConstant.engine_TYPE())
        iflySpeechSynthesizer?.setParameter(config.speed, forKey: IFlySpeechConstant.speed())
        iflySpeechSynthesizer?.setParameter(config.fileName, forKey: IFlySpeechConstant.tts_AUDIO_PATH())
        iflySpeechSynthesizer?.setParameter(config.volume, forKey: IFlySpeechConstant.volume())
        iflySpeechSynthesizer?.setParameter(config.pitch, forKey: IFlySpeechConstant.pitch())
        iflySpeechSynthesizer?.setParameter(config.sampleRate, forKey: IFlySpeechConstant.sample_RATE())
        iflySpeechSynthesizer?.setParameter(config.vcnName, forKey: IFlySpeechConstant.voice_NAME())
        iflySpeechSynthesizer?.setParameter(config.unicode, forKey: IFlySpeechConstant.text_ENCODING())
        // 设置发音人
        iflySpeechSynthesizer?.setParameter(config.vcnName, forKey: IFlySpeechConstant.voice_NAME())
//        NSString *newResPath = [[NSString alloc] initWithFormat:@"%@/aisound/common.jet;%@/aisound/xiaoyan.jet",resPath,resPath];
        
        iflySpeechSynthesizer?.setParameter("\(config.next_text_len)", forKey: "next_text_len")
        iflySpeechSynthesizer?.setParameter("\(config.next_text)", forKey: "next_text")

    }
    
    /// 开始朗读
    public func start(sentence:String) {
        let isSpeaking = iflySpeechSynthesizer?.isSpeaking
        if isSpeaking! {
            iflySpeechSynthesizer?.stopSpeaking()
        }
        // start之前设置的config有效
//        setupSpeech()
        iflySpeechSynthesizer?.startSpeaking(sentence)
    }
    
    public func stop() {
        iflySpeechSynthesizer?.stopSpeaking()
    }
    
    /// 恢复朗读
    public func resume() {
        iflySpeechSynthesizer?.resumeSpeaking()
    }
    
    /// 暂停朗读
    public func pause() {
        iflySpeechSynthesizer?.pauseSpeaking()
    }
    
    /// 保存音频文件
    public func saveUri() {
        let path = uriPath()
        iflySpeechSynthesizer?.delegate = self
        iflySpeechSynthesizer?.synthesize(text, toUri: path)
    }
    
    /// 是否正在语音
    public func isSpeaking() ->Bool {
        return iflySpeechSynthesizer?.isSpeaking ?? false
    }
    
    /// 播放本地保存的音频文件
    public func playUri() {
        
        let path = uriPath()
        let exist = FileManager.default.fileExists(atPath: path)
        if exist {
//            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            
            if audioPlayer.isPlaying {
                audioPlayer.stop()
            }
            audioPlayer = PcmPlayer(filePath: path, sampleRate: Int(config.sampleRate) ?? 16000)
            audioPlayer.play()
        }
    }
    
    /// 返回当前保存音频文件的路径
    public func uriPath() ->String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let uriPath = "\(path)/\(config.fileName)"
        return uriPath
    }
    
    /// 返回所有的发音人
//    public func speaker() ->[String] {
//        return config.vcnNickNameArray
//    }
    
    /// 设置发音人
//    public func voiceName(name:String) {
//        let names = speaker()
//        for speaker in names {
//            if speaker == name {
//                config.vcnName = name
//                setupSpeech()
//                break
//            }
//        }
//    }
    
    /// 语音合成引擎变更为离线
    public func engineLocal() {
        config.engineType = "local"
        setupLocalSpeech()
    }
    
    /// 语音合成引擎变更为云端
    public func engineCloud() {
        config.engineType = "cloud"
        setupSpeech()
    }
    
    /// 音量范围 0-100
    public func volumeChange( volume:Int) {
        if volume >= 0 && volume <= 100 {
            config.volume = "\(volume)"
            setupSpeech()
        }
    }
    
    /// 语速范围 0-100
    public func speedChange( speed:Int) {
        if speed >= 0 && speed <= 100 {
            config.speed = "\(speed)"
            setupSpeech()
        }
    }
}

extension VoiceBook:IFlySpeechSynthesizerDelegate {
    func onCompleted(_ error: IFlySpeechError!) {
        completeHandler?(error)
    }

    func onSpeakBegin() {
        beginHandler?(nil)
    }
    
    func onBufferProgress(_ progress: Int32, message msg: String!) {
        bufferProgress?(progress)
    }
    
    func onSpeakProgress(_ progress: Int32, beginPos: Int32, endPos: Int32) {
        speakProgress?(progress)
    }
    
    func onSpeakCancel() {
        speakCancel?(nil)
    }
    
    func onSpeakPaused() {
        speakPause?(nil)
    }
    
    func onSpeakResumed() {
        speakResume?(nil)
    }
    
    func onEvent(_ eventType: Int32, arg0: Int32, arg1: Int32, data eventData: Data!) {
        
    }
}
