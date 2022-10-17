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
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
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
        amountTextField.text = String(format: "%0.2f",
                                      arguments: [exchangeModel.amountCurrency.amount])
        currencyTextField.text = exchangeModel.amountCurrency.currency
        
        
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
        //        let moneyFormatter = SumTextInputFormatter(textPattern: "# ###.##")
        //        moneyFormatter.numberFormatter.locale = Locale(identifier: "en_US")
        //        let result = moneyFormatter.formatInput(currentText: textField.text ?? "",
        //                                                range: range,
        //                                                replacementString: string)
        //
        //        let formattedText = result.formattedText
        //
        //        guard formattedText.count <= 9 else { return false }
        //
        //        if let text = moneyFormatter.unformat(formattedText),
        //           let amount = Double(text) {
        //            didEnterAmount?(amount)
        //        }
        //
        //        textField.text = formattedText
        //        textField.setCursorPosition(result.caretBeginOffset)
        //        return false
        //
        //
        
        let decimalSeparator = string == "." ? "." : ","
        let moneyFormatter = SumTextInputFormatter(textPattern: "# ###.##")
        let result = moneyFormatter.formatInput(currentText: textField.text ?? "",
                                                        range: range,
                                                        replacementString: string)
        textField.text = textField.text?.replacingOccurrences(of: ",",
                                                              with: ".",
                                                              options: .literal,
                                                              range: nil)
        
        guard let text = textField.text else { return true }
        
        let formattedText = result.formattedText
        if let text = moneyFormatter.unformat(formattedText),
           let amount = Double(text) {
            didEnterAmount?(amount)
        }
      
        var splitText = text.components(separatedBy: decimalSeparator)
        let totalDecimalSeparators = splitText.count - 1
        let isEditingEnd = (text.count - 3) < range.lowerBound
        
        splitText.removeFirst()
        
        if splitText.last?.count ?? 0 > 1 && string.count != 0 && isEditingEnd {
            return false
        }
        
        if totalDecimalSeparators > 0 && string == decimalSeparator {
            return false
        }
        
        switch(string) {
        case "", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", decimalSeparator:
            return true
        default:
            return false
        }
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
        addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0,
                                                                  y: 0,
                                                                  width: UIScreen.main.bounds.width,
                                                                  height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: Localized.done,
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        amountTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        let moneyFormatter = SumTextInputFormatter(textPattern: "# ###.##")
        if let text = moneyFormatter.unformat(amountTextField.text),
           let amount = Double(text) {
            didEnterAmount?(amount)
        }
        self.resignFirstResponder()
    }
}

