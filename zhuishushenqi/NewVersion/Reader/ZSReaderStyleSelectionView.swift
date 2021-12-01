//
//  ZSReaderStyleSelectionView.swift
//  zhuishushenqi
//
//  Created by yung on 2020/2/1.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderStyleSelectionViewDelegate:class {
    func style(selectionView:ZSReaderStyleSelectionView, select style:ZSReaderPageStyle)
}

class ZSReaderStyleSelectionView: UIButton, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate:ZSReaderStyleSelectionViewDelegate?
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        tableView.backgroundColor = UIColor.black
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.qs_registerCellClass(ZSReaderStyleSelectionCell.self)
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    var style:ZSReaderPageStyle!

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.black
        addSubview(tableView)
        addTarget(self, action: #selector(touchAction(bt:)), for: .touchUpInside)
        style = ZSReader.share.pageStyle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    @objc
    private func touchAction(bt:UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZSReaderPageStyle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSReaderStyleSelectionCell.self)
        let pageStyle = ZSReaderPageStyle(rawValue: indexPath.row)
        cell?.contentView.backgroundColor = UIColor.black
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.text = pageStyle?.styleName
        cell?.isStyleSelected = pageStyle == style
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageStyle:ZSReaderPageStyle = ZSReaderPageStyle(rawValue: indexPath.row) ?? style
        style = pageStyle
        tableView.reloadData()
        delegate?.style(selectionView: self, select: pageStyle)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
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
