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
    ///   Created by Danylo Klymov on 11.10.2022.
    internal static let headerTitle = L10n.tr("Localization", "exchangeScreen.headerTitle", fallback: "Currency Converter")
    internal enum Currency {
      /// EUR
      internal static let eur = L10n.tr("Localization", "exchangeScreen.currency.eur", fallback: "EUR")
      /// JPY
      internal static let jpy = L10n.tr("Localization", "exchangeScreen.currency.jpy", fallback: "JPY")
      /// USD
      internal static let usd = L10n.tr("Localization", "exchangeScreen.currency.usd", fallback: "USD")
    }
    internal enum CurrencyExchange {
      /// Receive
      internal static let receive = L10n.tr("Localization", "exchangeScreen.currencyExchange.receive", fallback: "Receive")
      /// Sell
      internal static let sell = L10n.tr("Localization", "exchangeScreen.currencyExchange.sell", fallback: "Sell")
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
