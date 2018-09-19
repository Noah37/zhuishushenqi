//
//  QSSegmentDropView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/18.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

protocol QSSegmentDropViewDelegate {
    func didSelectAtIndexs(_ indexs:[Int])
}

/*
 [
    [
        "全部",
        "精品"
    ]
 ]
 */

class QSSegmentDropView: UIView {
    
    var menuDelegate:QSSegmentDropViewDelegate?
    var titles:[[String]] = [[],[]]
    var selectedSegment:Int = 0
    var parentView:UIView?
    var selectIndexs:[Int] = []
    fileprivate let btnTag = 1234
    private lazy var bgView:UIView = {
        let bgView = UIView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40))
        bgView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        bgView.isUserInteractionEnabled = true
        return bgView
    }()
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: 0), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 44
        tableView.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        tableView.qs_registerCellClass(UITableViewCell.self)
        tableView.bounces = false
        return tableView
    }()
    
    init(frame:CGRect, WithTitles _titles:[[String]],parentView:UIView){
        super.init(frame: frame)
        self.parentView = parentView
        titles = _titles
        initSubview(frame,titles: _titles)
        if #available(iOS 11, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    fileprivate func initSubview(_ frame:CGRect,titles:[[String]]){
        var index:Int = 0
        let ScreenBounds = UIScreen.main.bounds
        let width = ScreenBounds.width/CGFloat(titles.count)
        let height = frame.size.height
        for item in 0..<titles.count {
            let tmpTitles = titles[item]
            let title = tmpTitles.count > 0 ? tmpTitles[0]:""
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: UIControl.State())
            btn.setTitleColor(UIColor.gray, for: UIControl.State())
            btn.tag = index + btnTag
            btn.setImage(UIImage(named:"nav_arrow_down"), for: .normal)
            btn.setImage(UIImage(named:"nav_arrow_up"), for: .selected)
            btn.frame = CGRect(x: width*CGFloat(index), y: 0, width: width, height: height)
            let labelWidth = title.qs_width(UIFont.systemFont(ofSize: 13), height: 16)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth, bottom: 0, right: -labelWidth)
            
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 13)
            btn.contentHorizontalAlignment = .center
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.addTarget(self, action: #selector(self.segAction(_:)), for: .touchUpInside)
            addSubview(btn)
            if index > 0 && index <= titles.count - 1 {
                let line = UILabel(frame: CGRect(x: width*CGFloat(index),y: height/3,width: 0.5,height: height/3))
                line.backgroundColor = UIColor.gray
                line.alpha = 0.6
                addSubview(line)
            }
            index += 1
        }
        let bottomLine = UILabel(frame: CGRect(x: 0,y: height - 0.5,width: ScreenBounds.width,height: 0.5))
        bottomLine.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        addSubview(bottomLine)
        backgroundColor = UIColor.white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissDrop(sender:)))
        bgView.addGestureRecognizer(tap)
        
        // initializer,default 0
        for index in 0..<titles.count {
            if titles[index].count > 0 {
                selectIndexs.append(0)
            }
        }
    }
    
    @objc fileprivate func segAction(_ btn:UIButton){
        let tag = btn.tag - btnTag
        if tag != selectedSegment {
//            selectedIndex = 0
            selectedSegment = tag
        }
        btnSelect(btn)
        if btn.isSelected == false {
            dismissDrop(sender: btn)
        }else{
            refreshUI()
        }
    }
    
    func btnSelect(_ btn:UIButton){
        btn.isSelected = !btn.isSelected
        for index in 0..<titles.count {
            let otherBtn:UIButton = viewWithTag(index + btnTag) as! UIButton
            if otherBtn != btn {
                otherBtn.isSelected = false
            }
        }
    }
    
    func refreshUI(){
        parentView?.addSubview(self.tableView)
        let tableHeight:CGFloat = CGFloat(44*self.titles[self.selectedSegment].count)
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: tableHeight)
            self.bgView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40 + tableHeight, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40)
            self.parentView?.addSubview(self.bgView)
        }
        tableView.reloadData()
    }
    
    @objc func dismissDrop(sender:Any){
        let btn:UIButton? = viewWithTag(selectedSegment + btnTag) as? UIButton
        btn?.isSelected = false
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40)
            self.tableView.frame = CGRect(x: 0, y: Int(kNavgationBarHeight + 40), width: Int(ScreenWidth), height: 0)
        }) { (finish) in
            self.bgView.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QSSegmentDropView:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegment < titles.count{
            let subs:[String] = titles[selectedSegment]
            return subs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        cell?.textLabel?.text = titles[selectedSegment][indexPath.row]
        cell?.contentView.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        cell?.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = indexPath.row == selectIndexs[selectedSegment] ? UIColor.red: UIColor.gray
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndexs[selectedSegment] = indexPath.row
        let btn:UIButton? = viewWithTag(selectedSegment + btnTag) as? UIButton
        btn?.setTitle(titles[selectedSegment][selectIndexs[selectedSegment]], for: .normal)
        tableView.reloadData()
        dismissDrop(sender: tableView)
        menuDelegate?.didSelectAtIndexs(selectIndexs)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}
