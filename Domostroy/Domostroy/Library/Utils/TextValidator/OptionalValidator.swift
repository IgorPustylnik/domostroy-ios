//
//  OptionalValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import Foundation

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
