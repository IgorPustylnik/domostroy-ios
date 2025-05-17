//
//  PriceValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import Foundation

struct PriceValidator: TextValidator {
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text?.trimmingCharacters(in: .whitespaces) else {
            return (false, L10n.Localizable.ValidationError.failed)
        }
        let formatter = NumberFormatter()
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
