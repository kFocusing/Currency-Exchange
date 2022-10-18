//
//  CurrencyAmountCollectionViewCell.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

final class CurrencyAmountCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet private weak var currencyAmountLabel: UILabel!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Internal
    func configure(with amountCurrency: AmountCurrency) {
        currencyAmountLabel.text = String(format: "%0.2f",
                                          arguments: [amountCurrency.amount]) + " " + amountCurrency.currency
    }
}

