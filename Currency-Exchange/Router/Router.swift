//
//  Router.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewContoller()
    func popToRoot()
}

final class Router: RouterProtocol {
    
    var assemblyBuilder: AssemblyBuilderProtocol?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewContoller() {
        guard let mainViewController = assemblyBuilder?.createExchangeModule(router: self) else { return }
        navigationController.viewControllers = [mainViewController]
    }
    
    func popToRoot() {
        navigationController.popViewController(animated: true)
    }
    
}
