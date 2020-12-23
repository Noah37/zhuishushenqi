//
//  ZSImportBookViewController.swift
//  zhuishushenqi
//
//  Created by yung on 2018/7/30.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSImportBookViewController: BaseViewController {
    
    let httpServer = HTTPServer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "导入本地书籍"
        setupSubviews()
        setupNoti()
        setupHTTPServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ipLabel.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 21)
        ipLabel.center = view.center
        
        textLabel.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 21)
        textLabel.center = CGPoint(x: ipLabel.centerX, y: ipLabel.centerY - 31)
        
        tipLabel.frame = CGRect(x: 0, y: 0, width: 190, height: 40)
        tipLabel.center = CGPoint(x: ipLabel.centerX, y: ipLabel.centerY + 31)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        httpServer.stop()
    }
    
    func setupSubviews(){
        view.addSubview(textLabel)
        view.addSubview(ipLabel)
        view.addSubview(tipLabel)
        
        textLabel.isHidden = true
        ipLabel.isHidden = true
        tipLabel.isHidden = true

    }
    
    func setupHTTPServer(){
        httpServer.setType("_http._tcp.")
        let webPath = Bundle.main.resourcePath
        httpServer.setDocumentRoot(webPath)
        httpServer.setConnectionClass(ZSHTTPConnection.self)
        do {
            try httpServer.start()
            QSLog("IP: \(ZSHTTPTool.getIPAddress(true) ?? ""):\(httpServer.listeningPort())")
            textLabel.isHidden = false
            ipLabel.isHidden = false
            tipLabel.isHidden = false
            ipLabel.text = "http://\(ZSHTTPTool.getIPAddress(true) ?? ""):\(httpServer.listeningPort())"
        } catch {
            QSLog("an error occured :\(error)")
        }
        
    }
    
    func setupNoti(){
        NotificationCenter.default.addObserver(self, selector: #selector(uploadFinished(noti:)), name: NSNotification.Name.init(rawValue: ZSHTTPConnectionUploadFileFinished), object: nil)
    }
    
    @objc func uploadFinished(noti:Notification){
        let fileName = noti.userInfo?["filename"] as? String ?? ""
        let message = "文件\(fileName)上传成功,请到书架查看"
        DispatchQueue.main.async {
            self.hudAddTo(view: self.view, text: message, animated: true)
        }
    }
    
    lazy var textLabel:UILabel  = {
        let label = UILabel()
        label.text = "请用电脑打开浏览器,输入以下网址"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    lazy var ipLabel:UILabel  = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    lazy var tipLabel:UILabel  = {
        let label = UILabel()
        label.text = "手机和电脑需要在同一个无线网络下文件上传时请保持屏幕点亮状态"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
