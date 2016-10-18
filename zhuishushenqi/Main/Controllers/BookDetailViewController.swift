//
//  BookDetailViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/4.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class BookDetailViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var id:String = ""
    
    private var tagColor = [UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
        UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0),
        UIColor(red: 0.96, green: 0.74, blue: 0.49, alpha: 1.0),
        UIColor(red: 0.57, green: 0.81, blue: 0.84, alpha: 1.0),
        UIColor(red: 0.40, green: 0.80, blue: 0.72, alpha: 1.0),
        UIColor(red: 0.91, green: 0.56, blue: 0.56, alpha: 1.0),
        UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
        UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0)]
    private var sectionTwoY:CGFloat = 0
    private var bookModel:BookDetail?
    private var tableView:UITableView{
        let tableView = UITableView(frame: CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64), style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .SingleLine
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        return tableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        requestData()
    }
    
    private func requestData(){
        let bookDetailApi = BookDetailAPI()
        bookDetailApi.id = id
        bookDetailApi.startWithCompletionBlockWithHUD({ (request) in
            
            self.bookModel = BookDetail.modelWithDictionary(request as! [NSObject : AnyObject])
            self.view.addSubview(self.tableView)
            self.tableView.reloadData()
            }) { (request) in
        }
    }
    
    private func initSubview(){
        let titleView = UIView(frame: CGRectMake(0,0,120,30))
        let titleLabel = UILabel(frame: CGRectMake(0,0,90,30))
        titleLabel.textAlignment = .Center
        titleLabel.text = "书籍详情"
        let titleShare = UIImageView(image: UIImage(named: "bd_share"))
        let width = (titleLabel.text! as NSString).boundingRectWithSize(CGSizeMake(CGFloat.max, 30), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(13)], context: nil)
        titleShare.frame = CGRectMake(width.size.width/2 + 120/2, 5, 20, 20)
        let ges = UITapGestureRecognizer(target: self, action: #selector(shareAction(_:)))
        titleShare.addGestureRecognizer(ges)
        titleView.addSubview(titleShare)
        titleView.addSubview(titleLabel)
        navigationItem.titleView = titleView
        
        let rightItem = UIBarButtonItem(title: "全本缓存", style: .Plain, target: self, action: #selector(allCache(_:)))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func allCache(item:UIBarButtonItem){
        
    }
    
    @objc private func shareAction(tap:UITapGestureRecognizer){
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else if section == 1{
            return 2
        }else if section == 5{
            return 5
        }
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let iden = "CellIden"
        var cell = tableView.dequeueReusableCellWithIdentifier(iden)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: iden)
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectionStyle = .None
        }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
               cell =  sectionOne()
                return cell!
            }else if indexPath.row == 1{
                cell = sectionTwo()
                return cell!
            }else {
                cell = sectionThree()
                return cell!
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            let headerview = (UINib(nibName: "BookDetailHeader", bundle: nil).instantiateWithOwner(self, options: nil) as NSArray).objectAtIndex(0) as? BookDetailHeader
            headerview?.model = bookModel
            if headerview != nil {
                return headerview!
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 165
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 80
            }else if indexPath.row == 1{
                return sectionTwoY
            }else{
                return 120
            }
        }
        return 60
    }
    
    private func sectionOne()->UITableViewCell{
        let  cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.selectionStyle = .None

        let text = ["追书人数","读者留存率","更新字数/天"]
        let sText = [bookModel!.latelyFollower,"\(bookModel!.retentionRatio!)%","\(bookModel!.serializeWordCount!)"]
        let x:CGFloat = 0
        let y:CGFloat = 20
        let width = ScreenWidth/3
        let height:CGFloat = 21.0
        for index in 0..<3 {
            
            let label = UILabel(frame: CGRectMake(x + width*CGFloat(index),y,width,height))
            label.text = text[index]
            label.textAlignment = .Center
            label.textColor = UIColor.grayColor()
            label.font = UIFont.systemFontOfSize(13)
            cell.contentView.addSubview(label)
            
            let slabel = UILabel(frame: CGRectMake(x + width*CGFloat(index),y + 21,width,height))
            slabel.text = sText[index]
            slabel.textAlignment = .Center
            slabel.textColor = UIColor.grayColor()
            slabel.font = UIFont.systemFontOfSize(13)
            cell.contentView.addSubview(slabel)
        }
        return cell
    }
    
    private func sectionTwo()->UITableViewCell{
        let  cell = UITableViewCell(style: .Default, reuseIdentifier: "cellTwo")
        cell.selectionStyle = .None

        var x:CGFloat = 20
        var y:CGFloat = 10
        let spacex:CGFloat = 10
        let spacey:CGFloat = 10
        let height:CGFloat = 30
        for index in 0..<bookModel!.tags!.count {
            let width = widthOfString(bookModel!.tags![index] as! String, font: UIFont.systemFontOfSize(15), height: 21) + 20
            if x + width + 20 > ScreenWidth {
                x = 20
                y = y + spacey + height
            }
            let btn = UIButton(type: .Custom)
            btn.frame = CGRectMake(x, y, width, height)
            btn.setTitle(bookModel!.tags![index] as? String, forState: .Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(15)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            btn.backgroundColor = tagColor[index]
            btn.layer.cornerRadius = 2
            cell.contentView.addSubview(btn)
            
            x = x + width + spacex
        }
        sectionTwoY = y + height + 10
        return cell
    }
    
    private func sectionThree()->UITableViewCell{
        let  cell = UITableViewCell(style: .Default, reuseIdentifier: "cellTwo")
        cell.selectionStyle = .None
//        let height:CGFloat = heightOfString(bookModel!.longIntro!, font: UIFont.systemFontOfSize(15), width: ScreenWidth - 40)
        let label = UILabel(frame: CGRectMake(20,10,ScreenWidth - 40,100))
        label.textAlignment = .Left
        label.font = UIFont.systemFontOfSize(15)
        label.numberOfLines = 100/19
        label.text = bookModel?.longIntro
        label.textColor = UIColor.blackColor()
        cell.contentView.addSubview(label)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
