//
//  BaseViewController.swift
//  Currency-Exchange
//
//  Created on 18.10.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: UIElements
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.backgroundColor = .lightGray
        activityIndicator.style = .large
        activityIndicator.cornerRadius = activityIndicatorCornerRadius
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    // MARK: Properties
    private let activityIndicatorSide: CGFloat = .screenWidth / 5
    private let activityIndicatorCornerRadius: CGFloat = 15
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Internal
    func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func layoutActivityIndicator(to view: UIView) {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: activityIndicatorSide),
            activityIndicator.heightAnchor.constraint(equalToConstant: activityIndicatorSide)
        ])
    }
}

