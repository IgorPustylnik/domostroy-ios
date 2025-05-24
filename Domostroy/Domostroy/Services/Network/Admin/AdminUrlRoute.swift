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
    case banOffer
    case offer(Int)
    case banUser
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
            return try base + "/users"
        case .banOffer:
            return try base + "/offers/ban"
        case .offer(let id):
            return try base + "/offers/\(id)"
        case .banUser:
            return try base + "/users/ban"
        case .user(let id):
            return try base + "/users/\(id)"
        }
    }
}
