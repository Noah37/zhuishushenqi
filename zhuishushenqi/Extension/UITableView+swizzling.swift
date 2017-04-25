//
//  UITableView+swizzling.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

extension UITableView{
    
    
    func checkEmpty(){
        checkEmpty(title: nil, image: nil)
    }
    
    func checkEmpty(title:String?,image:UIImage?){
        guard let empDataSource = self.dataSource else {
            return
        }
        var sections = 0
        var rows = 0
        var isEmpty = true
        
        sections = empDataSource.numberOfSections!(in: self)
        
        for index in 0..<sections {
            rows = empDataSource.tableView(self, numberOfRowsInSection: index)
            if rows != 0{
                isEmpty = false
            }
        }
        if sections == 0{
            isEmpty = true
        }
        if isEmpty {
            let emptyView = getEmptyView(title: title, image: image)
            self.backgroundView = emptyView
        }else{
            self.backgroundView = nil
        }
    }
    
    func getEmptyView(title:String?,image:UIImage?)->EmptyView{
        let emptyView:EmptyView? = UINib(nibName: "EmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? EmptyView
        emptyView?.tittle = title ?? ""
        emptyView?.image  = image
        emptyView?.reloadAction = {
            self.reloadData()
        }
        return emptyView!
    }
}
