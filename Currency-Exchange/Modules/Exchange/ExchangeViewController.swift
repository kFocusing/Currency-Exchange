//
//  ExchangeViewController.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

final class ExchangeViewController: UIViewController {
    
    // MARK: UIElements
    private lazy var headerPlaceholder: UIView = {
        let headerPlaceholder = UIView()
        headerPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        headerPlaceholder.backgroundColor = .exchangeBlue
        view.addSubview(headerPlaceholder)
        return headerPlaceholder
    }()
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text =  "Currency Convertor"  
        headerLabel.textColor = .white
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.numberOfLines = 1
        return headerLabel
    }()
    
    // MARK: Properties
    var presenter: ExchangeViewPresenterProtocol!
    private let headerPlaceholderHeight: CGFloat = .screenHeight / 8

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUIElements()
        setupUIElements()
    }
    
}

// MARK: - Extensions -
// MARK: ExchangeViewProtocol
extension ExchangeViewController: ExchangeViewProtocol {
    
}

// MARK: Private
extension ExchangeViewController {
    
    // MARK: Private
    private func layoutUIElements() {
        layoutHeaderPlaceholder()
    }
    
    private func setupUIElements() {
        setupBackgroundView()
        setupHeaderPlaceholder()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .white
    }
    
    private func setupHeaderPlaceholder() {
        headerPlaceholder.cornerRadius = .placeholderCornerRadius
        headerPlaceholder.addDropShadow()
    }
    
    private func layoutHeaderPlaceholder() {
        NSLayoutConstraint.activate([
            headerPlaceholder.topAnchor.constraint(equalTo: view.topAnchor),
            headerPlaceholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerPlaceholder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerPlaceholder.heightAnchor.constraint(equalToConstant: headerPlaceholderHeight)
        ])
    }
    
    private func layoutHeaderLabel() {
        NSLayoutConstraint.activate([
            headerPlaceholder.topAnchor.constraint(equalTo: view.topAnchor),
            headerPlaceholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerPlaceholder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerPlaceholder.heightAnchor.constraint(equalToConstant: headerPlaceholderHeight)
        ])
    }
}
