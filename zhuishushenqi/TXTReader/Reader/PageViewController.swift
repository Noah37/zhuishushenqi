//
//  PageViewController.swift
//  PageViewController
//
//  Created by Nory Cao on 16/10/9.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

let PageViewDidTap = "PageViewDidTap"

class PageViewController: UIViewController {
    lazy var titleLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x:0,y:CGFloat(kQSReaderTopMargin),width:self.view.bounds.size.width,height:20)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        titleLabel.text = ""
        titleLabel.textColor = AppStyle.shared.reader.textColor
        return titleLabel
    }()
    lazy var pageLabel:UILabel = {
        let pageLabel = UILabel()
        pageLabel.frame = CGRect(x:0,y:self.view.bounds.size.height - 30,width:self.view.bounds.size.width,height:30)
        pageLabel.font = UIFont.systemFont(ofSize: 13)
        pageLabel.textAlignment = .center
        pageLabel.backgroundColor = UIColor.clear
        pageLabel.textColor = AppStyle.shared.reader.textColor
        pageLabel.text = "1/1"
        return pageLabel
    }()
    var page:QSPage? {
        didSet {
            refreshView()
        }
    }
    
    var newPage:ZSBookPage? {
        didSet {
            self.view.alpha = 1.0
            refreshView()
        }
    }
    lazy var batteryView:QSBatteryView = {
        let batteryView = QSBatteryView(frame: CGRect(x: 15, y: self.view.bounds.height - 20, width: 25, height: 10))
        batteryView.batteryLevel = CGFloat(UIDevice.current.batteryLevel)
        return batteryView
    }()
    lazy var timeLabel:UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textAlignment = .center
        timeLabel.frame  = CGRect(x:self.view.bounds.width - 40 - 15 , y: self.view.bounds.height - 30, width: 40, height: 30)
        timeLabel.text = getCurrentTime()
        return timeLabel
    }()
    var timer:Timer!
    
    // 正版购买信息
    var payView:ZSChapterPayView!
    
    var isShowPayView:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        layoutSubview()
    }
    
    private func layoutSubview() {
        titleLabel.snp.remakeConstraints { (make) in
            var top = 0
            let orientation = UIApplication.shared.statusBarOrientation
            if orientation.isPortrait && IPHONEX {
                top = 30
            }
            make.left.right.equalToSuperview()
            make.top.equalTo(top)
            make.height.equalTo(20)
        }
        pageLabel.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
        batteryView.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalTo(15)
            make.width.equalTo(25)
            make.height.equalTo(10)
        }
        timeLabel.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        payView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if let _ = pageView.superview {
            pageView.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.bottom.equalToSuperview().offset(-30)
            }
        }
        bgView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setSubviews() -> Void {
        
        view.addSubview(bgView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(pageLabel)
        
        view.addSubview(timeLabel)
        
        view.addSubview(batteryView)
        
        view.addSubview(pageView)
        
        payView = ZSChapterPayView(frame: CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 0))
        payView.isHidden = true
        view.addSubview(payView)
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(forName: UIDevice.batteryLevelDidChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            let level = UIDevice.current.batteryLevel
            QSLog("电池电量：\(level)）")
            self?.batteryView.batteryLevel = CGFloat(level)
        }
    
        // Fallback on earlier versions
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getTime(time:)), userInfo: nil, repeats: true)
        
    }
    
    func showPayView() {
        isShowPayView = true
        payView.isHidden = false
        payView.titleLabel.text = titleLabel.text
        view.bringSubviewToFront(payView)
        UIView.animate(withDuration: 0.25, animations: {
            self.payView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }) { (finished) in
            
        }
    }
    
    func hidePayView() {
        isShowPayView = false
        payView.isHidden = true
    }
    
    @objc func getTime(time:Timer){
        self.timeLabel.text = self.getCurrentTime()
    }
    
    @objc func getCurrentTime()->String{
        let calendar = NSCalendar.current as NSCalendar
        let components = calendar.components([NSCalendar.Unit.hour,NSCalendar.Unit.minute], from: Date())
        let hour = components.hour
        let minute = components.minute
        return "\(toBit(bit: hour ?? 00)):\(toBit(bit: minute ?? 00))"
    }
    
    func toBit(bit:Int) ->String{
        var bitString = String(describing: bit)
        if bit < 10 {
            bitString = String(format: "%02d", arguments: [bit])
        }
        return bitString
    }
    
    public func setPage(tmpPage:QSPage?){
        if let realPage = tmpPage {
            page = realPage
        } else {
            page = QSPage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.clear
        view.addSubview(pageView)
        layoutSubview()
    }
    
    
    func refreshView(){
        if let page = self.page {
            pageView.attributedText = page.content
            pageLabel.text = "第\((page.curPage + 1))/\(page.totalPages)页"
            titleLabel.text = page.title
            titleLabel.textColor = AppStyle.shared.reader.textColor
            pageLabel.textColor = AppStyle.shared.reader.textColor
            timeLabel.textColor = AppStyle.shared.reader.textColor
            batteryView.batteryColor = AppStyle.shared.reader.batteryColor
        } else if let page = self.newPage {
            pageView.attributedText = page.content
            pageLabel.text = "第\((page.pageIndex + 1))/\(page.totalPages)页"
            titleLabel.text = page.chapterName
            titleLabel.textColor = AppStyle.shared.reader.textColor
            pageLabel.textColor = AppStyle.shared.reader.textColor
            timeLabel.textColor = AppStyle.shared.reader.textColor
            batteryView.batteryColor = AppStyle.shared.reader.batteryColor
        }
    }
    
    lazy var pageView:PageView = {
        let pageView = PageView()
        pageView.frame = QSReaderFrame
        pageView.backgroundColor = UIColor.clear
        return pageView
    }()

    lazy var bgView:UIImageView = {
        let bgView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        bgView.image = AppStyle.shared.reader.backgroundImage
        bgView.backgroundColor = UIColor.white
        bgView.isUserInteractionEnabled = true
        return bgView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.tapCount == 1 {
            // 发送tap事件给其它的在意者
            NotificationCenter.qs_postNotification(name: PageViewDidTap, obj: nil)
        }
    }
    
    func destroy() {
        timer.invalidate()
        timer = nil
    }

    deinit {
        QSLog("PageVC释放了")
    }
}
