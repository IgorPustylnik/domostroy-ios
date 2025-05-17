//
//  OfferNameValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import Foundation

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
