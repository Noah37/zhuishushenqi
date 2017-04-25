//
//  XYCActionSheet.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/6.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

protocol XYCActionSheetDelegate {
    func didSelectedAtIndex(_ index:Int, sheet:XYCActionSheet)
}

class XYCActionSheet: UIView {
    
    var delegate:XYCActionSheetDelegate?
    var titles:NSMutableArray = NSMutableArray()
    var backColor:NSArray = [UIColor.red,UIColor.green,UIColor.blue,UIColor.cyan,UIColor.orange,UIColor.yellow,UIColor.purple]
    fileprivate var colorArr:NSMutableArray = NSMutableArray(objects: ["0" as AnyObject,"1" as AnyObject,"2" as AnyObject,"3" as AnyObject,"4" as AnyObject,"5" as AnyObject,"6" as AnyObject], count: 7)
    init(frame: CGRect,titles:NSArray) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.00, alpha: 0.8)
        self.titles.addObjects(from: titles as [AnyObject])
        self.titles.add("取消")
        initSuview()
    }
    
    fileprivate func initSuview(){
        if titles.count == 0 {
            return
        }
        for index in 0..<titles.count{
            let btn = UIButton(type: .custom)
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.frame = CGRect(x: 20, y: 20 + 40*CGFloat(index) + 5*CGFloat(index), width: ScreenWidth - 40, height: 40)
            let randomIndex = getIndexNotExist()
            
            btn.tag = index
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.layer.cornerRadius = 4
            btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
            btn.backgroundColor = backColor[Int(randomIndex)] as? UIColor
            btn.setTitle(titles[index] as? String, for: UIControlState())
            if index == titles.count - 1 {
                btn.backgroundColor = UIColor.gray
            }
            addSubview(btn)
        }
    }
    
    fileprivate func existColor(_ index:Int,colorArray:NSArray) ->Bool{
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
    
    fileprivate func getIndexNotExist()->Int{
        var randomIndex = arc4random()%UInt32(backColor.count)
        while !colorArr.contains("\(randomIndex)") {
            randomIndex = arc4random()%UInt32(backColor.count)
        }
        colorArr.remove("\(randomIndex)")
        return Int(randomIndex)
    }
    
    @objc fileprivate func btnAction(_ btn:UIButton){
        delegate?.didSelectedAtIndex(btn.tag,sheet: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
