//
//  HomeNavView.swift
//  ZSBookShelf
//
//  Created by caony on 2019/6/20.
//

import UIKit

public class HomeNavView: UIView {
    
    var logoView:UIImageView!
    var navButtons:[UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        logoView = UIImageView(image: UIImage(named: ""))
        addSubview(logoView)
        
//        let navImages = ZSLogin.share().hasLogin() ? ["","",""]:["", "", "", ""]
        let navImages = [""]
        for image in navImages {
            let btn = UIButton(type: .custom)
            btn.setImage(UIImage(named: image), for: .normal)
            btn.addTarget(self, action: #selector(navAction(btn:)), for: .touchUpInside)
            addSubview(btn)
            navButtons.append(btn)
        }
    }
    
    @objc
    private func navAction(btn:UIButton) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        logoView.frame = CGRect(x: 20, y: 34, width: 80, height: 19)
        var index = navButtons.count - 1
        while index >= 0 {
            let btn = navButtons[index]
            let originX = self.bounds.width - CGFloat(navButtons.count - index - 1) * 42 - 13
            btn.frame = CGRect(x: originX, y: 21, width: 42, height: 42)
            index -= 1
        }
    }
    
}
