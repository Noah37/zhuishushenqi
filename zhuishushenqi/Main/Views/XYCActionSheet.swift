//
//  XYCActionSheet.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/6.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

protocol XYCActionSheetDelegate {
    func didSelectedAtIndex(index:Int, sheet:XYCActionSheet)
}

class XYCActionSheet: UIView {
    
    var delegate:XYCActionSheetDelegate?
    var titles:NSMutableArray = NSMutableArray()
    var backColor:NSArray = [UIColor.redColor(),UIColor.greenColor(),UIColor.blueColor(),UIColor.cyanColor(),UIColor.orangeColor(),UIColor.yellowColor(),UIColor.purpleColor()]
    private var colorArr:NSMutableArray = NSMutableArray(objects: ["0","1","2","3","4","5","6"], count: 7)
    init(frame: CGRect,titles:NSArray) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.00, alpha: 0.8)
        self.titles.addObjectsFromArray(titles as [AnyObject])
        self.titles.addObject("取消")
        initSuview()
    }
    
    private func initSuview(){
        if titles.count == 0 {
            return
        }
        for index in 0..<titles.count{
            let btn = UIButton(type: .Custom)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            btn.frame = CGRectMake(20, 20 + 40*CGFloat(index) + 5*CGFloat(index), ScreenWidth - 40, 40)
            let randomIndex = getIndexNotExist()
            
            btn.tag = index
            btn.titleLabel?.font = UIFont.systemFontOfSize(13)
            btn.layer.cornerRadius = 4
            btn.addTarget(self, action: #selector(btnAction(_:)), forControlEvents: .TouchUpInside)
            btn.backgroundColor = backColor[Int(randomIndex)] as? UIColor
            btn.setTitle(titles[index] as? String, forState: .Normal)
            if index == titles.count - 1 {
                btn.backgroundColor = UIColor.grayColor()
            }
            addSubview(btn)
        }
    }
    
    private func existColor(index:Int,colorArray:NSArray) ->Bool{
        if colorArray.count == 0 {
            return false
        }
        for indexxx in 0..<colorArray.count {
            if index == colorArray[indexxx] as! Int {
                return true
            }
        }
        return false
    }
    
    private func getIndexNotExist()->Int{
        var randomIndex = arc4random()%UInt32(backColor.count)
        while !colorArr.containsObject("\(randomIndex)") {
            randomIndex = arc4random()%UInt32(backColor.count)
        }
        colorArr.removeObject("\(randomIndex)")
        return Int(randomIndex)
    }
    
    @objc private func btnAction(btn:UIButton){
        delegate?.didSelectedAtIndex(btn.tag,sheet: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
