//
//  QSReaderBackgroundViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSReaderBackgroundViewController: UIViewController {

    var backgroundImg:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        backImage.image = backgroundImg
        view.addSubview(backImage)
    }
    
    lazy var backImage:UIImageView = {
       let img = UIImageView()
        img.backgroundColor = UIColor.red
        img.frame = self.view.bounds
        return img
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackground(viewController:PageViewController){
        let image = viewController.view.screenShot()
        self.backgroundImg = image
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
