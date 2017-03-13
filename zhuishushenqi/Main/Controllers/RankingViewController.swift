//
//  RankingViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/19.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
import QSNetwork
import QSKingfisher

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class RankingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    fileprivate var tableView:UITableView?
    
    fileprivate var maleRank:[QSRankModel]? = [QSRankModel]()
    fileprivate var femaleRank:[QSRankModel]? = [QSRankModel]()
    fileprivate var maleImage:NSArray = ["userCenter_msg","zuire","zuire","zuire","zuire","ranking_other"]
    fileprivate var femaleImage:NSArray = ["zuire","zuire","zuire","zuire","zuire","zuire"]

    fileprivate var showMale:Bool = false
    fileprivate var showFemale:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        title = "排行榜"
        initSubview()
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.isNavigationBarHidden == false{
            self.tableView!.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    fileprivate func initSubview(){
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 44, 0, 0)
        
        tableView.register(RankingViewCell.self, forCellReuseIdentifier: "RankingViewCell")
        self.tableView = tableView
    }
    
    fileprivate func requestData(){
//        QSNetwork.setDefaultURL(url: baseUrl)
        
        QSNetwork.request("\(baseUrl)/\(ranking)") { (response) in
            if let data = response.data {
                do{
                    let dict:NSDictionary? = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    if let male:[Any] = dict?["male"] as? [Any] {
                        
                       self.maleRank = try XYCBaseModel.model(withModleClass: QSRankModel.self, withJsArray: male) as? [QSRankModel]
                        //添加别人家的榜单
                        let otherRank = QSRankModel()
                        otherRank.title = "别人家的榜单"
                        otherRank.image = "ranking_other"
                        self.maleRank?.insert(otherRank, at: 5)
                    }
                    if let female:[Any] = dict?["female"] as? [Any] {
                        
                        self.femaleRank = try XYCBaseModel.model(withModleClass: QSRankModel.self, withJsArray: female ) as? [QSRankModel]
                        let otherRank = QSRankModel()
                        otherRank.title = "别人家的榜单"
                        otherRank.image = "ranking_other"
                        self.femaleRank?.insert(otherRank, at: 5)
                    }
                    
                    DispatchQueue.main.async {
                        self.view.addSubview(self.tableView!)
                        self.tableView?.reloadData()
                    }
                }catch{
                    
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (showMale ? maleRank!.count : 6)
        }else if section == 1{
            return (showFemale ? femaleRank!.count : 6)
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iden = "RankingViewCell"
        var cell:RankingViewCell? = tableView.dequeueReusableCell(withIdentifier: iden) as? RankingViewCell
        if cell == nil {
            cell = RankingViewCell(style: .default, reuseIdentifier: iden)
        }
        cell?.imageView?.contentMode = .scaleAspectFill
            cell?.backgroundColor = UIColor.white
            cell?.selectionStyle = .none
        
        var rank:[QSRankModel]? = [QSRankModel]()
        indexPath.section == 0 ? (rank = maleRank) : (rank = femaleRank)
        cell?.model = rank?[indexPath.row]
            cell?.accessoryClosure = {
                if indexPath.section == 0 {
                    self.showMale = !self.showMale
                    self.tableView?.reloadData()
                }else{
                    self.showFemale = !self.showFemale
                    self.tableView?.reloadData()
                }
            }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 60))
            let label = UILabel(frame: CGRect(x: 15,y: 15,width: 100,height: 15))
            label.textColor = UIColor.gray
            label.font = UIFont.systemFont(ofSize: 11)
            label.text = "男生"
            headerView.addSubview(label)
            return headerView;
        }else if section == 1{
            let headerView = UIView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 60))
            let label = UILabel(frame: CGRect(x: 15,y: 15,width: 100,height: 15))
            label.textColor = UIColor.gray
            label.font = UIFont.systemFont(ofSize: 11)
            label.text = "女生"
            headerView.addSubview(label)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var rank:[[QSRankModel]] = [maleRank!,femaleRank!]
        if indexPath.row == 5{
            if indexPath.section == 0 {
                showMale = !showMale
            }else{
                showFemale = !showFemale
            }
            let cell:RankingViewCell? = self.tableView?.cellForRow(at: indexPath) as? RankingViewCell
            cell?.accessoryImageView.isSelected = showMale
            self.tableView?.reloadData()
            return
        }
        let topVC = TopDetailViewController()
        topVC.id = rank[indexPath.section][indexPath.row]._id
        topVC.title = rank[indexPath.section][indexPath.row].title
        topVC.model = rank[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(topVC, animated: true)

    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    func imageHasAlpha(image:UIImage)->Bool{
        let alpha:CGImageAlphaInfo? = image.cgImage?.alphaInfo
        return (alpha == CGImageAlphaInfo.first || alpha == CGImageAlphaInfo.last  || alpha == CGImageAlphaInfo.premultipliedLast || alpha == CGImageAlphaInfo.premultipliedFirst)
        
    }
    
    func image2DataURL(image:UIImage) -> String? {
        var imageData:Data?
        var mimeType:String?
        if self.imageHasAlpha(image: image) {
            imageData = UIImagePNGRepresentation(image)
            mimeType = "image/png"
        }else{
            imageData = UIImageJPEGRepresentation(image, 1.0)
            mimeType = "image/jpeg"
        }
        return imageData?.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func base64ToImage(imageSrc:String) -> UIImage? {
        let data:Data? = Data(base64Encoded: imageSrc, options: .ignoreUnknownCharacters)
        if let decodeData = data{
            return UIImage(data: decodeData)
        }
        return nil
    }
    
    func imageFromUrl(url:String)->UIImage?{
        var image:UIImage?
        DispatchQueue.global().async {
            do{
                let url:URL? = URL(string: url)
                if let imageUrl = url {
                    let data:Data = try Data(contentsOf: imageUrl, options: .alwaysMapped)
                    image = UIImage(data: data)
                }
                
            }catch{
                print(error)
            }
        }
        return image
    }
}

public class QSResource:Resource{
    
    
    public var imageURL:URL? = URL(string: "http://statics.zhuishushenqi.com/ranking-cover/142319144267827")
    public var downloadURL: URL {
        return imageURL!
    }
    
    public var cacheKey: String{
        return "\(self.imageURL)"
    }
    
    init(url:URL) {
        self.imageURL = url
    }
}
