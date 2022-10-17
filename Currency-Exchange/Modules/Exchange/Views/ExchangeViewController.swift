//
//  ExchangeViewController.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

private typealias Localized = Localization.ExchangeScreen

protocol ExchangeViewProtocol: AnyObject {
    func setDataSource(snapshot: NSDiffableDataSourceSnapshot<CurrencySections, AnyHashable>,
                       animated: Bool)
    func reloadItems(_ items: [AnyHashable])
    func updateLayout(sections: [CurrencySections])
    func showError(with alertTitle: String?,
                   and alertMessage: String?)
    func showCurrencyConvertedMessage(with alertTitle: String?,
                                      and alertMessage: String?,
                                      completion: EmptyBlock?)
    func internetConnectionLost(completion: @escaping EmptyBlock)
}

final class ExchangeViewController: UIViewController {
    
    // MARK: UIElements
    private lazy var headerPlaceholder: UIView = {
        let headerPlaceholder = UIView()
        headerPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        headerPlaceholder.backgroundColor = .clear
        headerPlaceholder.clipsToBounds = true
        headerPlaceholder.addDropShadow()
        view.addSubview(headerPlaceholder)
        return headerPlaceholder
    }()
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = Localized.headerTitle
        headerLabel.textColor = .white
        headerLabel.font = .systemFont(ofSize: 17,
                                       weight: .medium)
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
        submitButton.titleLabel?.font = .systemFont(ofSize: 17,
                                                    weight: .medium)
        submitButton.addDropShadow(offset: CGSize(width: 3,
                                                  height: 3))
        submitButton.addTarget(self,
                               action: #selector(submitButtonTapped),
                               for: .touchUpInside)
        view.addSubview(submitButton)
        return submitButton
    }()
    
    private lazy var converterCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.scrollsToTop = false
        collectionView.contentSize = view.bounds.size
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset.top = defaultInset
        collectionView.isScrollEnabled = false
        collectionView.alwaysBounceVertical = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(UINib(nibName: SectionHeaderView.reuseIdentifier, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        CurrencyExchangeCollectionViewCell.registerXIB(in: collectionView)
        CurrencyAmountCollectionViewCell.registerXIB(in: collectionView)
        view.addSubview(collectionView)
        return collectionView
    }()
    
    // MARK: Properties
    var presenter: ExchangeViewPresenterProtocol!
    private var dataSource: ExchangeDataSource!
    private let defaultInset: CGFloat = 16
    private let submitButtonHeight: CGFloat = 50
    private let submitButtonSideInset: CGFloat = 35
    private let submitButtonBottomInset: CGFloat = 20
    private let collectionHeaderSectionHight: CGFloat = 40
    private let currencyBalanceInterItemSpacing: CGFloat = 42
    private let currencyBalanceSectionGroupHeight: CGFloat = 60
    private let currencyExchangeSectionItemHeight: CGFloat = 70
    private let headerPlaceholderHeight: CGFloat = .screenHeight / 9
    private let currencyBalanceSectionItemWidth: CGFloat = .screenWidth / 3
    private let currencyBalanceSectionInsets = NSDirectionalEdgeInsets(top: 8,
                                                                       leading: 16,
                                                                       bottom: 16,
                                                                       trailing: 16)
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
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
    func showError(with alertTitle: String?,
                   and alertMessage: String?) {
        showAlert(with: [(Localized.AlertActions.done,
                          UIAlertAction.Style.default,
                          { return})],
                  alertTitle: alertTitle,
                  alertMessage: alertMessage)
    }
    
    func showCurrencyConvertedMessage(with alertTitle: String?,
                                      and alertMessage: String?,
                                      completion: EmptyBlock? = nil) {
        showAlert(with: [(Localized.AlertActions.cancel,
                          UIAlertAction.Style.cancel,
                          { return }),
                         (Localized.AlertActions.done,
                          UIAlertAction.Style.default,
                          { (completion ?? { return })() })],
                  alertTitle: alertTitle,
                  alertMessage: alertMessage)
    }
    
    func setDataSource(snapshot: NSDiffableDataSourceSnapshot<CurrencySections, AnyHashable>,
                       animated: Bool) {
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    /// Reloads any hashable items - used for updating store after getting new exchange data.
    /// - Parameter items: items to reload.
    func reloadItems(_ items: [AnyHashable]) {
        var newSnapshot = dataSource.snapshot()
        newSnapshot.reloadItems(items)
        
        dataSource.apply(newSnapshot, animatingDifferences: false)
    }
    
    func updateLayout(sections: [CurrencySections]) {
        converterCollectionView.setCollectionViewLayout(createLayout(for: sections),
                                                        animated: false)
    }
    
    func internetConnectionLost(completion: @escaping EmptyBlock){
        converterCollectionView.isHidden = true
        submitButton.isHidden = true
        showError(with: Localized.InternetError.title,
                  and: Localized.InternetError.message)
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
                                                 constant: -submitButtonBottomInset),
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
            widthDimension: .estimated(1),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(currencyBalanceSectionGroupHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(currencyBalanceInterItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = currencyBalanceSectionInsets
        
        let header = self.composeSectionHeader()
        section.boundarySupplementaryItems += [header]
        
        return section
    }
    
    func createCurrencyExchangeSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(currencyExchangeSectionItemHeight)
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
        section.contentInsets.leading = defaultInset
        let header = self.composeSectionHeader()
        section.boundarySupplementaryItems += [header]
        
        return section
    }
    
    func composeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(collectionHeaderSectionHight))
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
                                        dataSource: presenter.dataSource,
                                        didSelectCurrency: { [weak self] currency, dealType in
            if dealType == .sell {
                self?.presenter.getCurrencyExchange(fromAmount: nil,
                                                    fromCurrency: currency.title,
                                                    toCurrency: nil)
            } else {
                self?.presenter.getCurrencyExchange(fromAmount: nil,
                                                    fromCurrency: nil,
                                                    toCurrency: currency.title)
            }
        }, didEnterAmount: { [weak self] amount in
            self?.presenter.didEnterAmount(amount)
        })
        
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
    
    @objc func submitButtonTapped() {
        presenter.convertCurrencyBalance()
    }
}
