//
//  ZSReaderStyleSelectionView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/2/1.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderStyleSelectionViewDelegate:class {
    func style(selectionView:ZSReaderStyleSelectionView, select style:ZSReaderPageStyle)
}

class ZSReaderStyleSelectionView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate:ZSReaderStyleSelectionViewDelegate?
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.qs_registerCellClass(ZSReaderStyleSelectionCell.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.black
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZSReaderPageStyle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSReaderStyleSelectionCell.self)
        let style = ZSReaderPageStyle(rawValue: indexPath.row)
        cell?.textLabel?.text = style?.styleName
        cell?.isStyleSelected = style == ZSReader.share.pageStyle
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let style = ZSReaderPageStyle(rawValue: indexPath.row) ?? ZSReader.share.pageStyle
        ZSReader.share.pageStyle = style
        tableView.reloadData()
        delegate?.style(selectionView: self, select: style)
    }
}

class ZSReaderStyleSelectionCell:UITableViewCell {
    
    var isStyleSelected:Bool = false { didSet { selectionView.isHidden = !isStyleSelected } }
    
    lazy var selectionView:UIImageView = {
        let view = UIImageView(image: UIImage(named: "peach_reader_def_xuance2_32_32_32x32_"))
        view.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        view.isHidden = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(selectionView)
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionView.frame = CGRect(x: bounds.width - 32 - 15, y: bounds.height/2 - 16, width: 32, height: 32)
    }
}
