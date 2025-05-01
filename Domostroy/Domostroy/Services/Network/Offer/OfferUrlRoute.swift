//
//  OfferUrlRoute.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import NodeKit

enum OfferUrlRoute {
    case one(Int)
    case search
    case my
    case favorite
    case base
}

extension OfferUrlRoute: URLRouteProvider {
    func url() throws -> URL {
        guard let baseUrlString = InfoPlist.serverHost else {
            throw URLError(.badURL)
        }
        let base = URL(string: baseUrlString + "/core/offer")
        switch self {
        case .one(let id):
            return try base + "/\(id)"
        case .search:
            return try base + "/search"
        case .my:
            return try base + "/myOffers"
        case .favorite:
            return try base + "/favorite"
        case .base:
            return try base + ""
        }
    }
}
