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
        submitButton.setTitleColor(.white,
                                   for: .normal)
        submitButton.cornerRadius = submitButtonHeight.halfDevide
        submitButton.addDropShadow(offset: CGSize(width: 3,
                                                  height: 3))
        view.addSubview(submitButton)
        return submitButton
    }()
    
    private lazy var converterCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        CurrencyExchangeCollectionViewCell.registerXIB(in: collectionView)
        CurrencyAmountCollectionViewCell.registerXIB(in: collectionView)
        view.addSubview(collectionView)
        return collectionView
    }()

    // MARK: Properties
    var presenter: ExchangeViewPresenterProtocol!
    private let headerPlaceholderHeight: CGFloat = .screenHeight / 8
    private let submitButtonSideInset: CGFloat = 45
    private let submitButtonHeight: CGFloat = 60
    
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

// MARK: UICollectionViewDataSource
extension ExchangeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = CurrencyAmountCollectionViewCell.dequeueCellWithType(in: collectionView,
                                                                            indexPath: indexPath)
            cell.configure(with: presenter.getCurrency(at: indexPath.item))
            return cell
        } else if indexPath.section == 1 {
            let cell = CurrencyExchangeCollectionViewCell.dequeueCellWithType(in: collectionView,
                                                                              indexPath: indexPath)
            cell.configure(with: presenter.getDealType(at: indexPath.item),
                           and: "1000")
            return cell
        }
        return UICollectionViewCell()
    }
}

private extension ExchangeViewController {
    
    // MARK: Private
    func layoutUIElements() {
        layoutHeaderPlaceholder()
        layoutHeaderLabel()
        layoutConverterCollectionView()
        layoutSubmitButton()
    }
    
    func setupElements() {
        setupBackgroundView()
    }
    
    func setupBackgroundView() {
        view.backgroundColor = .white
    }
    
    func layoutHeaderPlaceholder() {
        NSLayoutConstraint.activate([
            headerPlaceholder.topAnchor.constraint(equalTo: view.topAnchor),
            headerPlaceholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerPlaceholder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerPlaceholder.heightAnchor.constraint(equalToConstant: headerPlaceholderHeight)
        ])
    }
    
    func layoutHeaderLabel() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: headerPlaceholder.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerPlaceholder.centerYAnchor,
                                                 constant: .safeAreaInsetTop.halfDevide)
        ])
    }
    
    func layoutSubmitButton() {
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: submitButtonSideInset),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -submitButtonSideInset),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: submitButtonHeight)
        ])
    }
    
    func layoutConverterCollectionView() {
        NSLayoutConstraint.activate([
            converterCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            converterCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            converterCollectionView.topAnchor.constraint(equalTo: headerPlaceholder.bottomAnchor,
                                                         constant: 30),
            converterCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func createCurrencyBalanceSectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(30)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: group)
            let header = self.composeSectionHeader()
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }
    
    func createCurrencyExchangeSectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: group)
            let header = self.composeSectionHeader()
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }
    
    func composeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(72))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return header
    }
    
}
