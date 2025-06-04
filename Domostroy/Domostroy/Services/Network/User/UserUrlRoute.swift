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
    case other(Int)
    case info
    case password
    case notificationsEnabled
}

extension UserUrlRoute: URLRouteProvider {
    func url() throws -> URL {
        guard let baseUrlString = InfoPlist.serverHost else {
            throw URLError(.badURL)
        }
        let base = URL(string: baseUrlString + "/core/user")
        switch self {
        case .my:
            guard let base else {
                throw URLError(.badURL)
            }
            return base
        case .other(let id):
            return try base + "/\(id)"
        case .info:
            return try base + "/userInfo"
        case .password:
            return try base + "/password"
        case .notificationsEnabled:
            return try base + "/notificationFlag"
        }
    }
}
