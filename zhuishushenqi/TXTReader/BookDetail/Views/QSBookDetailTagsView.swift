//
//  QSBookDetailTagsView.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSBookDetailTagsView: UIView {
    var tagColor = [UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                    UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0),
                    UIColor(red: 0.96, green: 0.74, blue: 0.49, alpha: 1.0),
                    UIColor(red: 0.57, green: 0.81, blue: 0.84, alpha: 1.0),
                    UIColor(red: 0.40, green: 0.80, blue: 0.72, alpha: 1.0),
                    UIColor(red: 0.91, green: 0.56, blue: 0.56, alpha: 1.0),
                    UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
                    UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0)]
    
    var tags:[String]!{
        didSet{
            setupSubviews(tags: tags)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func setupSubviews(tags:[String])->CGFloat{
        self.backgroundColor = UIColor.white
        let subviews = self.subviews
        for item in subviews {
            item.removeFromSuperview()
        }
        var x:CGFloat = 20
        var y:CGFloat = 10
        let spacex:CGFloat = 10
        let spacey:CGFloat = 10
        let height:CGFloat = 30
        for index in 0..<tags.count {
            let width = (tags[index]).qs_width(UIFont.systemFont(ofSize: 15), height: 21)  + 20
            if x + width + 20 > ScreenWidth {
                x = 20
                y = y + spacey + height
            }
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            btn.setTitle(tags[index], for: UIControl.State())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitleColor(UIColor.white, for: UIControl.State())
            btn.backgroundColor = tagColor[index%tagColor.count]
            btn.layer.cornerRadius = 2
            self.addSubview(btn)
            
            x = x + width + spacex
        }
        return (y + height + 10)
    }
    
    static func height(tags:[String])->CGFloat{
        let view:QSBookDetailTagsView = QSBookDetailTagsView()
        return view.setupSubviews(tags: tags)
    }

}
