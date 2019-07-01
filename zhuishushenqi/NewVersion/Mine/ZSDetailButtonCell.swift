//
//  ZSDetailButtonCell.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/1.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

typealias ZSDetailButtonCellHandler = ()->Void
typealias ZSDetailButtonCellValueHandler = (_ result:Bool)->Void

enum ZSDetailButtonCellType {
    case none
    case indicator
    case text
    case swtch
    case roundedIndicator
    case textIndicator
}

class ZSDetailButtonCell: UITableViewCell {
    
    lazy var detailButton:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(hexString: "#A70A0B")?.cgColor
        button.setTitleColor(UIColor.init(hexString: "#A70A0B"), for: .normal)
        button.setTitle("开通", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(detailButtonAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var detailTextButton:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitle("开通", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(detailTextButtonAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var detailSwitch:UISwitch = {
        let detailSwitch = UISwitch(frame: .zero)
        detailSwitch.isOn = false
        detailSwitch.onTintColor = UIColor.init(hexString: "#A70A0B")
        detailSwitch.addTarget(self, action: #selector(detailSwitchAction(swtch:)), for: .valueChanged)
        return detailSwitch
    }()
    
    var detailHandler:ZSDetailButtonCellHandler?
    var detailTextHandler:ZSDetailButtonCellHandler?
    var switchHandler:ZSDetailButtonCellValueHandler?

    var type:ZSDetailButtonCellType = .none { didSet { change(type: type) } }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        detailTextLabel?.textColor = UIColor.gray
        contentView.addSubview(detailButton)
        contentView.addSubview(detailTextButton)
        contentView.addSubview(detailSwitch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let accessoryViewMarginX:CGFloat = accessoryType == .disclosureIndicator ? bounds.width - 20:bounds.width
        let detailButtonWidth:CGFloat = detailButton.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)).width
        detailButton.frame = CGRect(x: accessoryViewMarginX - detailButtonWidth - 30 - 20, y: bounds.height/2 - 15, width: detailButtonWidth + 30, height: 30)
        let detailTextWidth:CGFloat = detailTextButton.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)).width
        var detailTextFrame = CGRect.zero
        switch type {
        case .text:
            detailTextFrame = CGRect(x: bounds.width - detailTextWidth - 20, y: bounds.height/2 - 15, width: detailTextWidth, height: 30)
            break
        case .textIndicator:
            detailTextFrame = CGRect(x: bounds.width - detailTextWidth - 30, y: bounds.height/2 - 15, width: detailTextWidth, height: 30)
        default:
            break
        }
        detailTextButton.frame = detailTextFrame
        detailSwitch.frame = CGRect(x: bounds.width - 55 - 20, y: bounds.height/2 - 20, width: 51, height: 31)
    }
    
    func configure(title:String, icon:String, detail:String?, detailButtonText:String?) {
        textLabel?.text = title
        imageView?.image = UIImage(named: icon)
        detailTextLabel?.text = detail
        detailButton.setTitle(detailButtonText, for: .normal)
        detailTextButton.setTitle(detailButtonText, for: .normal)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func change(type:ZSDetailButtonCellType) {
        detailTextButton.isHidden = (type != .text && type != .textIndicator)
        detailButton.isHidden = (type != .roundedIndicator)
        detailSwitch.isHidden = (type != .swtch)
        switch type {
        case .text:
            accessoryType = .none
            break
        case .textIndicator:
            accessoryType = .disclosureIndicator
            break
        case .roundedIndicator:
            accessoryType = .disclosureIndicator
            break
        case .swtch:
            accessoryType = .none
            break
        case .indicator:
            accessoryType = .disclosureIndicator
            break
        default:
            break
        }
    }

    @objc
    private func detailButtonAction(btn:UIButton) {
        detailHandler?()
    }
    
    @objc
    private func detailTextButtonAction(btn:UIButton) {
        detailTextHandler?()
    }
    
    @objc
    private func detailSwitchAction(swtch:UISwitch) {
        switchHandler?(swtch.isOn)
    }
}
