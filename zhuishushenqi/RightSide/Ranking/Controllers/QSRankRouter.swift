//
//  QSRankRouter.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

class QSRankRouter: QSRankWireframeProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = QSRankViewController(nibName: nil, bundle: nil)
        let interactor = QSRankInteractor()
        let router = QSRankRouter()
        let presenter = QSRankPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func presentDetails(_ novel: QSRankModel) {
        viewController?.navigationController?.pushViewController(QSRankDetailRouter.createModule(novel:novel), animated: true)
    }
}
