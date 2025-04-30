//
//  AuthUrlRoute.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import NodeKit

enum AuthUrlRoute {
    case login
    case register
    case confirmRegister
}

extension AuthUrlRoute: URLRouteProvider {
    func url() throws -> URL {
        guard let baseUrlString = InfoPlist.serverHost else {
            throw URLError(.badURL)
        }
        let base = URL(string: baseUrlString + "/auth")
        switch self {
        case .login:
            return try base + "/sign-in"
        case .register:
            return try base + "/sign-up"
        case .confirmRegister:
            return try base + "/confirmRegistration"
        }
    }
}
