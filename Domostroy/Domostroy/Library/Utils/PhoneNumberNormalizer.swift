//
//  PhoneNumberNormalizer.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 05.04.2025.
//

protocol PhoneNumberNormalizer {
    func normalizePhone(_ text: String) -> String
}

struct RussianPhoneNumberNormalizer: PhoneNumberNormalizer {
    func normalizePhone(_ text: String) -> String {
        let digits = text.filter { $0.isNumber }
        if digits.hasPrefix("8") && digits.count == 11 {
            return "7" + digits.dropFirst()
        }
        if digits.hasPrefix("7") && digits.count == 11 {
            return digits
        }
        if text.hasPrefix("+7") && digits.count == 11 {
            return digits
        }
        return digits
    }
}
