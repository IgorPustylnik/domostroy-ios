//
//  LocalizedPluralsHelper.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 26.04.2025.
//

import Foundation

enum LocalizationHelper {

    // MARK: - Plural

    enum Plural {
        static func offer(amount: Int) -> String {
            let remainder10 = amount % 10
            let remainder100 = amount % 100

            if remainder10 == 1 && remainder100 != 11 {
                return L10n.Localizable.Plural.Offer.one
            } else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
                return L10n.Localizable.Plural.Offer.few
            } else {
                return L10n.Localizable.Plural.Offer.many
            }
        }

        static func day(amount: Int) -> String {
            let remainder10 = amount % 10
            let remainder100 = amount % 100

            if remainder10 == 1 && remainder100 != 11 {
                return L10n.Localizable.Plural.Day.one
            } else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
                return L10n.Localizable.Plural.Day.few
            } else {
                return L10n.Localizable.Plural.Day.many
            }
        }
    }

    // MARK: - Other

    static func pricePerDay(for price: Price) -> String {
        let priceWithCurrency = "\(price.value.stringDroppingTrailingZero)\(price.currency.description)"
        return "\(priceWithCurrency)/\(LocalizationHelper.Plural.day(amount: 1))"
    }
}
