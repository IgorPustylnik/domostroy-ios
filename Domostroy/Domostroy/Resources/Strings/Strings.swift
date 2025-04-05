// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum InfoPlist {
    /// Domostroy
    internal static let cfBundleDisplayName = L10n.tr("InfoPlist", "CFBundleDisplayName", fallback: "Domostroy")
    /// Domostroy
    internal static let cfBundleName = L10n.tr("InfoPlist", "CFBundleName", fallback: "Domostroy")
  }
  internal enum Localizable {
    internal enum Auth {
      internal enum InputField {
        internal enum Error {
          /// Invalid email address
          internal static let email = L10n.tr("Localizable", "Auth.InputField.Error.Email", fallback: "Invalid email address")
          /// Field cannot be empty
          internal static let empty = L10n.tr("Localizable", "Auth.InputField.Error.empty", fallback: "Field cannot be empty")
          /// Incorrect format
          internal static let invalid = L10n.tr("Localizable", "Auth.InputField.Error.invalid", fallback: "Incorrect format")
          /// Invalid phone number
          internal static let phone = L10n.tr("Localizable", "Auth.InputField.Error.Phone", fallback: "Invalid phone number")
          internal enum Password {
            /// Password must contain at least one capital letter
            internal static let capitalletter = L10n.tr("Localizable", "Auth.InputField.Error.Password.capitalletter", fallback: "Password must contain at least one capital letter")
            /// Password contains invalid characters
            internal static let invalidSymbols = L10n.tr("Localizable", "Auth.InputField.Error.Password.invalidSymbols", fallback: "Password contains invalid characters")
            /// Password mustn't be longer than 69 characters
            internal static let long = L10n.tr("Localizable", "Auth.InputField.Error.Password.long", fallback: "Password mustn't be longer than 69 characters")
            /// Passwords must match
            internal static let mismatch = L10n.tr("Localizable", "Auth.InputField.Error.Password.mismatch", fallback: "Passwords must match")
            /// Password must contain at least one digit
            internal static let noDigit = L10n.tr("Localizable", "Auth.InputField.Error.Password.noDigit", fallback: "Password must contain at least one digit")
            /// Password must contain at least one Latin letter
            internal static let noLetter = L10n.tr("Localizable", "Auth.InputField.Error.Password.noLetter", fallback: "Password must contain at least one Latin letter")
            /// Password must contain at least one number
            internal static let nonumbers = L10n.tr("Localizable", "Auth.InputField.Error.Password.nonumbers", fallback: "Password must contain at least one number")
            /// Password must contain at least one special character
            internal static let noSpecialChar = L10n.tr("Localizable", "Auth.InputField.Error.Password.noSpecialChar", fallback: "Password must contain at least one special character")
            /// Password must be at least 8 characters long
            internal static let short = L10n.tr("Localizable", "Auth.InputField.Error.Password.short", fallback: "Password must be at least 8 characters long")
          }
          internal enum Username {
            /// Mustn't be longer than 64 characters
            internal static let long = L10n.tr("Localizable", "Auth.InputField.Error.Username.long", fallback: "Mustn't be longer than 64 characters")
            /// Must be at least 2 characters long
            internal static let short = L10n.tr("Localizable", "Auth.InputField.Error.Username.short", fallback: "Must be at least 2 characters long")
          }
        }
      }
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
