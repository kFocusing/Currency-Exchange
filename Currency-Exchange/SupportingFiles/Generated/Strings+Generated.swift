// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum ExchangeScreen {
    /// MY BALANCES
    internal static let balanceSectionTitle = L10n.tr("Localization", "exchangeScreen.balanceSectionTitle", fallback: "MY BALANCES")
    /// SUBMIT
    internal static let buttonTitle = L10n.tr("Localization", "exchangeScreen.buttonTitle", fallback: "SUBMIT")
    /// CURRENCY EXCHANGE
    internal static let currencyExchangeSectionTitle = L10n.tr("Localization", "exchangeScreen.currencyExchangeSectionTitle", fallback: "CURRENCY EXCHANGE")
    /// Localization.strings
    ///   Currency-Exchange
    /// 
    ///   Created on 11.10.2022.
    internal static let headerTitle = L10n.tr("Localization", "exchangeScreen.headerTitle", fallback: "Currency converter")
    internal enum AlertActions {
      /// Cancel
      internal static let cancel = L10n.tr("Localization", "exchangeScreen.alertActions.cancel", fallback: "Cancel")
      /// Done
      internal static let done = L10n.tr("Localization", "exchangeScreen.alertActions.done", fallback: "Done")
    }
    internal enum Currency {
      /// EUR
      internal static let eur = L10n.tr("Localization", "exchangeScreen.currency.eur", fallback: "EUR")
      /// JPY
      internal static let jpy = L10n.tr("Localization", "exchangeScreen.currency.jpy", fallback: "JPY")
      /// USD
      internal static let usd = L10n.tr("Localization", "exchangeScreen.currency.usd", fallback: "USD")
    }
    internal enum CurrencyConvertedAlert {
      /// Are you sure you want to convert %@ to %@? Commission Fee %@ %@
      internal static func messageWithFee(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any) -> String {
        return L10n.tr("Localization", "exchangeScreen.currencyConvertedAlert.messageWithFee", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4), fallback: "Are you sure you want to convert %@ to %@? Commission Fee %@ %@")
      }
      /// Are you sure you want to convert %@ to %@? You will spend 1 fee exemption.
      ///  You have %@ exemptions left commissions.
      internal static func messageWithOutFee(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
        return L10n.tr("Localization", "exchangeScreen.currencyConvertedAlert.messageWithOutFee", String(describing: p1), String(describing: p2), String(describing: p3), fallback: "Are you sure you want to convert %@ to %@? You will spend 1 fee exemption.\n You have %@ exemptions left commissions.")
      }
      /// Exchange Confirmation
      internal static let title = L10n.tr("Localization", "exchangeScreen.currencyConvertedAlert.title", fallback: "Exchange Confirmation")
    }
    internal enum CurrencyExchange {
      /// Receive
      internal static let receive = L10n.tr("Localization", "exchangeScreen.currencyExchange.receive", fallback: "Receive")
      /// Sell
      internal static let sell = L10n.tr("Localization", "exchangeScreen.currencyExchange.sell", fallback: "Sell")
    }
    internal enum ErrorAlert {
      /// Failed to exchange currancy: %@
      internal static func message(_ p1: Any) -> String {
        return L10n.tr("Localization", "exchangeScreen.errorAlert.message", String(describing: p1), fallback: "Failed to exchange currancy: %@")
      }
      /// Failed
      internal static let title = L10n.tr("Localization", "exchangeScreen.errorAlert.title", fallback: "Failed")
    }
    internal enum InternetError {
      /// Please, enable your Wi-Fi or connect using cellular data.
      internal static let message = L10n.tr("Localization", "exchangeScreen.internetError.message", fallback: "Please, enable your Wi-Fi or connect using cellular data.")
      /// You are offline
      internal static let title = L10n.tr("Localization", "exchangeScreen.internetError.title", fallback: "You are offline")
    }
    internal enum NotEnoughMoneyAlert {
      ///  There is not enough money on the balance sheet.
      ///  Top up your account or change the convertible currency.
      internal static let message = L10n.tr("Localization", "exchangeScreen.notEnoughMoneyAlert.message", fallback: " There is not enough money on the balance sheet.\n Top up your account or change the convertible currency.")
      /// There is not enough money
      internal static let title = L10n.tr("Localization", "exchangeScreen.notEnoughMoneyAlert.title", fallback: "There is not enough money")
    }
    internal enum SameСurrencies {
      /// Please make sure you have selected the correct currency.
      internal static let message = L10n.tr("Localization", "exchangeScreen.sameСurrencies.message", fallback: "Please make sure you have selected the correct currency.")
      /// You have chosen the same currencies
      internal static let title = L10n.tr("Localization", "exchangeScreen.sameСurrencies.title", fallback: "You have chosen the same currencies")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
