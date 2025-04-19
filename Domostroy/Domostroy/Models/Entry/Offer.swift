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
    let currency: Currency
    let price: Double
    let isFavorite: Bool
    let images: [URL]
    let city: City
    let userId: Int
    let calendarId: Int
}

struct Category: Codable {
    let id: Int
    let name: String
}

enum Currency: Codable {
    case rub
}

struct City: Codable {
    let id: Int
    let name: String
}

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
}

struct OfferCalendar: Codable {
    let startDate: Date
    let endDate: Date
    let forbiddenDates: [Date]
}

struct Filter {

}

enum Condition: CaseIterable {
    case used
    case new

    // TODO: Localize
    var description: String {
        switch self {
        case .used:
            return "Used"
        case .new:
            return "Brand new"
        }
    }
}
