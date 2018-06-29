//
//  QSBookDetailContentView.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSBookDetailContentView: UIView {

    var longIntro:String? {
        didSet{
            if let intro = longIntro {
                setupSubviews(longIntro: intro)
            }
        }
    }
    
    var contentShow:Bool = false {
        didSet{
            setNeedsLayout()
        }
    }
    private let defaultHeight:CGFloat = 100
    
    var contentLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews(longIntro: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupSubviews(longIntro:String){
        let height = contentHeight(longIntro: self.longIntro ?? "")
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true
        let subviews = self.subviews
        for item in subviews {
            item.removeFromSuperview()
        }
        contentLabel = UILabel(frame: CGRect(x: 20,y: 10,width: ScreenWidth - 40,height: height))
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.numberOfLines = 0
        contentLabel.text = longIntro
        contentLabel.textColor = UIColor.black
        self.addSubview(contentLabel)
    }
    
    private func contentHeight(longIntro:String)->CGFloat{
        if contentShow {
            var height:CGFloat = longIntro.qs_height(15, width: ScreenWidth - 40)
            if height == 0 {
                height = defaultHeight
            }else{
                height += 30
            }
            return height
        }
        else{
            return defaultHeight
        }
    }
    
    static func height(intro:String,show:Bool)->CGFloat{
        let content = QSBookDetailContentView()
        content.contentShow = show
        let height = content.contentHeight(longIntro: intro)
        return height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if contentShow {
            let height = contentHeight(longIntro: self.longIntro ?? "")
            contentLabel.frame = CGRect(x: 20,y: 10,width: ScreenWidth - 40,height: height - 30)
        }else{
            contentLabel.frame = CGRect(x: 20,y: 10,width: ScreenWidth - 40,height: 89)
        }
    }
}
