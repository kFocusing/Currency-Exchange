//
//  AssemblyModelBuilder.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

protocol AssamblyBuilderProtocol {
    
    func createExchangeModule(router: RouterProtocol) -> UIViewController
    
}

final class AssamblyModelBuilder: AssamblyBuilderProtocol {
    
    func createExchangeModule(router: RouterProtocol) -> UIViewController {
        let view = ExchangeViewController()
        let presenter = ExchangePresenter(view: view,
                                      router: router)
        view.presenter = presenter
        return view
    }
    
}

