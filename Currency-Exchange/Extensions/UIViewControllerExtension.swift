//
//  UIViewControllerExtension.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 13.10.2022.
//

import UIKit

extension UIViewController {
    typealias AlertButtonAction = (String, UIAlertAction.Style, EmptyBlock)
    
    func showAlert(with actions: [AlertButtonAction],
                   alertTitle: String?,
                   alertMessage: String?,
                   interfaceStyle: UIUserInterfaceStyle = .light) {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = interfaceStyle
        for value in actions {
            let action = UIAlertAction(title: value.0,
                                       style: value.1,
                                       handler: {
                (alert: UIAlertAction!) -> Void in
                value.2()
            })
            alert.addAction(action)
        }
        
        showAlertOverAllViewControllers(alert)
    }
}

private extension UIViewController {
    private func showAlertOverAllViewControllers(_ alertController: UIAlertController) {
        topMostViewController().present(alertController, animated: true, completion: nil)
    }
    
    private func topMostViewController() -> UIViewController {
        var topViewController: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        while ((topViewController?.presentedViewController) != nil) {
            topViewController = topViewController?.presentedViewController
        }
        return topViewController!
    }
}
