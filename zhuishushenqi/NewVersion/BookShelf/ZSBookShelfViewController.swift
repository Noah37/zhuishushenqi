//
//  ZSBookShelfViewController.swift
//  Alamofire
//
//  Created by caony on 2019/6/17.
//

import UIKit
import SnapKit

class ZSBookShelfViewController: BaseViewController, NavigationBarDelegate {
    lazy var navImages:[UIImage] = {
        var images:[UIImage] = []
        if let giftImage = UIImage(named: "bookshelf_icon_gift_34_34") {
            images.append(giftImage)
        }
        if let searchImage = UIImage(named: "bookshelf_icon_seach_34_34") {
            images.append(searchImage)
        }
        if let historyImage = UIImage(named: "bookshelf_icon_history_34_34") {
            images.append(historyImage)
        }
        if let moreImage = UIImage(named: "bookshelf_icon_more_34_34") {
            images.append(moreImage)
        }
        return images
    }()
    
    lazy var navView:NavigationBar = {
        let navView = NavigationBar(navImages: self.navImages, delegate: self)
        return navView
    }()
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        navView.snp.remakeConstraints { (make) in
            make
        }
        tableView.snp.remakeConstraints { (make) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = view.bounds
    }
    
    func navView(navView: NavigationBar, didSelect at: Int) {
        
    }
}

extension ZSBookShelfViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
