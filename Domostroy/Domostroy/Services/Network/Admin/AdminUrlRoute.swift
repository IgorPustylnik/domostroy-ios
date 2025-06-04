//
//  AdminUrlRoute.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 22.05.2025.
//

import Foundation
import NodeKit

enum AdminUrlRoute {
    case users
    case offers
    case banOffer
    case unbanOffer(Int)
    case offer(Int)
    case banUser(Int)
    case user(Int)
}

extension AdminUrlRoute: URLRouteProvider {
    func url() throws -> URL {
        guard let baseUrlString = InfoPlist.serverHost else {
            throw URLError(.badURL)
        }
        let base = URL(string: baseUrlString + "/core/admin")
        switch self {
        case .users:
            return try base + "/users/search"
        case .offers:
            return try base + "/offers/search"
        case .banOffer:
            return try base + "/offers/ban"
        case .unbanOffer(let id):
            return try base + "/offers/\(id)/unban"
        case .offer(let id):
            return try base + "/offers/\(id)"
        case .banUser(let id):
            return try base + "/users/\(id)/ban"
        case .user(let id):
            return try base + "/users/\(id)"
        }
    }
}
