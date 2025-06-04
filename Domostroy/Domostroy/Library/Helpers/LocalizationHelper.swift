//
//  LocalizedPluralsHelper.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 26.04.2025.
//

import Foundation

enum LocalizationHelper {
    static func pricePerDay(for price: PriceEntity) -> String {
        if price.value == -1 {
            return L10n.Localizable.Common.negotiablePrice
        }
        let priceWithCurrency = "\(price.value.stringDroppingTrailingZero)\(price.currency.description)"
        return "\(priceWithCurrency)/\(L10n.Plurals.day(1))"
    }
}
