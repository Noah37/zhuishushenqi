//
//  ProgressView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/28.
//  Copyright © 2017年 QS. All rights reserved.
//

/*
 {
    "desc":"正在缓存中",
    "total":100,
    "now":0
 }
 */
import UIKit

class ProgressView: UIView {

    var dict:[String:Any]? {
        didSet{
            if let tip = dict {
                setTips(dict: tip)
            }
        }
    }
    
    private var tipLabel:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    func setupSubview(){
        tipLabel = UILabel()
        tipLabel.frame = CGRect(x: 15, y: 0, width: self.bounds.width, height: 20)
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 11)
        addSubview(tipLabel)
    }
    
    func setTips(dict:[String:Any]){
        let desc = dict["desc"] ?? ""
        let total:Int = dict["total"] as? Int ?? -1
        let now:Int = dict["now"] as? Int ?? 0
        var tip = ""
        if total == -1 {
            tip = "\(desc)"
        }else{
            tip = "\(desc)(\(now + 1)/\(total))"
        }
        if now >= total {
            tip = "缓存完成...(\(now)/\(total))"
        }
        DispatchQueue.main.async {
            self.tipLabel.text = tip
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
