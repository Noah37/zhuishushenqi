//
//  BookDetailViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/4.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
import QSNetwork

class BookDetailViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var id:String = ""
    
    fileprivate var tagColor = [UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
        UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0),
        UIColor(red: 0.96, green: 0.74, blue: 0.49, alpha: 1.0),
        UIColor(red: 0.57, green: 0.81, blue: 0.84, alpha: 1.0),
        UIColor(red: 0.40, green: 0.80, blue: 0.72, alpha: 1.0),
        UIColor(red: 0.91, green: 0.56, blue: 0.56, alpha: 1.0),
        UIColor(red: 0.56, green: 0.77, blue: 0.94, alpha: 1.0),
        UIColor(red: 0.75, green: 0.41, blue: 0.82, alpha: 1.0)]
    fileprivate var sectionTwoY:CGFloat = 0
    fileprivate var bookModel:BookDetail?
    fileprivate var tableView:UITableView{
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        return tableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        requestData()
    }
    
    fileprivate func requestData(){
        let url = "\(baseUrl)/book/\(id)"
//        QSNetwork.setDefaultURL(url: baseUrl)
        QSNetwork.request(url, method: HTTPMethodType.get, parameters: nil, headers: nil) { (response) in
            do{
                if let json = response.json as? [AnyHashable : Any]{
                    self.bookModel = BookDetail.model(with: json)
                }
                DispatchQueue.main.sync {
                    self.view.addSubview(self.tableView)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    fileprivate func initSubview(){
        let titleView = UIView(frame: CGRect(x: 0,y: 0,width: 120,height: 30))
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 90,height: 30))
        titleLabel.textAlignment = .center
        titleLabel.text = "书籍详情"
        let titleShare = UIImageView(image: UIImage(named: "bd_share"))
        let width = (titleLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 13)], context: nil)
        titleShare.frame = CGRect(x: width.size.width/2 + 120/2, y: 5, width: 20, height: 20)
        let ges = UITapGestureRecognizer(target: self, action: #selector(shareAction(_:)))
        titleShare.addGestureRecognizer(ges)
        titleView.addSubview(titleShare)
        titleView.addSubview(titleLabel)
        navigationItem.titleView = titleView
        
        let rightItem = UIBarButtonItem(title: "全本缓存", style: .plain, target: self, action: #selector(allCache(_:)))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc fileprivate func allCache(_ item:UIBarButtonItem){
        
    }
    
    @objc fileprivate func shareAction(_ tap:UITapGestureRecognizer){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else if section == 1{
            return 2
        }else if section == 5{
            return 5
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iden = "CellIden"
        var cell = tableView.dequeueReusableCell(withIdentifier: iden)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: iden)
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = .none
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            let headerview = (UINib(nibName: "BookDetailHeader", bundle: nil).instantiate(withOwner: self, options: nil) as NSArray).object(at: 0) as? BookDetailHeader
            headerview?.model = bookModel
            headerview?.addBtnAction = { (isSelected:Bool,model:BookDetail) in
                let mArr = NSMutableArray(array: BookShelfInfo.books.bookShelf)
                if isSelected == true {
                    mArr.add(model)
                }else{
                    mArr.remove(model)
                }
                print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
                    BookShelfInfo.books.bookShelf = mArr
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "BookShelfRefresh")))
            }
            if headerview != nil {
                return headerview!
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    fileprivate func sectionOne()->UITableViewCell{
        let  cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.selectionStyle = .none

        let text = ["追书人数","读者留存率","更新字数/天"]
        let sText = [bookModel!.latelyFollower,"\(bookModel?.retentionRatio ?? "0")%","\(bookModel!.serializeWordCount)"]
        let x:CGFloat = 0
        let y:CGFloat = 20
        let width = ScreenWidth/3
        let height:CGFloat = 21.0
        for index in 0..<3 {
            
            let label = UILabel(frame: CGRect(x: x + width*CGFloat(index),y: y,width: width,height: height))
            label.text = text[index]
            label.textAlignment = .center
            label.textColor = UIColor.gray
            label.font = UIFont.systemFont(ofSize: 13)
            cell.contentView.addSubview(label)
            
            let slabel = UILabel(frame: CGRect(x: x + width*CGFloat(index),y: y + 21,width: width,height: height))
            slabel.text = sText[index]
            slabel.textAlignment = .center
            slabel.textColor = UIColor.gray
            slabel.font = UIFont.systemFont(ofSize: 13)
            cell.contentView.addSubview(slabel)
        }
        return cell
    }
    
    fileprivate func sectionTwo()->UITableViewCell{
        let  cell = UITableViewCell(style: .default, reuseIdentifier: "cellTwo")
        cell.selectionStyle = .none

        var x:CGFloat = 20
        var y:CGFloat = 10
        let spacex:CGFloat = 10
        let spacey:CGFloat = 10
        let height:CGFloat = 30
        for index in 0..<bookModel!.tags!.count {
            let width = widthOfString(bookModel!.tags![index] as! String, font: UIFont.systemFont(ofSize: 15), height: 21) + 20
            if x + width + 20 > ScreenWidth {
                x = 20
                y = y + spacey + height
            }
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            btn.setTitle(bookModel!.tags![index] as? String, for: UIControlState())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.backgroundColor = tagColor[index]
            btn.layer.cornerRadius = 2
            cell.contentView.addSubview(btn)
            
            x = x + width + spacex
        }
        sectionTwoY = y + height + 10
        return cell
    }
    
    fileprivate func sectionThree()->UITableViewCell{
        let  cell = UITableViewCell(style: .default, reuseIdentifier: "cellTwo")
        cell.selectionStyle = .none
//        let height:CGFloat = heightOfString(bookModel!.longIntro!, font: UIFont.systemFontOfSize(15), width: ScreenWidth - 40)
        let label = UILabel(frame: CGRect(x: 20,y: 10,width: ScreenWidth - 40,height: 100))
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 100/19
        label.text = bookModel?.longIntro
        label.textColor = UIColor.black
        cell.contentView.addSubview(label)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}