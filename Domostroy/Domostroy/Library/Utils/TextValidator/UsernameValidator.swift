//
//  UsernameValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

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
