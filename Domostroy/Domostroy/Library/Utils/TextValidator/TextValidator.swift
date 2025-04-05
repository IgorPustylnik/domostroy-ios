//
//  TextValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

import Foundation

typealias ValidationResult = (isValid: Bool, errorMessage: String?)

enum TextValidator {

    case username
    case email
    case phone(PhoneNumberNormalizer)
    case password
    case match(password: String)

    indirect case required(TextValidator?)
    indirect case optional(TextValidator?)

    func validate(_ text: String?) -> ValidationResult {
        guard var text else {
            return (false, "Validation failed")
        }
        text = text.trimmingCharacters(in: .whitespaces)

        switch self {
        case .username:
            return validateUsername(text)
        case .email:
            return validateEmail(text)
        case .phone(let normalizer):
            return validatePhone(text, normalizer: normalizer)
        case .password:
            return validatePassword(text)
        case .match(let password):
            return validateMatchPassword(text, password: password)
        case .required(let validator):
            return validateRequired(text, validator: validator)
        case .optional(let validator):
            return validateOptional(text, validator: validator)
        }
    }
}

// MARK: - Validation

private extension TextValidator {

    func validateUsername(_ text: String) -> ValidationResult {
        if text.count < 2 {
            return (false, L10n.Localizable.Auth.InputField.Error.Username.short)
        }
        if text.count > 64 {
            return (false, L10n.Localizable.Auth.InputField.Error.Username.long)
        }
        return (true, nil)
    }

    func validateEmail(_ text: String) -> ValidationResult {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if !NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text) {
            return (false, L10n.Localizable.Auth.InputField.Error.email)
        }
        return (true, nil)
    }

    private func validatePhone(_ text: String, normalizer: PhoneNumberNormalizer) -> ValidationResult {
        let cleaned = normalizer.normalizePhone(text)
        let pattern = "^7\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)

        if !predicate.evaluate(with: cleaned) {
            return (false, L10n.Localizable.Auth.InputField.Error.phone)
        }

        return (true, nil)
    }

    func validatePassword(_ text: String) -> ValidationResult {
        // допустимые символы
        let allowedCharsRegex = "^[A-Za-z0-9.~!@#$%^&*()+-]+$"
        let allowedPredicate = NSPredicate(format: "SELF MATCHES %@", allowedCharsRegex)
        if !allowedPredicate.evaluate(with: text) {
            return (false, L10n.Localizable.Auth.InputField.Error.Password.invalidSymbols)
        }

        // хотя бы одна латинская буква
        let letterPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Za-z]+.*")
        if !letterPredicate.evaluate(with: text) {
            return (false, L10n.Localizable.Auth.InputField.Error.Password.noLetter)
        }

        // хотя бы одна цифра
        let digitPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        if !digitPredicate.evaluate(with: text) {
            return (false, L10n.Localizable.Auth.InputField.Error.Password.noDigit)
        }

        // хотя бы один спецсимвол из набора
        let specialPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[.~!@#$%^&*()+-]+.*")
        if !specialPredicate.evaluate(with: text) {
            return (false, L10n.Localizable.Auth.InputField.Error.Password.noSpecialChar)
        }

        // длина
        if text.count < 8 {
            return (false, L10n.Localizable.Auth.InputField.Error.Password.short)
        }
        if text.count > 69 {
            return (false, L10n.Localizable.Auth.InputField.Error.Password.long)
        }

        return (true, nil)
    }

    func validateMatchPassword(_ text: String, password: String) -> ValidationResult {
        if text != password {
            return (false, L10n.Localizable.Auth.InputField.Error.Password.mismatch)
        }
        return (true, nil)
    }

    func validateRequired(_ text: String, validator: TextValidator?) -> ValidationResult {
        if text.count < 1 {
            return (false, L10n.Localizable.Auth.InputField.Error.empty)
        }
        guard let validator else {
            return (true, nil)
        }
        return validator.validate(text)
    }

    func validateOptional(_ text: String, validator: TextValidator?) -> ValidationResult {
        guard !text.isEmpty, let validator else {
            return (true, nil)
        }
        return validator.validate(text)
    }

}
