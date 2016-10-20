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

class CategoryViewController: UITableViewController {

    var categoryDelegate:CategoryDelegate?
    var titles:[String] = []
    var selectedIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .SingleLineEtched
        tableView.separatorColor = UIColor.grayColor()
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        tableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Category")
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "bg_back_white"), style: .Plain, target: self, action: #selector(dismiss(_:)))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Category",forIndexPath: indexPath) as! CategoryTableViewCell
        cell.count.text = "\(indexPath.row)."
        if titles.count > indexPath.row {
            cell.tittle.text = titles[indexPath.row]
        }
        cell.tittle.textColor =  (selectedIndex == indexPath.row ? UIColor.greenColor():UIColor.blackColor())
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        categoryDelegate?.categoryDidSelectAtIndex(indexPath.row)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func dismiss(sender:AnyObject){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showCategoryWithViewController(vc:OnlineViewController,chapter:Int,titles:NSArray){
        let indexPATH = NSIndexPath(forRow: chapter, inSection: 0)
        self.titles = titles as! [String]
        self.categoryDelegate = vc
        self.selectedIndex = chapter
        let nav = UINavigationController(rootViewController: self)
        vc.presentViewController(nav, animated: true,completion: nil)
        self.tableView.scrollToRowAtIndexPath(indexPATH, atScrollPosition: .Middle, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
