//
//  OfferUrlRoute.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import NodeKit

enum OfferUrlRoute {
    case base
    case one(Int)
    case search
    case my
    case favorites
    case favorite(Int)
    case calendar
    case calendarById(Int)
}

extension OfferUrlRoute: URLRouteProvider {
    func url() throws -> URL {
        guard let baseUrlString = InfoPlist.serverHost else {
            throw URLError(.badURL)
        }
        let base = URL(string: baseUrlString + "/core/offers")
        switch self {
        case .base:
            guard let base else {
                throw URLError(.badURL)
            }
            return base
        case .one(let id):
            return try base + "/\(id)"
        case .search:
            return try base + "/search"
        case .my:
            return try base + "/myOffers"
        case .favorites:
            return try base + "/favourite"
        case .favorite(let id):
            return try base + "/favourite/\(id)"
        case .calendar:
            return try base + "/calendar"
        case .calendarById(let id):
            return try base + "/calendar/\(id)"
        }
    }
}
