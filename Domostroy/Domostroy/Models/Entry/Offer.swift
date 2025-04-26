//
//  Offer.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 07.04.2025.
//

import Foundation

struct OffersPage: Codable {
    let pagination: Pagination
    let offers: [Offer]
}

struct Pagination: Codable {
    let currentPage: Int
    let perPage: Int
    let totalItems: Int
    let totalPages: Int
}

struct Offer: Codable {
    let id: Int
    let name: String
    let description: String
    let category: Category
    let price: Price
    let isFavorite: Bool
    let images: [URL]
    let city: City
    let userId: Int
    let calendarId: Int
    let createdAt: Date
}

struct Category: Codable, Equatable {
    let id: Int
    let name: String
}

struct Price: Codable {
    let value: Double
    let currency: Currency
}

enum Currency: Codable {
    case rub
    case unknown

    init(rawValue: String) {
        switch rawValue {
        case Currency.rub.description:
            self = .rub
        default:
            self = .unknown
        }
    }

    var description: String {
        switch self {
        case .rub:
            return "₽"
        case .unknown:
            return "?"
        }
    }
}

struct City: Codable {
    let id: Int
    let name: String
}

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String?
    let avatar: URL?
    let offersAmount: Int
    let registerDate: Date
}

struct MyProfile: Codable {
    let id: Int
    let firstName: String
    let lastName: String?
    let email: String
    let phoneNumber: String
    let isAdmin: Bool
}

struct OfferCalendar: Codable {
    let startDate: Date
    let endDate: Date
    let forbiddenDates: [Date]
}

enum Condition: CaseIterable {
    case used
    case new

    var description: String {
        switch self {
        case .used:
            return L10n.Localizable.Offers.Condition.used
        case .new:
            return L10n.Localizable.Offers.Condition.new
        }
    }
}
