//
//  RentUrlRoute.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.05.2025.
//

import Foundation
import NodeKit

enum RentUrlRoute {
    case base
    case one(Int)
    case outgoingRequests(page: Int, size: Int)
    case incomingRequests(page: Int, size: Int)
    case outgoingRequest(Int)
    case incomingRequest(Int)
}

extension RentUrlRoute: URLRouteProvider {
    func url() throws -> URL {
        guard let baseUrlString = InfoPlist.serverHost else {
            throw URLError(.badURL)
        }
        let base = URL(string: baseUrlString + "/core/rent")
        switch self {
        case .base:
            guard let base else {
                throw URLError(.badURL)
            }
            return base
        case .one(let id):
            return try base + "/\(id)"
        case .outgoingRequests(let page, let size):
            return try base + "/outgoingRequests?page=\(page)&size=\(size)&sort=createdAt,desc&sort=resolvedAt,desc"
        case .incomingRequests(let page, let size):
            return try base + "/incomingRequests?page=\(page)&size=\(size)&sort=createdAt,desc&sort=resolvedAt,desc"
        case .outgoingRequest(let id):
            return try base + "/outgoingRequest/\(id)"
        case .incomingRequest(let id):
            return try base + "/incomingRequest/\(id)"
        }
    }
}
