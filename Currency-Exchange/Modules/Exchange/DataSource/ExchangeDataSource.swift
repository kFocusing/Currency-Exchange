//
//  ExchangeDataSource.swift
//  Currency-Exchange
//
//  Created on 12.10.2022.
//

import UIKit

final class ExchangeDataSource: UICollectionViewDiffableDataSource<CurrencySections, AnyHashable> {
    
    // MARK:
    let dataSource: [CurrencySections]
    
    init(
        collectionView: UICollectionView,
        dataSource: [CurrencySections],
        didSelectCurrency: @escaping ((CurrencyEnum, DealTypeEnum) -> Void),
        didEnterAmount: @escaping ((Double, Bool) -> Void)
    ) {
        self.dataSource = dataSource
        
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            if let amountCurrency = item as? AmountCurrency {
                let cell = CurrencyAmountCollectionViewCell.dequeueCellWithType(in: collectionView,
                                                                                indexPath: indexPath)
                cell.configure(with: amountCurrency)
                return cell
            } else if let item = item as? ExchangeModel {
                let cell = CurrencyExchangeCollectionViewCell.dequeueCellWithType(in: collectionView,
                                                                                  indexPath: indexPath)
                cell.configure(with: item)
                cell.didSelectCurrency = { currency, dealType in
                    didSelectCurrency(currency, dealType)
                }
                cell.didEnterAmount = { amount, neededDelay in
                    didEnterAmount(amount, neededDelay)
                }
                return cell
            } else {
                fatalError("Unknown cell type")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let section = dataSource[indexPath.section]
        switch section {
        case .currencyBalance:
            return CurrencyAmountCollectionViewCell.reuseIdentifier
        case .currencyExchange:
            return CurrencyExchangeCollectionViewCell.reuseIdentifier
        }
    }
}
