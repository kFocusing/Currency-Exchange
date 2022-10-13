//
//  CurrencyAmountCollectionViewCell.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
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
    func configure(with category: AmountCurrency) {
        currencyAmountLabel.text =  "\(category.amount) " + category.currency
    }
}

