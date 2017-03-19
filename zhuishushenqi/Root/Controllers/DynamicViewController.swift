//
//  DynamicViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/22.
//  Copyright © 2016年 XYC. All rights reserved.
//

import UIKit

class DynamicViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var timeline:NSArray  = []
    fileprivate var segment:UISegmentedControl = {
       let seg = UISegmentedControl(frame: CGRect(x: 15,y: 69,width: ScreenWidth - 30,height: 30))
        seg.insertSegment(withTitle: "动态", at: 0, animated: false)
        seg.insertSegment(withTitle: "热门", at: 1, animated: false)
        seg.insertSegment(withTitle: "我的", at: 2, animated: false)
        seg.tintColor = UIColor.red
        seg.backgroundColor = UIColor.clear
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 104, width: ScreenWidth, height: ScreenHeight - 104), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 145
        tableView.rowHeight = 172
        tableView.sectionHeaderHeight = 0.0001
        tableView.sectionFooterHeight = 0.0001
        tableView.backgroundColor = UIColor.clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "动态"
        tableView.qs_registerCellNib(DynamicCell.self)
        view.addSubview(segment)
        view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DynamicCell = tableView.qs_dequeueReusableCell(DynamicCell.self)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
