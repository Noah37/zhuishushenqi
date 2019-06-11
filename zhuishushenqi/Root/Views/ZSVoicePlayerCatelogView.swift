//
//  ZSVoicePlayerCatelogView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/4/12.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation

typealias ZSVoicePlayerCatelogCellHandler = (_ indexPath:IndexPath)->Void

class ZSVoicePlayerCatelogView: UIView {
    
    var tracks:[XMTrack] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var album:XMAlbum? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var backhandler:ZSVoicePlayerCatelogHandler?
    var cellCickHandler:ZSVoicePlayerCatelogCellHandler?
    
    var selectedIndex:Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    private func setupSubviews() {
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.qs_registerHeaderFooterClass(ZSVoicePlayerCatelogHeaderView.self)
        tableView.qs_registerCellClass(UITableViewCell.self)
        addSubview(tableView)
    }
    
    fileprivate var tableView:UITableView!
    
}

extension ZSVoicePlayerCatelogView:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        let text = "\(indexPath.row + 1) \(tracks[indexPath.row].trackTitle ?? "")"
        let attr = NSMutableAttributedString(string: text)
        if indexPath.row == selectedIndex {
           cell?.accessoryView = UIImageView(image: UIImage(named: "discover_icon_palying_20_14"))
            attr.addAttribute( NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange("\(indexPath.row)".count, attr.length - "\(indexPath.row)".count))
            attr.addAttribute( NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, "\(indexPath.row)".count))


        } else {
           cell?.accessoryView = nil
            attr.addAttribute( NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange("\(indexPath.row)".count, attr.length - "\(indexPath.row)".count))

            attr.addAttribute( NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, "\(indexPath.row)".count))
        }
        
        cell?.textLabel?.attributedText = attr
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSVoicePlayerCatelogHeaderView.self)
        headerView?.backhandler = {
            self.backhandler?()
        }
        if let model = album {
            headerView?.bind(title: model.albumTitle, total: "共\(tracks.count)集")
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        cellCickHandler?(indexPath)
        tableView.reloadData()
    }
}
