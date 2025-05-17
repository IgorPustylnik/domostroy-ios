//
//  OfferDescriptionValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import Foundation

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
