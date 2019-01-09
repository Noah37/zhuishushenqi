//
//  ZSUserAccountViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/1/9.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSUserAccountViewController: ZSBaseTableViewController {
    
    var cells = [
        ["header":"财产","section":[
            ["title":"追书币","detail":"","image":"","center":"","type":"custom"],
            ["title":"追书券","detail":"","image":"","center":"","type":"label"],
            ["title":"兑换追书券","detail":"","image":"","center":"","type":"label"]
          ]],
         ["header":"记录","section":[
            ["title":"充值记录","detail":"","image":"","center":"","type":"bind"],
            ["title":"消费记录","detail":"","image":"","center":"","type":"bind"]
          ]
        ],
         ["header":"","section":[
            ["title":"版本号","detail":"用户ID","image":"","center":"","type":"bind"]
            ]
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "个人账户"
        setupSubviews()
    }
    
    func setupSubviews() {
        
    }
    
    override func registerCellClasses() -> Array<AnyClass> {
        return [ZSRTMyCell.self,UITableViewCell.self]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = cells[section]["section"] as? [[String:String]] {
            return sectionInfo.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionInfo = cells[indexPath.section]["section"] as? [[String:String]]
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil 
    }

}
