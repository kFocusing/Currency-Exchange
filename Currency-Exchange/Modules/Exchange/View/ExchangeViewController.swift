//
//  ExchangeViewController.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

final class ExchangeViewController: UIViewController {
    
    var presenter: ExchangeViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ExchangeViewController: ExchangeViewProtocol {
    
}
