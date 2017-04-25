//
//  PageViewController.swift
//  PageViewController
//
//  Created by Nory Cao on 16/10/9.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    lazy var titleLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:20)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        return titleLabel
    }()
    lazy var pageLabel:UILabel = {
        let pageLabel = UILabel(frame: CGRect(x:0,y:self.view.bounds.size.height - 30,width:self.view.bounds.size.width,height:30))
        pageLabel.font = UIFont.systemFont(ofSize: 13)
        pageLabel.textAlignment = .center
        pageLabel.backgroundColor = UIColor.clear
        return pageLabel
    }()
    var page:QSPage? {
        didSet{
            pageView.attributedText = NSMutableAttributedString(string: self.page?.content ?? "")
            pageView.attribute = page?.attribute
            pageLabel.text = "第\(((self.page?.curPage ?? 0) + 1))/\(self.page?.totalPages ?? 1)页"
            titleLabel.text = self.page?.title ?? ""
        }
    }
    var batteryView:QSBatteryView!
    var timeLabel:UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
    }
    
    func setSubviews() -> Void {
        self.view = self.bgView
        
        view.addSubview(titleLabel)
        
        self.view.addSubview(pageLabel)
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textAlignment = .center
        timeLabel.frame  = CGRect(x:self.view.bounds.width - 40 - 15 , y: self.view.bounds.height - 30, width: 40, height: 30)
        timeLabel.text = getCurrentTime()
        view.addSubview(timeLabel)
        
        batteryView = QSBatteryView(frame: CGRect(x: 15, y: self.view.bounds.height - 20, width: 25, height: 10))
        batteryView.batteryLevel = CGFloat(UIDevice.current.batteryLevel)
        view.addSubview(batteryView)
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            let level = UIDevice.current.batteryLevel
            QSLog("电池电量：\(level)）")
            self.batteryView.batteryLevel = CGFloat(level)
        }
        
        
            // Fallback on earlier versions
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getTime(time:)), userInfo: nil, repeats: true)
    }
    
    @objc func getTime(time:Timer){
        self.timeLabel.text = self.getCurrentTime()
    }
    
    func getCurrentTime()->String{
        let calendar = NSCalendar.current as NSCalendar
        let components = calendar.components([NSCalendar.Unit.hour,NSCalendar.Unit.minute], from: Date())
        let hour = components.hour
        let minute = components.minute
        return "\(hour ?? 00):\(minute ?? 00)"
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.clear
//        view.addSubview(bgView)
        view.addSubview(pageView)
    }
    
    lazy var pageView:PageView = {
        let pageView = PageView()
        pageView.frame = CGRect(x:10,y: 20,width: self.view.bounds.size.width - 20,height: self.view.bounds.size.height - 40)
        pageView.backgroundColor = UIColor.clear
        return pageView
    }()

    lazy var bgView:UIImageView = {
        let bgView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        bgView.image = UIImage(named: "yellow_mode_bg")
        if let image = getReaderBgColor() {
            bgView.image = image
        }
        bgView.backgroundColor = UIColor.white
        bgView.isUserInteractionEnabled = true
        return bgView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
