//
//  CurrencyExchangeCollectionViewCell.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

final class CurrencyExchangeCollectionViewCell: BaseCollectionViewCell {

    // MARK: IBOutlets
    @IBOutlet private weak var currencyDealTypeImageView: UIImageView!
    @IBOutlet private weak var dealTypeLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var currencyPickerView: UIPickerView!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCurrencyDealTypeImageView()
    }

    // MARK: Internal
    func configure(with dealType: DealTypeEnum,
                   and amount: String) {
        amountLabel.text = amount
        dealTypeLabel.text = dealType.title
        currencyDealTypeImageView.image = dealType.icon
    }
}

private extension CurrencyExchangeCollectionViewCell {
    func setupCurrencyDealTypeImageView() {
        currencyDealTypeImageView.makeCornersRounded()
    }
}
