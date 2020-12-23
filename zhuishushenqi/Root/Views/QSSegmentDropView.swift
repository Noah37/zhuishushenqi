//
//  QSSegmentDropView.swift
//  zhuishushenqi
//
//  Created by yung on 2017/6/18.
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

protocol ZSMultiSelectionDelegate {
    func numberOfSections(in multiSelectionView: ZSMultiSelectionView) ->Int
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, numberOfRowsInSection section: Int) -> Int
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForRowAt indexPath:IndexPath) -> String
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForHeaderIn section:Int) -> String
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, didSelectAt indexPath:IndexPath)
}

class ZSMultiSelectionView: UIView {
    /// 下拉列表点击事件代理
    var delegate:ZSMultiSelectionDelegate? { didSet { setupSubviews() } }
    /// 下拉列表
//    private var selectionList:[[String]] = []
    /// 当前选中的项
    fileprivate var selectedSelectionIndexs:[Int] = []
    /// 当前选中的section,非激活状态为上一次的选中
    fileprivate var selectedSectionIndex:Int = 0
    /// 父视图
    private var parentView:UIView?
    /// 下拉列表section的基准tag
    private let selectionSectionBaseTag = 1234
    /// 下拉列表section的分割线的基准tag
    private let selectionSectionSeparatorBaseTag = 1314
    /// 背景视图
    private var backgroundView:UIView!
    /// 下拉列表
    private var tableView:UITableView!
    /// 底部分割线
    private var horizonalSeparatorView:UIView!
    /// section之间的分割线
    private var verticalSeparatorViews:[UIView] = []
    /// 下拉列表的高度
    private let selectionItemHeight:CGFloat = 44
    /// 下拉列表的激活状态
    private var isSelectionActive:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupSubviews() {
        backgroundColor = UIColor.white
        backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        backgroundView.isUserInteractionEnabled = true
        backgroundView.isHidden = true
        
        let tap = UITapGestureRecognizer { (tap) in
            self.updateHeaderState(with: self.backgroundView)
            self.hideSelection()
        }
        backgroundView.addGestureRecognizer(tap)
        horizonalSeparatorView = UIView(frame: CGRect(x: 0, y: self.bounds.height - 0.5, width: self.bounds.width, height: 0.5))
        horizonalSeparatorView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        addSubview(horizonalSeparatorView)
        
        if let sections = delegate?.numberOfSections(in: self) {
            for index in 0..<sections {
                let height = self.bounds.height - 0.5
                let title = delegate?.multiSelectionView(self, titleForHeaderIn: index) ?? ""
                let btn = ZSSegmentSelectionButton(type: .custom)
                btn.setTitle(title, for: UIControl.State())
                btn.tag = index + selectionSectionBaseTag
                let width = (self.bounds.width - 0.5*(sections.cgfloat - 1))/sections.cgfloat
                let x = width * index.cgfloat + 0.5 * index.cgfloat
                btn.frame = CGRect(x: x, y: 0, width: width, height: height)
                let labelWidth = title.qs_width(UIFont.systemFont(ofSize: 13), height: 16)
                btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth, bottom: 0, right: -labelWidth)
                btn.addTarget(self, action: #selector(self.headerClick(btn:)), for: .touchUpInside)
                btn.isSelected = false
                addSubview(btn)
                selectedSelectionIndexs.append(0)
                
                if index < sections - 1 {
                    let verticalLine = UIView(frame: CGRect(x: (index + 1).cgfloat*width, y: self.bounds.height/3, width: 0.5, height: self.bounds.height/3))
                    verticalLine.backgroundColor = UIColor.gray
                    verticalLine.tag = selectionSectionSeparatorBaseTag + index
                    verticalLine.alpha = 0.6
                    addSubview(verticalLine)
                    verticalSeparatorViews.append(verticalLine)
                }
            }
        }
        tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: self.bounds.width, height: 0), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        tableView.qs_registerCellClass(UITableViewCell.self)
        tableView.bounces = false
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    @objc
    private func headerClick(btn:UIButton) {
        // 处理header的状态
        updateHeaderState(with: btn)
        // 展示下拉列表
        if isSelectionActive {
            showSelection()
        } else {
            hideSelection()
        }
    }
    
    private func updateHeaderState(with btn:UIView) {
        guard let sections = delegate?.numberOfSections(in: self) else { return }
        for index in 0..<sections {
            let tag = index + selectionSectionBaseTag
            guard let button = viewWithTag(tag) as? UIButton else { return }
            if btn == button {
                button.isSelected = !button.isSelected
                isSelectionActive = button.isSelected
                selectedSectionIndex = index
            } else {
                button.isSelected = false
            }
            if selectedSectionIndex == index {
                let indexPath = IndexPath(row: selectedSelectionIndexs[selectedSectionIndex], section: selectedSectionIndex)
                let title = delegate?.multiSelectionView(self, titleForRowAt: indexPath)
                button.setTitle(title, for: .normal)
            }
        }
    }
    
    private func showSelection() {
        
        if let parentView = self.superview {
            if backgroundView.superview == nil {
                parentView.addSubview(backgroundView)
            }
            if tableView.superview == nil {
                parentView.addSubview(tableView)
            }
            parentView.bringSubviewToFront(self)
            parentView.bringSubviewToFront(backgroundView)
            parentView.bringSubviewToFront(tableView)
        }
        self.tableView.reloadData()
        let animation =  {
            let screenHeight = UIScreen.main.bounds.height
            let rows = self.delegate?.multiSelectionView(self, numberOfRowsInSection: self.selectedSectionIndex) ?? 0
            var tableViewHeight = CGFloat(rows)*self.selectionItemHeight
            if tableViewHeight > (screenHeight - self.frame.maxY) {
                tableViewHeight = screenHeight - self.frame.maxY
            }
            self.tableView.frame = CGRect(x: 0, y: self.frame.maxY, width: self.bounds.width, height: tableViewHeight)
            self.backgroundView.isHidden = false
        }
        UIView.animate(withDuration: 0.25, animations: animation, completion: nil)
    }
    
    func hideSelection() {
        let animation =  {
            self.tableView.frame = CGRect(x: 0, y: self.frame.maxY, width: self.bounds.width, height: 0)
            self.backgroundView.isHidden = true
        }
        UIView.animate(withDuration: 0.25, animations: animation, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = CGRect(x: 0, y: self.frame.maxY, width: self.bounds.width, height: ScreenHeight - self.frame.maxY)
        horizonalSeparatorView.frame = CGRect(x: 0, y: self.bounds.height - 0.5, width: self.bounds.width, height: 0.5)
        if isSelectionActive {
            let screenHeight = UIScreen.main.bounds.height
            let rows = self.delegate?.multiSelectionView(self, numberOfRowsInSection: self.selectedSectionIndex) ?? 0
            var tableViewHeight = CGFloat(rows)*self.selectionItemHeight
            if tableViewHeight > (screenHeight - self.frame.maxY) {
                tableViewHeight = screenHeight - self.frame.maxY
            }
            self.tableView.frame = CGRect(x: 0, y: self.frame.maxY, width: self.bounds.width, height: tableViewHeight)
        } else {
            self.tableView.frame = CGRect(x: 0, y: self.frame.maxY, width: self.bounds.width, height: 0)
        }
        guard let sections = delegate?.numberOfSections(in: self) else { return }
        for index in 0..<sections {
            let tag = index + selectionSectionBaseTag
            guard let button = viewWithTag(tag) as? UIButton else { return }
            let width = (self.bounds.width - 0.5*(sections.cgfloat - 1))/sections.cgfloat
            let x = width * index.cgfloat + 0.5 * index.cgfloat
            button.frame = CGRect(x: x, y: 0, width: width, height: self.bounds.height - 0.5)
            let separatorTag = selectionSectionSeparatorBaseTag + index
            guard let vertical = viewWithTag(separatorTag) else { return }
            vertical.frame = CGRect(x: (index + 1).cgfloat*width, y: self.bounds.height/3, width: 0.5, height: self.bounds.height/3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZSMultiSelectionView:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = delegate?.multiSelectionView(self, numberOfRowsInSection: selectedSectionIndex) ?? 0
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        cell?.contentView.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        cell?.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        cell?.selectionStyle = .none
        let truelyIndexPath = IndexPath(row: indexPath.row, section: self.selectedSectionIndex)
        cell?.textLabel?.text = delegate?.multiSelectionView(self, titleForRowAt: truelyIndexPath)
        let selectedRowIndex = selectedSelectionIndexs[selectedSectionIndex]
        cell?.textLabel?.textColor = indexPath.row == selectedRowIndex ? UIColor.red: UIColor.gray
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return selectionItemHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isSelectionActive = false
        selectedSelectionIndexs[selectedSectionIndex] = indexPath.row
        updateHeaderState(with: tableView)
        hideSelection()
        let truelyIndexPath = IndexPath(row: indexPath.row, section: selectedSectionIndex)
        delegate?.multiSelectionView(self, didSelectAt: truelyIndexPath)
    }
}

class QSSegmentDropView: UIView {
    
    var menuDelegate:QSSegmentDropViewDelegate?
    private var titles:[[String]] = [[],[]]
    var selectedSegment:Int = 0
    private var parentView:UIView?
    private var selectIndexs:[Int] = []
    fileprivate let btnTag = 1234
    private var bottomLine:UILabel!
    private var verticalLines:[UILabel] = []
    private let rowHight:CGFloat = 44
    /// 记录下拉列表的激活状态
    private var isSelectionActive:Bool = false
    
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
        tableView.rowHeight = rowHight
        tableView.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        tableView.qs_registerCellClass(UITableViewCell.self)
        tableView.bounces = false
        return tableView
    }()
    
    init(frame:CGRect, WithTitles _titles:[[String]],parentView:UIView){
        super.init(frame: frame)
        self.parentView = parentView
        titles = _titles
        setupSubviews(frame,titles: _titles)
        if #available(iOS 11, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    fileprivate func setupSubviews(_ frame:CGRect,titles:[[String]]){
        var index:Int = 0
        let width = self.bounds.width/CGFloat(titles.count)
        let height = self.bounds.height
        for item in 0..<titles.count {
            let tmpTitles = titles[item]
            let title = tmpTitles.count > 0 ? tmpTitles[0]:""
            let btn = ZSSegmentSelectionButton(type: .custom)
            btn.setTitle(title, for: UIControl.State())
            btn.tag = index + btnTag
            btn.frame = CGRect(x: width*CGFloat(index), y: 0, width: width, height: height)
            let labelWidth = title.qs_width(UIFont.systemFont(ofSize: 13), height: 16)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth, bottom: 0, right: -labelWidth)
            btn.addTarget(self, action: #selector(self.segmentBtnClick(_:)), for: .touchUpInside)
            addSubview(btn)
            if index > 0 && index <= titles.count - 1 {
                let line = UILabel(frame: CGRect(x: width*CGFloat(index),y: height/3,width: 0.5,height: height/3))
                line.backgroundColor = UIColor.gray
                line.alpha = 0.6
                verticalLines.append(line)
                addSubview(line)
            }
            index += 1
        }
        bottomLine = UILabel(frame: CGRect(x: 0,y: height - 0.5,width: self.bounds.width,height: 0.5))
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
    
    @objc
    fileprivate func segmentBtnClick(_ btn:UIButton){
        let tag = btn.tag - btnTag
        selectedSegment = tag
        btnSelect(btn)
        
        if btn.isSelected == false {
            hideSelection()
        }else{
            showSelection()
            tableView.reloadData()
        }
    }
    
    private func showSelection() {
        if self.bgView.superview == nil {
            self.parentView?.addSubview(self.bgView)
        }
        if self.tableView.superview == nil {
            parentView?.addSubview(self.tableView)
        }
        self.parentView?.bringSubviewToFront(self.tableView)
        self.bgView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            var tableHeight:CGFloat = CGFloat(self.rowHight*CGFloat(self.titles[self.selectedSegment].count))
            if tableHeight > ((self.parentView?.bounds.height ?? 0) - self.frame.maxY) {
                tableHeight = (self.parentView?.bounds.height ?? 0) - self.frame.maxY
            }
            self.tableView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40, width: self.bounds.width, height: tableHeight)
        }
        refreshUI()
    }
    
    private func hideSelection() {
        let btn:UIButton? = viewWithTag(selectedSegment + btnTag) as? UIButton
        btn?.isSelected = false
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.isHidden = true
            self.tableView.frame = CGRect(x: 0, y: Int(kNavgationBarHeight + 40), width: Int(self.bounds.width), height: 0)
        }) { (finish) in
            self.bgView.removeFromSuperview()
        }
    }
    
    private func btnSelect(_ btn:UIButton){
        btn.isSelected = !btn.isSelected
        for index in 0..<titles.count {
            let otherBtn:UIButton = viewWithTag(index + btnTag) as! UIButton
            if otherBtn != btn {
                otherBtn.isSelected = false
            }
        }
    }
    
    private func refreshUI(){
        var width = self.bounds.width
        if titles.count > 0 {
            width = width/CGFloat(titles.count)
        }
        let height = self.bounds.height
        for index in 0..<titles.count  {
            let btn:UIButton? = viewWithTag(index + btnTag) as? UIButton
            btn?.frame = CGRect(x: width*CGFloat(index), y: 0, width: width, height: height)
        }
        for index in 0..<verticalLines.count {
            let line = verticalLines[index]
            line.frame = CGRect(x: width*CGFloat(index + 1),y: height/3,width: 0.5,height: height/3)
        }
        bottomLine.frame = CGRect(x: 0,y: height - 0.5,width: self.bounds.width,height: 0.5)
        self.bgView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40, width: self.bounds.width, height: ScreenHeight - kNavgationBarHeight - 40)
        var tableHeight = self.tableView.bounds.height
        if tableHeight > ((parentView?.bounds.height ?? 0) - self.frame.maxY) {
            tableHeight = (parentView?.bounds.height ?? 0) - self.frame.maxY
        } else if tableHeight == 0 {
            
        } else {
            tableHeight = CGFloat(self.rowHight*CGFloat(self.titles[self.selectedSegment].count))
        }
        self.tableView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40, width: self.bounds.width, height: tableHeight)
        
    }
    
    @objc
    private func dismissDrop(sender:Any){
        hideSelection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshUI()
    }
}

extension QSSegmentDropView:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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

class ZSSegmentSelectionButton:UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitleColor(UIColor.gray, for: UIControl.State())
        self.setImage(UIImage(named:"nav_arrow_down"), for: .normal)
        self.setImage(UIImage(named:"nav_arrow_up"), for: .selected)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 13)
        self.contentHorizontalAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.backgroundColor = UIColor.white
    }
}
