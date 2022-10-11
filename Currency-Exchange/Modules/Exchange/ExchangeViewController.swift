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
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = Localized.headerTitle
        headerLabel.textColor = .white
                headerLabel.numberOfLines = 1
        headerPlaceholder.addSubview(headerLabel)
        return headerLabel
    }()
    
    private lazy var submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = Colors.exchangeBlue.color
        submitButton.setTitle(Localized.buttonTitle,
                              for: .normal)
        submitButton.setTitleColor(Colors.exchangeBlue.color,
                                   for: .normal)
        submitButton.cornerRadius = buttonHeight.halfDevide
        submitButton.addDropShadow(offset: CGSize(width: 3,
                                                  height: 3))
        view.addSubview(submitButton)
        return submitButton
    }()
    
    // MARK: Properties
    var presenter: ExchangeViewPresenterProtocol!
    private let headerPlaceholderHeight: CGFloat = .screenHeight / 8
    private let buttonSideInset: CGFloat = 45
    private let buttonHeight: CGFloat = 60
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUIElements()
        setupElements()
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
        layoutSubmitButton()
    }
    
    private func setupElements() {
        setupBackgroundView()
        setupNotificationCenter()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .white
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillMove), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillMove), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
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
    
    private func layoutSubmitButton() {
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: buttonSideInset),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -buttonSideInset),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    @objc private func keyboardWillMove(sender: NSNotification) {
        // TODO: Move button when let's get into the method
    }
    
}
