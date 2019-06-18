//
//  ZSSpeakerViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/11.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit
import Zip
import Kingfisher

class ZSSpeakerViewController: UIViewController {
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame:  CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.qs_registerCellClass(QSMoreSettingCell.self)
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.qs_registerCellClass(ZSSpeakerCell.self)
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.frame = self.view.bounds
    }
    
}

extension ZSSpeakerViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  TTSConfig.share.allSpeakers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSSpeakerCell.self)
        cell?.accessoryType = .disclosureIndicator
        let speaker = TTSConfig.share.allSpeakers[indexPath.row]
        let url = URL(string: speaker.largeIcon) ?? URL(string:"www.baidu.com")!
        let resource:QSResource = QSResource(url: url)
        cell?.imageView?.kf.setImage(with: resource)
        cell?.textLabel?.text = speaker.nickname
        cell?.detailTextLabel?.text = speaker.accent
        let fileName = "\(speaker.name).jet"
        let jet = "\(filePath)\(fileName)"
        let exist = FileManager.default.fileExists(atPath: jet)
        
        cell?.download.isSelected = exist
        cell?.downloadHandler = { _ in
            downloadFile(urlString: speaker.downloadUrl, handler: { (response) in
                if let url = response as? URL {
                    self.unzip(fileURL: url)
                    self.tableView.reloadData()
                }
            })
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func unzip(fileURL:URL) {
        do {
            let documentsDirectory = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0].appendingPathComponent("/speakerres/3589709422/", isDirectory: true)
            try Zip.unzipFile(fileURL, destination: documentsDirectory, overwrite: true, password: nil, progress: { (progress) -> () in
                print(progress)
            }) // Unzip
        }
        catch {
            print("Something went wrong")
        }
    }
}
