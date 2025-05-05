//
//  TextValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

import Foundation

typealias ValidationResult = (isValid: Bool, errorMessage: String?)

protocol TextValidator {
    func validate(_ text: String?) -> ValidationResult
}

struct UsernameValidator: TextValidator {
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            return (false, L10n.Localizable.ValidationError.failed)
        }
        if text.contains(" ") {
            return (false, L10n.Localizable.ValidationError.Username.containsSpaces)
        }
        if text.count < 2 {
            return (false, L10n.Localizable.ValidationError.Username.short)
        }
        if text.count > 64 {
            return (false, L10n.Localizable.ValidationError.Username.long)
        }
        return (true, nil)
    }
}

struct EmailValidator: TextValidator {
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            return (false, "Validation failed")
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if !NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text) {
            return (false, L10n.Localizable.ValidationError.email)
        }
        return (true, nil)
    }
}

struct PhoneValidator: TextValidator {
    let normalizer: PhoneNumberNormalizer

    func validate(_ text: String?) -> ValidationResult {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            return (false, L10n.Localizable.ValidationError.failed)
        }
        let cleaned = normalizer.normalizePhone(text)
        let pattern = "^7\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)

        if !predicate.evaluate(with: cleaned) {
            return (false, L10n.Localizable.ValidationError.phone)
        }
        return (true, nil)
    }
}

struct PasswordValidator: TextValidator {
    func validate(_ text: String?) -> ValidationResult {
        guard let text else {
            return (false, L10n.Localizable.ValidationError.failed)
        }

        let allowedCharsRegex = "^[A-Za-z0-9.~!@#$%^&*()+-]+$"
        if !NSPredicate(format: "SELF MATCHES %@", allowedCharsRegex).evaluate(with: text) {
            return (false, L10n.Localizable.ValidationError.Password.invalidSymbols)
        }

        if !NSPredicate(format: "SELF MATCHES %@", ".*[A-Za-z]+.*").evaluate(with: text) {
            return (false, L10n.Localizable.ValidationError.Password.noLetter)
        }

        if !NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: text) {
            return (false, L10n.Localizable.ValidationError.Password.noDigit)
        }

        if !NSPredicate(format: "SELF MATCHES %@", ".*[.~!@#$%^&*()+-]+.*").evaluate(with: text) {
            return (false, L10n.Localizable.ValidationError.Password.noSpecialChar)
        }

        if text.count < 8 {
            return (false, L10n.Localizable.ValidationError.Password.short)
        }
        if text.count > 69 {
            return (false, L10n.Localizable.ValidationError.Password.long)
        }

        return (true, nil)
    }
}

struct OfferNameValidator: TextValidator {
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            return (false, L10n.Localizable.ValidationError.failed)
        }
        guard !text.isEmpty else {
            return (false, L10n.Localizable.ValidationError.OfferName.empty)
        }
        if text.count > 100 {
            return (false, L10n.Localizable.ValidationError.OfferName.long)
        }
        return (true, nil)
    }
}

struct OfferDescriptionValidator: TextValidator {
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            return (true, nil)
        }
        if text.count > 3000 {
            return (false, L10n.Localizable.ValidationError.OfferDescription.long)
        }
        return (true, nil)
    }
}

struct PriceValidator: TextValidator {
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            return (false, L10n.Localizable.ValidationError.failed)
        }
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal

        guard let number = formatter.number(from: text) else {
            return (false, L10n.Localizable.ValidationError.Price.invalidFormat)
        }

        if number.doubleValue < 0 {
            return (false, L10n.Localizable.ValidationError.Price.negative)
        }
        let maxValue: Double = 1000000
        if number.doubleValue > maxValue {
            return (false, L10n.Localizable.ValidationError.Price.tooHigh(maxValue))
        }

        return (true, nil)
    }
}

struct MatchPasswordValidator: TextValidator {
    let password: String

    func validate(_ text: String?) -> ValidationResult {
        guard let text = text else {
            return (false, L10n.Localizable.ValidationError.failed)
        }
        if text != password {
            return (false, L10n.Localizable.ValidationError.Password.mismatch)
        }
        return (true, nil)
    }
}

struct RequiredValidator: TextValidator {
    let wrapped: TextValidator?

    init(_ wrapped: TextValidator? = nil) {
        self.wrapped = wrapped
    }

    func validate(_ text: String?) -> ValidationResult {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            return (false, L10n.Localizable.ValidationError.failed)
        }
        guard !text.isEmpty else {
            return (false, L10n.Localizable.ValidationError.required)
        }
        guard let wrapped else {
            return (true, nil)
        }
        return wrapped.validate(text)
    }
}

struct OptionalValidator: TextValidator {
    let wrapped: TextValidator?

    init(_ wrapped: TextValidator? = nil) {
        self.wrapped = wrapped
    }

    func validate(_ text: String?) -> ValidationResult {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            return (false, L10n.Localizable.ValidationError.failed)
        }
        guard !text.isEmpty, let wrapped else {
            return (true, nil)
        }
        return wrapped.validate(text)
    }
}
