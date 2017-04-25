//
//  SearchView.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/11.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

protocol SearchViewDelegate {
    func searchViewClearButtonClicked()
    func searchViewHotWordClick(index:Int)
}

class SearchView: UIView,UITableViewDataSource,UITableViewDelegate {

    var delegate:SearchViewDelegate?
    var hotWords = [String](){
        didSet{
            
            self.headerView = headView()
            self.tableView.dataSource  = self
            self.tableView.delegate = self
            self.addSubview(self.tableView)
        }
    }
    var historyList:[String]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    var headerHeight:CGFloat = 0
    var searchWords:String = ""
    var books = [Book]()
    var headerView:UIView?
    var changeIndex = 0
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y:0, width: ScreenWidth, height: ScreenHeight - 114), style: .grouped)
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 114
        tableView.delegate = self
        tableView.rowHeight = 44
//        tableView.register(UINib (nibName: self.iden, bundle: nil), forCellReuseIdentifier: self.iden)
        return tableView
    }()
    
    fileprivate var tagColor = [UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0),
                                UIColor(red: 0.96, green: 0.74, blue: 0.49, alpha: 1.0),
                                UIColor(red: 0.57, green: 0.81, blue: 0.84, alpha: 1.0),
                                UIColor(red: 0.40, green: 0.80, blue: 0.72, alpha: 1.0),
                                UIColor(red: 0.91, green: 0.56, blue: 0.56, alpha: 1.0),
                                UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0)]
    
    fileprivate lazy var clearBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("清空", for: .normal)
        btn.setImage(UIImage(named:"d_delete"), for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.frame = CGRect(x: self.bounds.width - 80, y: 11, width: 60, height: 21)
        btn.addTarget(self, action: #selector(clearAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func headView()->UIView{
        let  headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 20, width: 200, height: 21)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.text = "大家都在搜"
        headerView.addSubview(label)
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"actionbar_refresh"), for: .normal)
        btn.setTitle("换一批", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.contentHorizontalAlignment = .right
        btn.addTarget(self, action: #selector(changeHotWord(btn:)), for: .touchUpInside)
        btn.frame = CGRect(x: self.bounds.width - 90, y: 20, width: 70, height: 21)
        headerView.addSubview(btn)
        
        var x:CGFloat = 20
        var y:CGFloat = 10 + 21 + 20
        let spacex:CGFloat = 10
        let spacey:CGFloat = 10
        let height:CGFloat = 20
        var count = 0
        for index in changeIndex..<(changeIndex + 6) {
            count = index
            if count >= hotWords.count {
                count = count - hotWords.count
            }
            let width = widthOfString(hotWords[count], font: UIFont.systemFont(ofSize: 11), height: 21) + 20
            if x + width + 20 > ScreenWidth {
                x = 20
                y = y + spacey + height
            }
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            btn.setTitle(hotWords[count], for: UIControlState())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.backgroundColor = tagColor[index%tagColor.count]
            btn.tag = count  + 12121
            btn.addTarget(self, action: #selector(hotWordSearchAction(btn:)), for: .touchUpInside)
            btn.layer.cornerRadius = 2
            headerView.addSubview(btn)
            
            x = x + width + spacex
        }
        changeIndex = count + 1
        headerHeight = y + height + 10
        headerView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: headerHeight)
        return headerView
    }
    
    @objc func changeHotWord(btn:UIButton){
        if changeIndex > self.hotWords.count {
            
        }
        let views = self.headerView?.subviews
        for index in 0..<(views?.count ?? 0) {
            let view = views?[index]
            view?.removeFromSuperview()
        }
        self.headerView = headView()
        self.tableView.reloadData()
    }
    
    @objc func hotWordSearchAction(btn:UIButton){
        delegate?.searchViewHotWordClick(index: btn.tag - 12121)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (historyList?.count ?? 0) + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "HotWords")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "HotWords")
        }
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = UIColor.darkGray
        if indexPath.row == 0 {
            cell?.textLabel?.textColor = UIColor.black
            cell?.textLabel?.text = "搜索历史"
            clearBtn.removeFromSuperview()
            cell?.contentView.addSubview(clearBtn)
            cell?.imageView?.image = nil
        }else{
            cell?.imageView?.image = UIImage(named: "bs_last_read")
            cell?.textLabel?.text = historyList?[indexPath.row - 1]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    @objc func clearAction(btn:UIButton){
        delegate?.searchViewClearButtonClicked()
    }

}
