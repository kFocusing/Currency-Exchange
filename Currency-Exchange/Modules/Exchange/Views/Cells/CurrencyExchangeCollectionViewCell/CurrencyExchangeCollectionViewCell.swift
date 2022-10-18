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
        currencyPicker.backgroundColor = .white
        addDoneButtonOnCurrencyPicker()
        currencyDealTypeImageView.makeCornersRounded()
        setupCurrencyPicker()
        setupAmountTextField()
        
        currencyTextField.delegate = self
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
        currentCurrency = Currency.allCases.first(where: { $0.title == exchangeModel.amountCurrency.currency }) ?? .euro
        currencyPicker.selectRow(currentCurrency.rawValue,
                                 inComponent: 0,
                                 animated: true)
        
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
                                 inComponent: component,
                                 animated: true)
        currentCurrency = pickerViewDataSource[row]
        currencyTextField.text = currentCurrency.title
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
        
        if formattedText == "" {
            textField.text = "0"
            didEnterAmount?(0)
            return false
        }
        
        if let text = moneyFormatter.unformat(formattedText),
           let amount = Double(text) {
            didEnterAmount?(amount)
        }
        
        textField.text = formattedText
        textField.setCursorPosition(result.caretBeginOffset)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == currencyTextField else { return }
        pickCurrencyChevron.image = UIImage(systemName: "chevron.up")
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
    
    func addDoneButtonOnCurrencyPicker() {
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
        
        currencyTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        didSelectCurrency?(currentCurrency, cellDealType)
        pickCurrencyChevron.image = UIImage(systemName: "chevron.down")
        self.endEditing(true)
        self.resignFirstResponder()
    }
}

