//
//  CategoryViewController.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/11.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func categoryDidSelectAtIndex(index:Int)
}

class CategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var categoryDelegate:CategoryDelegate?
    var titles:[String] = []
    var selectedIndex:Int = 0
    lazy var tableView:UITableView = {
       let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        view.addSubview(self.tableView)
        tableView.separatorStyle = .singleLineEtched
        tableView.separatorColor = UIColor.gray
        tableView.backgroundColor = UIColor.red
        navigationController?.navigationBar.barTintColor = UIColor.black
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Category")
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "bg_back_white"), style: .plain, target: self, action: #selector(dismiss(sender:)))
        navigationItem.leftBarButtonItem = leftItem
        navigationController?.setNavigationBarHidden(true, animated: false)
        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        statusView.backgroundColor = UIColor.red
        //添加阴影也能达到相同的目的
//        let layer = statusView.layer
//        let path = UIBezierPath(rect: layer.bounds)
//        layer.shadowPath = path.cgPath
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize.zero
//        layer.shadowOpacity = 1.0
//        layer.shadowRadius = 10
        self.view.addSubview(statusView)
        setmask(statusBarBackgroundView: statusView)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "space"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let indexPATH = IndexPath(row: selectedIndex, section: 0)
        self.tableView.scrollToRow(at: indexPATH , at: .middle, animated: false)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setmask(statusBarBackgroundView:UIView){
        let gradientLayer = CAGradientLayer()
        let colors = [UIColor(white: 0.0, alpha: 0.0).cgColor,UIColor(white: 0.0, alpha: 0.9).cgColor]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x:0.5,y:0.7)
        gradientLayer.frame = statusBarBackgroundView.bounds
        statusBarBackgroundView.layer.mask = gradientLayer
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category",for: indexPath as IndexPath) as! CategoryTableViewCell
        cell.count.text = "\(indexPath.row)."
        cell.backgroundColor = UIColor.red
        if titles.count > indexPath.row {
            cell.tittle.text = titles[indexPath.row]
        }
        cell.tittle.textColor =  (selectedIndex == indexPath.row ? UIColor.green:UIColor.black)
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryDelegate?.categoryDidSelectAtIndex(index: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismiss(sender:AnyObject){
        dismiss(animated: true, completion: nil)
    }
    
//    override var prefersStatusBarHidden: Bool{
//        return false
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
