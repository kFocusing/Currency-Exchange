//
//  AssemblyModelBuilder.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createExchangeModule(router: RouterProtocol) -> UIViewController
}

final class AssemblyModelBuilder: AssemblyBuilderProtocol {
    
    func createExchangeModule(router: RouterProtocol) -> UIViewController {
        let view = ExchangeViewController()
        let networkService = NetworkService()
        let presenter = ExchangePresenter(view: view,
                                          networkService: networkService,
                                          router: router)
        view.presenter = presenter
        return view
    }
    
}

