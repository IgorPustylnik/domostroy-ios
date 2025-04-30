//
//  UserUrlRoute.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import NodeKit

enum UserUrlRoute {
    case my
    case byId(Int)
}

extension UserUrlRoute: URLRouteProvider {
    func url() throws -> URL {
        guard let baseUrlString = InfoPlist.serverHost else {
            throw URLError(.badURL)
        }
        let base = URL(string: baseUrlString + "/core/user")
        switch self {
        case .my:
            return try base + "/my"
        case .byId(let id):
            return try base + "/\(id)"
        }
    }
}
