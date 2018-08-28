//
//  ZSCellAdapterProtocol.swift
//  zhuishushenqi
//
//  Created by caony on 2018/8/27.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

protocol ZSCellAdapterProtocol:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
}

protocol ZSSectionAdapterProtocol:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? // custom view for header. will be adjusted to default or specified header height

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? // custom view for footer. will be adjusted to default or specified footer height

}

protocol ZSListAdapterProtocol:ZSCellAdapterProtocol,ZSSectionAdapterProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented

}
