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
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    var titles:NSArray = [["title":"动态","image":"d_icon"],["title":"综合讨论区","image":"f_ramble_icon"],["title":"书评区[找书必看]","image":"forum_public_review_icon"],["title":"书荒互助区","image":"forum_public_help_icon"],["title":"女生区","image":"f_girl_icon"]]
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
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iden = "CellIden"
        var cell = tableView.dequeueReusableCell(withIdentifier: iden)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: iden)
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = (titles[indexPath.row] as! NSDictionary).object(forKey: "title") as? String
        cell?.imageView?.image = UIImage(named:(titles[indexPath.row] as! NSDictionary).object(forKey: "image") as? String ?? "")
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.accessoryType = .disclosureIndicator
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
