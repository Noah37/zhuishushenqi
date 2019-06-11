//
//  ZSDetailViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/10.
//  Copyright © 2017年 QS. All rights reserved.
//

class ZSDetailViewController:BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
//        tableView.qs_registerCellClass(<#T##aClass: T.Type##T.Type#>)
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        return tableView
    }()
}

extension ZSDetailViewController {
    fileprivate func setupSubviews() {
        let titleView = UIView(frame: CGRect(x: 0,y: 0,width: 120,height: 30))
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 90,height: 30))
        titleLabel.textAlignment = .center
        titleLabel.text = "书籍详情"
        let titleShare = UIImageView(image: UIImage(named: "bd_share"))
        let width = (titleLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], context: nil)
        titleShare.frame = CGRect(x: width.size.width/2 + 120/2, y: 5, width: 20, height: 20)
        let ges = UITapGestureRecognizer(target: self, action: #selector(shareAction(_:)))
        titleShare.addGestureRecognizer(ges)
        titleView.addSubview(titleShare)
        titleView.addSubview(titleLabel)
        navigationItem.titleView = titleView
        
        let rightItem = UIBarButtonItem(title: "全本缓存", style: .plain, target: self, action: #selector(allCache(_:)))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    fileprivate func allCache(_ item:UIBarButtonItem){
        
    }
    
    @objc
    fileprivate func shareAction(_ tap:UITapGestureRecognizer){
        
    }
}

extension ZSDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
