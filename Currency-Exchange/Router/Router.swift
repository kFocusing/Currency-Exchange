//
//  Router.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

protocol RouterMain {
    
    var navigationController: UINavigationController? { get set }
    var assamblyBuilder: AssamblyBuilderProtocol? { get set }
    
}

protocol RouterProtocol: RouterMain {
    
    func initialViewContoller()
    func popToRoot()
    
}

final class Router: RouterProtocol {
    
    var assamblyBuilder: AssamblyBuilderProtocol?
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController,
         assamblyBuilder: AssamblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assamblyBuilder = assamblyBuilder
    }
    
    func initialViewContoller() {
        if let navigationController = navigationController {
            guard let mainViewController = assamblyBuilder?.createExchangeModule(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
}
