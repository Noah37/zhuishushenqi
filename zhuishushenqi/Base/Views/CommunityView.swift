//
//  CommunityView.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/22.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

protocol ComnunityDelegate {
    func didSelectCellAtIndex(_ index:Int)
}

class CommunityView: UIView,UITableViewDataSource,UITableViewDelegate {

    var delegate:ComnunityDelegate?
    var models:[BookDetail] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 104), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    var titles:NSArray = [["title":"动态","image":"d_icon"],["title":"综合讨论区","image":"f_ramble_icon"],["title":"书评区[找书必看]","image":"forum_public_review_icon"],["title":"书荒互助区","image":"forum_public_help_icon"],["title":"女生区","image":"f_girl_icon"],["title":"浏览记录","image":"f_invent_icon"]]
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count + models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iden = "CellIden"
        var cell = tableView.dequeueReusableCell(withIdentifier: iden)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: iden)
            cell?.selectionStyle = .none
        }
        let name = indexPath.row < titles.count ? (titles[indexPath.row] as! NSDictionary).object(forKey: "image") as? String ?? "" : ""
        let title = indexPath.row < titles.count ? (titles[indexPath.row] as! NSDictionary).object(forKey: "title") as? String : ""
        cell?.textLabel?.text = title
        cell?.imageView?.image = UIImage(named:name)
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.accessoryType = .disclosureIndicator
        if indexPath.row >= titles.count {
            cell?.imageView?.qs_setBookCoverWithURLString(urlString: models[indexPath.row - titles.count].cover)
            cell?.textLabel?.text = models[indexPath.row - titles.count].title
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCellAtIndex(indexPath.row)
    }
    
    fileprivate func initSubview(){
        
    }
    
}
