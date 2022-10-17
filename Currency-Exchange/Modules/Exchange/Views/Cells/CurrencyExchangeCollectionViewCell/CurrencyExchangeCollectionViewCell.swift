//
//  CurrencyExchangeCollectionViewCell.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit
import AnyFormatKit

private typealias Localized = Localization.ExchangeScreen.AlertActions

final class CurrencyExchangeCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet private weak var currencyDealTypeImageView: UIImageView!
    @IBOutlet private weak var dealTypeLabel: UILabel!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var currencyTextField: UITextField!
    @IBOutlet private weak var exchangeStatus: UILabel!
    @IBOutlet private weak var pickCurrencyChevron: UIImageView!
    
    // MARK: UIElements
    private let currencyPicker = UIPickerView()
    
    // MARK: Properties
    var didSelectCurrency: ((Currency, DealType) -> Void)?
    var didEnterAmount: ((Double) -> Void)?
    
    private var cellDealType: DealType = .sell
    private var currentCurrency: Currency = .euro
    private let pickerViewDataSource: [Currency] = [.euro,
                                                    .americanDollar,
                                                    .japaneseYen]
    private let moneyFormatter = SumTextInputFormatter(textPattern: "# ###.##")
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        currencyDealTypeImageView.makeCornersRounded()
        setupCurrencyPicker()
        setupAmountTextField()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        amountTextField.textColor = .black
        exchangeStatus.isHidden = true
        amountTextField.isUserInteractionEnabled = true
    }
    
    // MARK: Internal
    func configure(with exchangeModel: ExchangeModel) {
        cellDealType = exchangeModel.dealType
        dealTypeLabel.text = exchangeModel.dealType.title
        currencyDealTypeImageView.image = exchangeModel.dealType.icon
        currencyDealTypeImageView.backgroundColor = exchangeModel.dealType.color
        currencyTextField.text = exchangeModel.amountCurrency.currency
        
        let decimalAmount = String(format: "%0.2f",
                                   arguments: [exchangeModel.amountCurrency.amount])
        amountTextField.text = moneyFormatter.format(decimalAmount)
        if exchangeModel.dealType == .receive {
            amountTextField.textColor = Colors.exchangeGreen.color
            exchangeStatus.isHidden = false
            amountTextField.isUserInteractionEnabled = false
        }
    }
}

// MARK: - Extensions -
// MARK: UIPickerViewDelegate
extension CurrencyExchangeCollectionViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        currencyPicker.selectRow(row,
                                 inComponent: 0,
                                 animated: true)
        currentCurrency = pickerViewDataSource[row]
        currencyTextField.text = currentCurrency.title
        didSelectCurrency?(currentCurrency, cellDealType)
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
        textField.text = textField.text?.replacingOccurrences(of: ",",
                                                              with: ".",
                                                              options: .literal,
                                                              range: nil)
        let result = moneyFormatter.formatInput(currentText: textField.text ?? "",
                                                range: range,
                                                replacementString: string == "," ? "." : string )
        
        let formattedText = result.formattedText
    
        
        if let text = moneyFormatter.unformat(formattedText),
           let amount = Double(text) {
            didEnterAmount?(amount)
        }
         
        textField.text = formattedText
        textField.setCursorPosition(result.caretBeginOffset)
        return false
    }
}

// MARK: Private
private extension CurrencyExchangeCollectionViewCell {
    func setupCurrencyPicker() {
        currencyPicker.overrideUserInterfaceStyle = .light
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyTextField.inputView = currencyPicker
    }
    
    func setupAmountTextField() {
        amountTextField.keyboardType = .decimalPad
        amountTextField.delegate = self
    }
    
    @objc func keyboardWillHide(notification: Notification) {
//        guard let text = amountTextField.text else { return }
//        let decimalAmount = String(format: "%0.2f",
//                                   arguments: [text])
//        amountTextField.text = moneyFormatter.format(decimalAmount)
    }
}

