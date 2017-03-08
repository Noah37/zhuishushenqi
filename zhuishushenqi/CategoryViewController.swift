//
//  CategoryViewController.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/11.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func categoryDidSelectAtIndex(_ index:Int)
}

class CategoryViewController: UITableViewController {

    var categoryDelegate:CategoryDelegate?
    var titles:[String] = []
    var selectedIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLineEtched
        tableView.separatorColor = UIColor.gray
        navigationController?.navigationBar.barTintColor = UIColor.black
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Category")
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "bg_back_white"), style: .plain, target: self, action: #selector(dismiss(_:)))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category",for: indexPath) as! CategoryTableViewCell
        cell.count.text = "\(indexPath.row)."
        if titles.count > indexPath.row {
            cell.tittle.text = titles[indexPath.row]
        }
        cell.tittle.textColor =  (selectedIndex == indexPath.row ? UIColor.green:UIColor.black)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryDelegate?.categoryDidSelectAtIndex(indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func dismiss(_ sender:AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    func showCategoryWithViewController(_ vc:OnlineViewController,chapter:Int,titles:NSArray){
        let indexPATH = IndexPath(row: chapter, section: 0)
        self.titles = titles as! [String]
        self.categoryDelegate = vc
        self.selectedIndex = chapter
        let nav = UINavigationController(rootViewController: self)
        vc.present(nav, animated: true,completion: nil)
        self.tableView.scrollToRow(at: indexPATH, at: .middle, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
