//
//  UIViewControllerExtension.swift
//  Currency-Exchange
//
//  Created on 13.10.2022.
//

import UIKit

extension UIViewController {
    func showAlert(with actions: [AlertButtonAction],
                   alertTitle: String?,
                   alertMessage: String?,
                   interfaceStyle: UIUserInterfaceStyle = .light) {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = interfaceStyle
        for value in actions {
            let action = UIAlertAction(title: value.buttonTitle,
                                       style: value.alertStyle,
                                       handler: {
                (alert: UIAlertAction!) -> Void in
                value.completion()
            })
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
