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
    @IBOutlet private weak var currencyTextField: UITextField!
    @IBOutlet private weak var exchangeStatus: UILabel!
    @IBOutlet private weak var pickCurrencyChevron: UIImageView!
    
    // MARK: UIElements
    private let currencyPicker = UIPickerView()
    
    // MARK: Properties
    private let pickerViewDataSource: [CurrencyEnum] = [.euro,
                                                        .americanDollar,
                                                        .japaneseYen]
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        currencyDealTypeImageView.makeCornersRounded()
        setupCurrencyPicker()
        setupCurrencyExchangeTextField()
    }
    
    // MARK: Internal
    func configure(with exchangeModel: ExchangeModel) {
        dealTypeLabel.text = exchangeModel.dealType.title
        currencyDealTypeImageView.image = exchangeModel.dealType.icon
        currencyDealTypeImageView.backgroundColor = exchangeModel.dealType.color
        
        if exchangeModel.dealType == .receive {
            exchangeTextField.text = exchangeModel.amountCurrency.amount
            exchangeTextField.textColor = Colors.exchangeGeen.color
            currencyTextField.text = exchangeModel.amountCurrency.currency
            
            exchangeStatus.textColor = Colors.exchangeGeen.color
            exchangeTextField.isUserInteractionEnabled = false
        }
    }
}

// MARK: - Extensions -
// MARK: UIPickerViewDelegate
extension CurrencyExchangeCollectionViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        currencyTextField.text = pickerViewDataSource[row].title
        pickCurrencyChevron.image = UIImage(systemName: "chevron.down")
        self.endEditing(true)
    }
}

// MARK: UIPickerViewDataSource
extension CurrencyExchangeCollectionViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return pickerViewDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        pickCurrencyChevron.image = UIImage(systemName: "chevron.up")
        return pickerViewDataSource[row].title
    }
}

// MARK: UITextFieldDelegate
extension CurrencyExchangeCollectionViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let decimalSeparator = NSLocale.current.decimalSeparator ?? "."
        let limitBeforeSeparator = 4
        let limitAfterSeparator = 2
        
        let text = (textField.text ?? "") as NSString
        let newText = text.replacingCharacters(in: range, with: string)
        
        var validatorUserInput = false
        
        let pattern = "(?!0[0-9])\\d*(?!\\\(decimalSeparator))^[0-9]{0,\(limitBeforeSeparator)}((\\\(decimalSeparator))[0-9]{0,\(limitAfterSeparator)})?$"
        if let regex = try? NSRegularExpression(pattern: pattern,
                                                options: .caseInsensitive) {
            validatorUserInput = regex.numberOfMatches(in: newText,
                                                       options: .reportProgress,
                                                       range: NSRange(location: 0,
                                                                      length: (newText as NSString).length)) > 0
        }
        return validatorUserInput
    }
}

// MARK: Private
private extension CurrencyExchangeCollectionViewCell {
    func setupCurrencyPicker() {
        currencyPicker.overrideUserInterfaceStyle = .light
        currencyPicker.backgroundColor = .lightGray
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    func setupCurrencyExchangeTextField() {
        exchangeTextField.delegate = self
        currencyTextField.inputView = currencyPicker
    }
}
