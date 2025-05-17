//
//  MatchPasswordValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import Foundation

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
