//
//  ZSVoiceBookCategoryViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/23.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit
import SnapKit

class ZSVoiceSectionCenter: NSObject {
    
    static var sectionName:String = ""
    static var categoryType:Int = 0
    static var imageName:String = ""
    private static let shared = ZSVoiceSectionCenter()
    private override init() {
        
    }
    
    @discardableResult
    static func shared(section:Int) -> ZSVoiceSectionCenter{
        switch section {
        case 0:
            sectionName = "最新"
            categoryType = 2
            imageName = "zuixin"
            break
        case 1:
            sectionName = "热门"
            categoryType = 1
            imageName = "zuire"
            break
        case 2:
            sectionName = "经典"
            categoryType = 3
            imageName = "jingdian"
            break
        default: break
            
        }
        return ZSVoiceSectionCenter.shared
    }
}

class ZSVoiceBookCategoryViewController: BaseViewController ,XMReqDelegate, UITableViewDataSource, UITableViewDelegate, ZSVoiceSegmentProtocol {

    let dataSource = ["nav":[
        ["title":"都市言情",
         "tags":["言情","官场商战","都市"]
        ],
        ["title":"玄幻仙侠",
         "tags":["幻想",
                 "武侠"]
        ],
        ["title":"科幻惊悚",
         "tags":["悬疑"]
        ],
        ["title":"历史",
         "tags":["历史"]
        ],
        ["title":"出版",
         "tags":["经管",
                 "社科",
                 "读客图书",
                 "果麦文化",
                 "中信出版",
                 "博集天卷",
                 "磨铁阅读",
                 "速播专区",
                 "蓝狮子",
                 "推理世界",
                 "正能量有声书"]
        ]
        ],
                      ]
    
    var tableView:UITableView!
    
    var segmentView:ZSVoiceSegmentView!
    
    var albums:[ZSVoiceAlbums] = [ZSVoiceAlbums(),ZSVoiceAlbums(),ZSVoiceAlbums()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        XMReqMgr.sharedInstance()?.delegate = self
        setupSubviews()
//        NSDictionary *dict = @{@"calc_dimension":@2,
//            @"category_id":@3,
//            @"count":@20,
//            @"page":@1,
//            @"tag_name":@"武侠",
//            @"type":@0
//        };
        let params = [ "category_id":3,
                        "count":20,
                        "page":1,
                        "tag_name":"官场商战",
                        "type":0,
                        "calc_dimension":2] as [String : Any]
        XMReqMgr.sharedInstance()?.requestXMData(XMReqType.albumsList, params: params, withCompletionHander: { (result, error) in
            if let albums = ZSVoiceAlbums.deserialize(from: result as! [String:Any]) {
                
            }
        })
    }
    
    func request(category_id:Int, tagName:String, handler:@escaping ZSBaseCallback<ZSVoiceAlbums>) {
        let params = [ "category_id":3,
                       "count":20,
                       "page":1,
                       "tag_name":tagName,
                       "type":0,
                       "calc_dimension":category_id] as [String : Any]
        XMReqMgr.sharedInstance()?.requestXMData(XMReqType.albumsList, params: params, withCompletionHander: { (result, error) in
            if let albums = ZSVoiceAlbums.deserialize(from: result as? [String:Any]) {
                handler(albums)
            } else {
                handler(nil)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        segmentView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavgationBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        tableView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
        }
    }
    
    private func setupSubviews() {
        segmentView = ZSVoiceSegmentView(frame: CGRect.zero)
        segmentView.delegate = self
        view.addSubview(segmentView)
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.qs_registerCellClass(UITableViewCell.self)
        view.addSubview(tableView)
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        ZSVoiceSectionCenter.shared(section: indexPath.section)
        cell?.textLabel?.text = ZSVoiceSectionCenter.sectionName
        cell?.imageView?.image = UIImage(named: ZSVoiceSectionCenter.imageName)
        if indexPath.row == 0 {
            let album = albums[indexPath.section]
//            request(category_id: ZSVoiceSectionCenter.categoryType, tagName: ZSVoiceSectionCenter., handler: <#T##ZSBaseCallback<ZSVoiceAlbums>##ZSBaseCallback<ZSVoiceAlbums>##(ZSVoiceAlbums?) -> Void#>)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    //MARK: - XMReqDelegate
    func didXMInitReqOK(_ result: Bool) {
        
    }
    
    func didXMInitReqFail(_ respModel: XMErrorModel!) {
        
    }
    
    //MARK: - ZSVoiceSegmentProtocol
    func titlesForSegment(segmentView: ZSVoiceSegmentView) -> [String] {
        var titles:[String] = []
        if let arr = dataSource["nav"] {
            for item in arr {
                titles.append(item["title"] as! String)
            }
        }
        return titles
    }

    func didSelect(segment: ZSVoiceSegmentView, at index: Int) {
//        request(category_id: <#T##Int#>, tagName: <#T##String#>, handler: <#T##ZSBaseCallback<ZSVoiceAlbums>##ZSBaseCallback<ZSVoiceAlbums>##(ZSVoiceAlbums?) -> Void#>)
    }
}
