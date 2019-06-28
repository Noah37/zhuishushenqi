//
//  HomeNavView.swift
//  ZSBookShelf
//
//  Created by caony on 2019/6/20.
//

import UIKit

protocol NavigationBarDelegate:class {
    func navView(navView:NavigationBar, didSelect at:Int)
}

class NavigationBar: UIView {
    
    private var logoView:UIImageView!
    private var navButtons:[UIButton] = []
    private var navImages:[UIImage] = []
    
    weak var delegate:NavigationBarDelegate?
    
    init(navImages:[UIImage], delegate:NavigationBarDelegate?) {
        super.init(frame: CGRect.zero)
        self.navImages = navImages
        self.delegate = delegate
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        logoView = UIImageView(image: UIImage(named: ""))
        addSubview(logoView)
        configureNavButtons()
    }
    
    private func configureNavButtons() {
        for image in navImages {
            let btn = UIButton(type: .custom)
            btn.setImage(image, for: .normal)
            btn.addTarget(self, action: #selector(navAction(btn:)), for: .touchUpInside)
            addSubview(btn)
            navButtons.append(btn)
        }
    }
    
    @objc
    private func navAction(btn:UIButton) {
        var index = 0
        for button in navButtons {
            if button == btn {
                break
            }
            index += 1
        }
        delegate?.navView(navView: self, didSelect: index)
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
