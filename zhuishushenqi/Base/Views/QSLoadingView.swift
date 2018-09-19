//
//  QSLoadingView.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

typealias CloseAction = ()->Void

class QSLoadingView: UIView {

    var tipStr:String? {
        didSet{
            tip.text = tipStr
        }
    }
    var tip:UILabel!
    var closeClosure:CloseAction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews(){
        self.backgroundColor = UIColor.clear
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        bgView.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.8)
        bgView.center = self.center
        let acctivityView = UIActivityIndicatorView(style: .white)
        acctivityView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        acctivityView.center = CGPoint(x: bgView.bounds.width/2, y: bgView.bounds.height/2 - 10)
        acctivityView.startAnimating()
        bgView.addSubview(acctivityView)
//        let loadView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        loadView.center = CGPoint(x: bgView.bounds.width/2, y: bgView.bounds.height/2 - 10)
//        loadView.image = UIImage(named: "loadside")
//        bgView.addSubview(loadView)
        bgView.layer.cornerRadius = 10
        addSubview(bgView)
        tip = UILabel(frame: CGRect(x: 0, y: bgView.bounds.height - 40, width: 100, height: 20))
        tip.font = UIFont.systemFont(ofSize: 15)
        tip.textColor = UIColor.white
        tip.textAlignment = .center
        tip.text = "正在加载..."
        bgView.addSubview(tip)
        
        let close = UIButton(type: .custom)
        close.setImage(UIImage(named:"g_close"), for: .normal)
        close.frame = CGRect(x: bgView.bounds.width - 20, y: -10, width: 30, height: 30)
        close.addTarget(self, action: #selector(closeAction(btn:)), for: .touchUpInside)
        bgView.addSubview(close)
        
//        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//        animation.toValue = M_PI*2
//        animation.duration = 1.0
//        animation.repeatCount = MAXFLOAT
//        loadView.layer.add(animation, forKey: "rotate")
    }
    
    @objc func closeAction(btn:UIButton){
        if let close = closeClosure{
            close()
        }
    }
}

extension IndicatableView where Self:UIViewController{
    func showActivityView(){
        let loadView:QSLoadingView = QSLoadingView(frame: UIScreen.main.bounds)
        loadView.closeClosure = {
            self.hideActivityView()
        }
        KeyWindow?.insertSubview(loadView, at: KeyWindow?.subviews.count ?? 0)
    }
    
    func hideActivityView(){
        if let subviews = KeyWindow?.subviews {
            for item in subviews {
                if item.isKind(of: QSLoadingView.self) {
                    item.removeFromSuperview()
                }
            }
        }
    }
    
    func showLoadingPageView(){
        
    }
    
    func hideLoadingPageView(){
        
    }
}
