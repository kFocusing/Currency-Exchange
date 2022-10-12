//
//  ExchangeViewController.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

private typealias Localized = Localization.ExchangeScreen

protocol ExchangeViewProtocol: AnyObject {
    func setDataSource(snapshot: NSDiffableDataSourceSnapshot<CurrencySections, AnyHashable>,
                       animated: Bool)
    func updateLayout(sections: [CurrencySections])
    func showErrorAlert(with message: String?)
}

final class ExchangeViewController: UIViewController {
    
    // MARK: UIElements
    private lazy var headerPlaceholder: UIView = {
        let headerPlaceholder = UIView()
        headerPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        headerPlaceholder.backgroundColor = .clear
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
        submitButton.backgroundColor = .clear
        submitButton.setTitle(Localized.buttonTitle,
                              for: .normal)
        submitButton.setTitleColor(.white,
                                   for: .normal)
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset.top = 16
        collectionView.register(UINib(nibName: SectionHeaderView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        CurrencyExchangeCollectionViewCell.registerXIB(in: collectionView)
        CurrencyAmountCollectionViewCell.registerXIB(in: collectionView)
        view.addSubview(collectionView)
        return collectionView
    }()
    
    // MARK: Properties
    var presenter: ExchangeViewPresenterProtocol!
    private var dataSource: ExchangeDataSource!
    
    private let headerPlaceholderHeight: CGFloat = .screenHeight / 8
    private let submitButtonSideInset: CGFloat = 45
    private let submitButtonHeight: CGFloat = 60
    private let defaultInset: CGFloat = 16
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        layoutUIElements()
        setupBackgroundView()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupGradients()
    }
}

// MARK: - Extensions -
// MARK: ExchangeViewProtocol
extension ExchangeViewController: ExchangeViewProtocol {
    func setDataSource(snapshot: NSDiffableDataSourceSnapshot<CurrencySections, AnyHashable>,
                       animated: Bool) {
        dataSource.apply(snapshot, animatingDifferences: animated) {
            //            DispatchQueue.main.async { [weak self] in
            //
            ////                self?.hideLoadingState()
            //            }
        }
    }
    
    func updateLayout(sections: [CurrencySections]) {
        converterCollectionView.setCollectionViewLayout(createLayout(for: sections),
                                                        animated: false)
    }
    
    func showErrorAlert(with message: String?) {
        let alert = UIAlertController(title: message ?? "",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
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
    
    func setupBackgroundView() {
        view.backgroundColor = .white
    }
    
    func setupGradients() {
        let headerPlaceholderGradient = CAGradientLayer.gradientLayer(in: headerPlaceholder.bounds)
        headerPlaceholderGradient.cornerRadius = .placeholderCornerRadius
        headerPlaceholder.layer.insertSublayer(headerPlaceholderGradient, at: 0)
        
        let submitButtonGradient = CAGradientLayer.gradientLayer(in: submitButton.bounds)
        submitButtonGradient.cornerRadius = submitButton.bounds.height.halfDevide
        submitButton.layer.insertSublayer(submitButtonGradient, at: 0)
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
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor,
                                                 constant: -10),
            submitButton.heightAnchor.constraint(equalToConstant: submitButtonHeight)
        ])
    }
    
    func layoutConverterCollectionView() {
        NSLayoutConstraint.activate([
            converterCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            converterCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            converterCollectionView.topAnchor.constraint(equalTo: headerPlaceholder.bottomAnchor),
            converterCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func createCurrencyBalanceSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(.screenWidth / 3),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 16
        section.contentInsets.trailing = 16
        let header = self.composeSectionHeader()
        section.boundarySupplementaryItems += [header]
        
        return section
    }
    
    func createCurrencyExchangeSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 16
        let header = self.composeSectionHeader()
        section.boundarySupplementaryItems += [header]

        return section
    }
    
    func composeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return header
    }
    
    func createLayout(for sections: [CurrencySections]) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment)
            -> NSCollectionLayoutSection? in
            guard sections.count > sectionIndex,
                  let self = self else { return nil }
            
            let section = sections[sectionIndex]
            
            switch section {
            case .currencyBalance:
                return self.createCurrencyBalanceSectionLayout()
            case .currencyExchange:
                return self.createCurrencyExchangeSectionLayout()
            }
        }
        return layout
    }
    
    func setupDataSource() {
        dataSource = ExchangeDataSource(collectionView: converterCollectionView,
                                        dataSource: presenter.dataSource)
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let section = presenter.dataSource[indexPath.section]
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView
                headerView?.configure(with: section.title)
                return headerView
            default:
                return nil
            }
        }
    }
    
}
