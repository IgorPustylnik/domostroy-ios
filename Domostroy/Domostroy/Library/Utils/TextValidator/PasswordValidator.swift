//
//  PasswordValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import Foundation

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
