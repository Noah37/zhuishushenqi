//
//  ZSFontViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/9/13.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

typealias ZSClickHandler = ()->Void

class ZSFontViewController: ZSBaseTableViewController {
    
    var viewModel = ZSFontViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.copyFont()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fonts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSFontViewCell.self)
        let image = viewModel.fonts[indexPath.row]["image"] ?? ""
        if image == "" {
            cell?.textLabel?.text = viewModel.fonts[indexPath.row]["name"]
        } else {
            cell?.imageView?.image = UIImage(named: image)
        }
        let exist = viewModel.fileExist(indexPath: indexPath)
        if exist {
            cell?.setDownloadType(type: .finished)
        } else {
            cell?.setDownloadType(type: .notdown)
        }
        if indexPath == viewModel.selectedIndexPath {
            cell?.setDownloadType(type: .inuse)
        }
        cell?.downloadHandler = {
            if cell?.type == .notdown {
                self.viewModel.fetchFont(indexPath: indexPath, handler: { (finished) in
                    if finished! {
                        cell?.setDownloadType(type: .finished)
                    }
                })
            } else if cell?.type == .finished {
                self.viewModel.selectedIndexPath = indexPath
                cell?.setDownloadType(type: .inuse)
                self.tableView.reloadData()
            }
        }
        return cell!
    }
    
    override func registerCellClasses() -> Array<AnyClass> {
        return [ZSFontViewCell.self]
    }
}

class ZSFontViewCell: UITableViewCell {
    
    enum ZSDownloadType {
        case notdown
        case finished
        case inuse
    }
    
    var download:UIButton = UIButton(type: .custom)
    
    var downloadHandler:ZSClickHandler?
    
    var type:ZSDownloadType = .notdown
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setDownloadType(type: .notdown)
        download.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        download.setTitleColor(UIColor.red, for: .normal)
        download.layer.borderColor = UIColor.red.cgColor
        download.layer.borderWidth = 0.5
        download.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        download.addTarget(self, action: #selector(downloadAction(sender:)), for: .touchUpInside)
        self.accessoryView = download
        self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func downloadAction(sender:UIButton) {
        downloadHandler?()
    }
    
    func setDownloadType(type:ZSDownloadType) {
        self.type = type
        if type == .finished {
            self.download.setTitle("启用", for: .normal)
            self.download.setTitleColor(UIColor.white, for: .normal)
            self.download.backgroundColor = UIColor.red
            self.download.isEnabled = true
            self.download.layer.borderColor = UIColor.red.cgColor
        } else if type == .inuse {
            self.download.setTitle("使用中", for: .normal)
            self.download.isEnabled = false
            self.download.setTitleColor(UIColor.black, for: .normal)
            self.download.backgroundColor = UIColor.white
            self.download.layer.borderColor = UIColor.clear.cgColor
        } else if type == .notdown {
            self.download.setTitle("下载", for: .normal)
            self.download.isEnabled = true
            self.download.setTitleColor(UIColor.red, for: .normal)
            self.download.backgroundColor = UIColor.white
            self.download.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    override func prepareForReuse() {
        self.setDownloadType(type: .notdown)
    }
}
