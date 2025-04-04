//
//  TextFieldValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

import Foundation

typealias ValidationResult = (isValid: Bool, errorMessage: String?)

enum TextValidator {

    case username
    case email
    case phone
    case password

    func validate(_ text: String?) -> ValidationResult {
        guard let text else {
            return (false, "Validation failed")
        }

        switch self {
        case .username:
            return validateUsername(text)
        case .email:
            return validateEmail(text)
        case .phone:
            return validatePhone(text)
        case .password:
            return validatePassword(text)
        }
    }

    private func validateUsername(_ text: String) -> ValidationResult {
        if text.count < 2 {
            return (false, L10n.Localizable.Auth.InputField.Error.Username.short)
        }
        if text.count > 64 {
            return (false, L10n.Localizable.Auth.InputField.Error.Username.long)
        }
        return (true, nil)
    }

    private func validateEmail(_ text: String) -> ValidationResult {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if !NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text) {
            return (false, L10n.Localizable.Auth.InputField.Error.email)
        }
        return (true, nil)
    }

    private func validatePhone(_ text: String) -> ValidationResult {
        let pattern = "^(?:\\+7|8)\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)

        if !predicate.evaluate(with: text) {
            return (false, L10n.Localizable.Auth.InputField.Error.phone)
        }

        return (true, nil)
    }

    private func validatePassword(_ text: String) -> ValidationResult {
        if text.count < 8 {
            return (false, L10n.Localizable.Auth.InputField.Error.Password.short)
        }
        if text.count > 64 {
            return (false, L10n.Localizable.Auth.InputField.Error.Password.long)
        }
        return (true, nil)
    }

}
