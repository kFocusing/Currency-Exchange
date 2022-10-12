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
    @IBOutlet private weak var exchangeTextField: UITextField!
    @IBOutlet private weak var currencyPickerView: UIPickerView!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        currencyDealTypeImageView.makeCornersRounded()
    }

    // MARK: Internal
    func configure(with exchangeModel: ExchangeModel) {
        dealTypeLabel.text = exchangeModel.dealType.title
        currencyDealTypeImageView.image = exchangeModel.dealType.icon
        currencyDealTypeImageView.backgroundColor = exchangeModel.dealType.color
        if exchangeModel.dealType == .receive {
            exchangeTextField.text = exchangeModel.amountCurrency.amount
        }
    }
}
