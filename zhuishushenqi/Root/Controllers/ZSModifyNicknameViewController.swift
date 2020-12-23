//
//  ZSModifyNicknameViewController.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/25.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSModifyNicknameViewController: BaseViewController {
    
    let viewModel = ZSMyViewModel()
    
    private var nicknameTextField:ZSLoginTextField!
    
    private var tipLabel:UILabel!
    
    var nickname:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        let rightItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nicknameTextField.becomeFirstResponder()
        nicknameTextField.text = nickname
    }
    
    private func setupSubviews() {
        nicknameTextField = ZSLoginTextField(frame: CGRect(x: 0, y: kNavgationBarHeight + 30, width: self.view.bounds.width, height: 50))
        nicknameTextField.font = UIFont.systemFont(ofSize: 15)
        nicknameTextField.textColor = UIColor.black
        nicknameTextField.backgroundColor = UIColor.white
        nicknameTextField.textAlignment = .left
        nicknameTextField.placeholder = "请输入昵称"
        view.addSubview(nicknameTextField)
        
        tipLabel = UILabel(frame: CGRect(x: 15, y: nicknameTextField.frame.maxY , width: self.view.bounds.width - 30, height: 30))
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        tipLabel.textAlignment = .left
        tipLabel.textColor = UIColor.gray
        tipLabel.text = "修改后需要30天才能再次修改"
        view.addSubview(tipLabel)
        
    }
    

    @objc
    func saveAction() {
        let nickname = nicknameTextField.text ?? ""
        if nickname == self.nickname {
            self.view.showTipView(tip: "新昵称不能与原昵称相同")
        }
        viewModel.fetchNicknameChange(nickname: nickname, token: ZSLogin.share.token) { (json) in
            if json?["ok"] as? Bool == true {
                self.view.showTipView(tip: "昵称修改成功")
                self.navigationController?.popViewController(animated: true)
            } else {
                if let msg = json?["msg"] as? String {
                    self.view.showTipView(tip: msg)
                }
            }
        }
    }
}
