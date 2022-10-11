//
//  ExchangeViewController.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

private typealias Localized = Localization.ExchangeScreen

final class ExchangeViewController: UIViewController {
    
    // MARK: UIElements
    private lazy var headerPlaceholder: UIView = {
        let headerPlaceholder = UIView()
        headerPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        headerPlaceholder.backgroundColor = Colors.exchangeBlue.color
        headerPlaceholder.cornerRadius = .placeholderCornerRadius
        headerPlaceholder.addDropShadow()
        view.addSubview(headerPlaceholder)
        return headerPlaceholder
    }()
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = Localized.title
        headerLabel.textColor = .white
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.numberOfLines = 1
        headerPlaceholder.addSubview(headerLabel)
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
        layoutHeaderLabel()
    }
    
    private func setupUIElements() {
        setupBackgroundView()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .white
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
            headerLabel.centerXAnchor.constraint(equalTo: headerPlaceholder.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerPlaceholder.centerYAnchor,
                                                 constant: .safeAreaInsetTop.halfDevide)
        ])
    }
}
