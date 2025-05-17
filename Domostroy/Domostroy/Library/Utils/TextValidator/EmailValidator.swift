//
//  EmailValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import Foundation

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
