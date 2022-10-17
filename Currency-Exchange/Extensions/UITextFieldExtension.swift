//
//  UITextFieldExtension.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 14.10.2022.
//

import UIKit

extension UITextField {
    func setCursorPosition(_ location: Int) {
        guard let cursorLocation = position(from: beginningOfDocument,
                                            offset: location) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.selectedTextRange = strongSelf.textRange(from: cursorLocation,
                                                                to: cursorLocation)
        }
    }
}
