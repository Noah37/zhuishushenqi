//
//  SearchViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/11.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class SearchViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate {

    var hotWords = [String]()
    var headerHeight:CGFloat = 0
    var searchWords:String = ""
    var books = [Book]()
    fileprivate var tagColor = [UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0),
                                UIColor(red: 0.96, green: 0.74, blue: 0.49, alpha: 1.0),
                                UIColor(red: 0.57, green: 0.81, blue: 0.84, alpha: 1.0),
                                UIColor(red: 0.40, green: 0.80, blue: 0.72, alpha: 1.0),
                                UIColor(red: 0.91, green: 0.56, blue: 0.56, alpha: 1.0),
                                UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                                UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0)]
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 114, width: ScreenWidth, height: ScreenHeight - 114), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = 10
        tableView.rowHeight = 44
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    
    lazy var searchController:UISearchController = {
        let searchVC:UISearchController = UISearchController(searchResultsController: nil)
        searchVC.searchBar.placeholder = "输入书名或作者名111"
        searchVC.searchResultsUpdater = self
        searchVC.delegate = self
        searchVC.searchBar.delegate = self
//        searchVC.obscuresBackgroundDuringPresentation = true
        searchVC.hidesNavigationBarDuringPresentation = true
        searchVC.searchBar.sizeToFit()
        searchVC.searchBar.backgroundColor = UIColor.darkGray
        
        return searchVC
    }()
    
    var headerView:UIView?
    
    var changeIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "搜索"
        initSubview()
        requestData()
        view.backgroundColor = UIColor.red
    }
    
    func requestData() -> Void {
//        http://api.zhuishushenqi.com/book/hot-word
        let urlString = "\(baseUrl)/book/hot-word"
        QSNetwork.request(urlString) { (response) in
            print(response.json ?? "No Data")
            if let json = response.json {
                self.hotWords = json["hotWords"] as? [String] ?? [""]
//                self.tableView.reloadData()
                DispatchQueue.main.async {
                    self.headerView = self.headView()
                    self.view.addSubview(self.tableView)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func initSubview(){
        let bgView = UIView()
        bgView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: 50)
        bgView.addSubview(self.searchController.searchBar)
        view.addSubview(bgView)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }// called when keyboard search button pressed
    
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar){
        
    }// called when bookmark button pressed
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        dismiss(animated: false, completion: nil)
    }// called when cancel button pressed
    
    fileprivate func headView()->UIView{
        let  headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 0, width: 200, height: 21)
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
        btn.frame = CGRect(x: self.view.bounds.width - 90, y: 0, width: 70, height: 21)
        headerView.addSubview(btn)
        
        var x:CGFloat = 20
        var y:CGFloat = 10 + 21
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
            btn.layer.cornerRadius = 2
            headerView.addSubview(btn)
            
            x = x + width + spacex
        }
        changeIndex = count + 1
        headerHeight = y + height + 10
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: headerHeight)
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
    
    

    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    @objc func backAction(item:UIBarButtonItem){
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
