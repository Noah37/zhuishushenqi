//
//  QSThemeTopicInteractor.swift
//  zhuishushenqi
//
//  Created Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import ZSAPI

class QSThemeTopicInteractor: QSThemeTopicInteractorProtocol {

    var output: QSThemeTopicInteractorOutputProtocol!
    
    var models:[[ThemeTopicModel]] = [[],[],[]]
    
    var selectedIndex = 0
    var tag = ""
    var gender = ""
    let segTitles = ["本周最热","最新发布","最多收藏"]
    func filter(index:Int,title:String,name:String){
        //此处index为tag的index
        var titleString = title
        let genders = ["male","female"]
        if name == "性别" {
            gender = genders[index]
            tag = ""
            titleString = "\(titleString)生书单"
        }else{
            gender = ""
            tag = title
        }
        self.output.showFilter(title: titleString,index: selectedIndex, tag: tag, gender: gender)
    }
    
    func initTitle(index:Int){
        self.output.showFilter(title: "全部书单", index: index, tag: tag, gender: gender)
    }
    
    func setupSeg(index:Int){
        self.output.showSegView(titles:segTitles )
    }
    
    //
    func requestTitle(index:Int,tag:String,gender:String){
        selectedIndex = index
        models = [[],[],[]]
        request(index: index, tag: tag, gender: gender)
    }
    
    func requestDetail(index:Int){
        if selectedIndex == index {
            return
        }
        selectedIndex = index
        if self.models[index].count > 0 {
            self.output.fetchModelSuccess(models: self.models[index])
            return
        }
        request(index: index, tag: tag, gender: gender)
    }
    
    func request(index:Int,tag:String,gender:String){
        //本周最热
        //        http://api.zhuishushenqi.com/book-list?sort=collectorCount&duration=last-seven-days&start=0
        
        //最新发布
        //        http://api.zhuishushenqi.com/book-list?sort=created&duration=all&start=0
        
        //最多收藏 （全部书单）
        //        http://api.zhuishushenqi.com/book-list?sort=collectorCount&duration=all&start=0
        var sorts:[String] = ["collectorCount","created","collectorCount"]
        var durations:[String] = ["last-seven-days","all","all"]
        let api = ZSAPI.themeTopic(sort: sorts[index], duration: durations[index], start: "0", gender: gender, tag: tag)
        zs_get(api.path, parameters: api.parameters) { (response) in
            QSLog(response)
            if let books = response?["bookLists"] {
                if let models = [ThemeTopicModel].deserialize(from: books as? [Any]) as? [ThemeTopicModel] {
                    self.models[index] = models
                    self.output.fetchModelSuccess(models: models)
                } else {
                    self.output.fetchModelFailed()
                }
            } else{
                self.output.fetchModelFailed()
            }
        }
    }
}
