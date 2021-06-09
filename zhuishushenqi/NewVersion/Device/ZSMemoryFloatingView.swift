//
//  ZSMemoryFloatingView.swift
//  zhuishushenqi
//
//  Created by daye on 2021/6/9.
//  Copyright © 2021 QS. All rights reserved.
//

import UIKit

enum MemoryState {
    
    case low
    case normal
    case high
    case full
    
    var memoryBgColor:UIColor {
        switch self {
        case .low:
            return UIColor(hexString: "#00BB00") ?? UIColor.green
        case .normal:
            return UIColor(hexString: "#00BB00") ?? UIColor.green
        case .high:
            return UIColor(hexString: "#FF5809") ?? UIColor.orange
        case .full:
            return UIColor(hexString: "#AE0000") ?? UIColor.red
        default:
            return UIColor.green
        }
    }
    
    func get(percent:CGFloat) ->MemoryState {
        if percent > 0 && percent <= 0.3 {
            return .low
        } else if percent > 0.3 && percent <= 0.5 {
            return .normal
        } else if percent > 0.5 && percent <= 0.99 {
            return .high
        } else {
            return .full
        }
    }
}

class ZSMemoryFloatingView: ZSFloatingView {
    
    lazy var memoryUsageLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 11)
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var memoryTotalLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 11)
        view.textAlignment = .center
        return view
    }()
    
    lazy var memoryCornerView: UIView = {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var memoryContentView: UIView = {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var memoryBgView: UIView = {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let memoryNormalWidth:CGFloat = 60
    let memoryNormalHeight:CGFloat = 60
    
    var memoryState:MemoryState = .low { didSet { update() } }
    
    var percent:CGFloat = 0
    
    private var timer:Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addSubview(memoryContentView)
        memoryContentView.addSubview(memoryCornerView)
        memoryCornerView.addSubview(memoryBgView)
        addSubview(memoryUsageLabel)
        backgroundColor = UIColor.white
        memoryContentView.backgroundColor = UIColor(hexString: "#3A8863")
        layer.cornerRadius = memoryNormalWidth/2
        layer.masksToBounds = true
        memoryContentView.layer.cornerRadius = (memoryNormalWidth - 4)/2
        memoryContentView.layer.masksToBounds = true
        memoryCornerView.layer.cornerRadius = (memoryNormalWidth - 8)/2
        memoryCornerView.layer.masksToBounds = true
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        memoryContentView.frame = CGRect(x: 2, y: 2, width: memoryNormalWidth - 4, height: memoryNormalHeight - 4)
        memoryCornerView.frame = CGRect(x: 2, y: 2, width: memoryContentView.bounds.width - 4, height: memoryContentView.bounds.height - 4)
        let memoryBgHeight = memoryCornerView.bounds.height * percent
        memoryBgView.frame = CGRect(x: 0, y: memoryCornerView.bounds.height - memoryBgHeight, width: memoryCornerView.bounds.width, height: memoryBgHeight)
        memoryUsageLabel.frame = bounds
    }
    
    func update() {
        memoryBgView.backgroundColor = memoryState.memoryBgColor
    }
    
    static func show() {
        let memoryFloatingView = ZSMemoryFloatingView(frame: .zero)
        memoryFloatingView.show()
    }
    
    func show() {
        let screenBounds = UIScreen.main.bounds
        frame = CGRect(x: screenBounds.width - memoryNormalWidth - 10.0, y: screenBounds.height - memoryNormalHeight - FOOT_BAR_Height, width: memoryNormalWidth, height: memoryNormalHeight)
        let floatingWindow = ZSFloatingWindow(frame: screenBounds)
        let floatingVC = ZSFloatingViewController()
        floatingWindow.rootViewController = floatingVC
        floatingWindow.isHidden = false
        floatingWindow.isUserInteractionEnabled = false
        floatingWindow.windowLevel = UIWindow.Level(rawValue: 999.0)
        floatingVC.view.addSubview(self)
        ZSFloatingManager.share.window = floatingWindow
        start()
    }
    
    func dismiss() {
        timer?.invalidate()
        timer = nil
        removeFromSuperview()
        for window in UIApplication.shared.windows {
            if window.isKind(of: ZSFloatingWindow.self) {
                window.isHidden = true
            }
        }
    }
    
    func start() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerAction(timer:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    @objc
    private func timerAction(timer:Timer) {
        let totalMemoryMBytes = NSString.totalMemory()
        let availableMemoryMBytes = NSString.availableMemory()
        let usageMemoryPercent = (totalMemoryMBytes - availableMemoryMBytes)/totalMemoryMBytes
        memoryState = memoryState.get(percent: CGFloat(usageMemoryPercent))
        memoryUsageLabel.text = String(format: "%.2f%%", usageMemoryPercent * 100)
        percent = CGFloat(usageMemoryPercent)
        setNeedsLayout()
        layoutIfNeeded()
    }
}
