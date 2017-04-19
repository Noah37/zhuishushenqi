//
//  QSTextRouter.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/14.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit
class QSTextRouter: QSTextWireframeProtocol {

    weak var viewController: UIViewController?
    
    static func createModule(bookDetail:BookDetail) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = QSTextReaderController(nibName: nil, bundle: nil)
        let interactor = QSTextInteractor()
        let router = QSTextRouter()
        let presenter = QSTextPresenter(interface: view, interactor: interactor, router: router)
        
        view.bookDetail = bookDetail
        view.presenter = presenter
        
        interactor.output = presenter
        
        router.viewController = view
        
        return view
    }
    
    func presentDetails(_ novel: QSRankModel) {
        viewController?.navigationController?.pushViewController(QSRankDetailRouter.createModule(novel:novel), animated: true)
    }
}
