//
//  Typealias.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

typealias EmptyBlock = () -> ()?
typealias BoolBlock = (Bool) -> Void
typealias ReusableCellIdentifier = String
typealias AlertButtonAction = (buttonTitle: String,
                               alertStyle: UIAlertAction.Style,
                               completion: EmptyBlock)

// MARK: - SwiftGen -
typealias Localization = L10n
typealias ImageAssets = Asset.Assets
typealias Colors = Asset.Colors

