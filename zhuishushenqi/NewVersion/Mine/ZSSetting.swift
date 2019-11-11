//
//  ZSSetting.swift
//  zhuishushenqi
//
//  Created by caony on 2019/11/11.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

@objc
protocol SettingsDelegate: AnyObject {
    func settingsOpenURLInNewTab(_ url: URL)
}

// A setting in the sections panel. Contains a sublist of Settings
class SettingSection: ZSSetting {
    fileprivate let children: [ZSSetting]
    
    init(title: NSAttributedString? = nil, footerTitle: NSAttributedString? = nil, cellHeight: CGFloat? = nil, children: [ZSSetting]) {
        self.children = children
        super.init(title: title, footerTitle: footerTitle, cellHeight: cellHeight)
    }
    
    var count: Int {
        var count = 0
        for setting in children where !setting.hidden {
            count += 1
        }
        return count
    }
    
    subscript(val: Int) -> ZSSetting? {
        var i = 0
        for setting in children where !setting.hidden {
            if i == val {
                return setting
            }
            i += 1
        }
        return nil
    }
}

// A base setting class that shows a title. You probably want to subclass this, not use it directly.
class ZSSetting: NSObject {
    fileprivate var _title: NSAttributedString?
    fileprivate var _footerTitle: NSAttributedString?
    fileprivate var _cellHeight: CGFloat?
    fileprivate var _image: UIImage?
    
    weak var delegate: SettingsDelegate?
    
    // The url the SettingsContentViewController will show, e.g. Licenses and Privacy Policy.
    var url: URL? { return nil }
    
    // The title shown on the pref.
    var title: NSAttributedString? { return _title }
    var footerTitle: NSAttributedString? { return _footerTitle }
    var cellHeight: CGFloat? { return _cellHeight}
    fileprivate(set) var accessibilityIdentifier: String?
    
    // An optional second line of text shown on the pref.
    var status: NSAttributedString? { return nil }
    
    // Whether or not to show this pref.
    var hidden: Bool { return false }
    
    var style: UITableViewCell.CellStyle { return .subtitle }
    
    var accessoryType: UITableViewCell.AccessoryType { return .none }
    
    var accessoryView: UIImageView? { return nil }
    
    var textAlignment: NSTextAlignment { return .natural }
    
    var image: UIImage? { return _image }
    
    var enabled: Bool = true
    
    func accessoryButtonTapped() { onAccessoryButtonTapped?() }
    var onAccessoryButtonTapped: (() -> Void)?
    
    // Called when the cell is setup. Call if you need the default behaviour.
    func onConfigureCell(_ cell: UITableViewCell) {
        cell.detailTextLabel?.assign(attributed: status)
        cell.detailTextLabel?.attributedText = status
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.assign(attributed: title)
        cell.textLabel?.textAlignment = textAlignment
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.lineBreakMode = .byTruncatingTail
        cell.accessoryType = accessoryType
        cell.accessoryView = accessoryView
        cell.selectionStyle = enabled ? .default : .none
        cell.accessibilityIdentifier = accessibilityIdentifier
        cell.imageView?.image = _image
        if let title = title?.string {
            if let detailText = cell.detailTextLabel?.text {
                cell.accessibilityLabel = "\(title), \(detailText)"
            } else if let status = status?.string {
                cell.accessibilityLabel = "\(title), \(status)"
            } else {
                cell.accessibilityLabel = title
            }
        }
        cell.accessibilityTraits = UIAccessibilityTraits.button
        cell.indentationWidth = 0
        cell.layoutMargins = .zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(rgb: 0xd1d1d6)
        backgroundView.bounds = cell.bounds
        cell.selectedBackgroundView = backgroundView
        
        // So that the separator line goes all the way to the left edge.
        cell.separatorInset = .zero
//        if let cell = cell as? ThemedTableViewCell {
//            cell.applyTheme()
//        }
    }
    
    // Called when the pref is tapped.
    func onClick(_ navigationController: UINavigationController?) { return }
    
    // Called when the pref is long-pressed.
    func onLongPress(_ navigationController: UINavigationController?) { return }
    
    // Helper method to set up and push a SettingsContentViewController
    func setUpAndPushSettingsContentViewController(_ navigationController: UINavigationController?) {
        if let url = self.url {
//            let viewController = SettingsContentViewController()
//            viewController.settingsTitle = self.title
//            viewController.url = url
//            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    init(title: NSAttributedString? = nil, footerTitle: NSAttributedString? = nil, cellHeight: CGFloat? = nil, delegate: SettingsDelegate? = nil, enabled: Bool? = nil) {
        self._title = title
        self._footerTitle = footerTitle
        self._cellHeight = cellHeight
        self.delegate = delegate
        self.enabled = enabled ?? true
    }
}

extension UILabel {
    // iOS bug: NSAttributed string color is ignored without setting font/color to nil
    func assign(attributed: NSAttributedString?) {
        guard let attributed = attributed else { return }
        let attribs = attributed.attributes(at: 0, effectiveRange: nil)
        if attribs[NSAttributedString.Key.foregroundColor] == nil {
            // If the text color attribute isn't set, use the table view row text color.
//            textColor = UIColor.theme.tableView.rowText
            textColor = UIColor.black
        } else {
            textColor = nil
        }
        attributedText = attributed
    }
}
