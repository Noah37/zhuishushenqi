//
//  ZSTopSearchBar.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

protocol ZSTopSearchBarProtocol:class {
    
    func zsTopSearchBar(topSearchBar:ZSTopSearchBar, searchTextFieldShouldBeginEditing text:String)
    func zsTopSearchBar(topSearchBar:ZSTopSearchBar, searchTextFieldEditChanged text:String)
    func zsTopSearchBar(topSearchBar:ZSTopSearchBar, searchTextFieldReturn text:String)
    func zsTopSearchBarCancelButtonClick(topSearchBar:ZSTopSearchBar)

}

class ZSTopSearchBar: UIView, UITextFieldDelegate {

    lazy var textfield:UITextField = {
        let tf = UITextField(frame: CGRect.zero)
        tf.placeholder = "请输入书名、作者或者分类"
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.textColor = UIColor.gray
        tf.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.93, alpha:1.00)
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.delegate = self
        return tf
    }()
    
    lazy var cancelButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("取消", for: UIControl.State.normal)
        bt.setTitleColor(UIColor(red:0.93, green:0.28, blue:0.27, alpha:1.00), for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        bt.addTarget(self, action: #selector(cancelAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    weak var delegate:ZSTopSearchBarProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.textfield)
        addSubview(self.cancelButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let statusFrame = UIApplication.shared.statusBarFrame
        let screenFrame = UIScreen.main.bounds
        textfield.frame = CGRect(x: 15, y: 16 + statusFrame.height, width: screenFrame.width - 75 - 15, height: 36)
        cancelButton.frame = CGRect(x: screenFrame.width - 75, y: statusFrame.height, width: 75, height: 68)
    }
    
    @objc
    private func cancelAction(bt:UIButton) {
        delegate?.zsTopSearchBarCancelButtonClick(topSearchBar: self)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.zsTopSearchBar(topSearchBar: self, searchTextFieldShouldBeginEditing: textField.text ?? "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.zsTopSearchBar(topSearchBar: self, searchTextFieldReturn: textField.text ?? "")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.zsTopSearchBar(topSearchBar: self, searchTextFieldEditChanged: "")
        return true
    }
    
}
