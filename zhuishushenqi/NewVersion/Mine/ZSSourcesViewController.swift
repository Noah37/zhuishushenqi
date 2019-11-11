//
//  ZSSourcesViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/11/11.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSSourcesViewController: ZSBaseTableViewController {
    
    var sources:[AikanParserModel] { return ZSSourceManager.share.sources }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSSourceCell.self)
        return cell!
    }
    
    override func registerCellClasses() -> Array<AnyClass> {
        return [ZSSourceCell.self]
    }
}

