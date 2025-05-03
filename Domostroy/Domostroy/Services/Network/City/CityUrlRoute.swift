//
//  CityUrlRoute.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

enum CityUrlRoute {
    case base
    case popular
}

extension CityUrlRoute: URLRouteProvider {
    func url() throws -> URL {
        guard let baseUrlString = InfoPlist.serverHost else {
            throw URLError(.badURL)
        }
        let base = URL(string: baseUrlString + "/core/city")
        switch self {
        case .base:
            guard let base else {
                throw URLError(.badURL)
            }
            return base
        case .popular:
            return try base + "/popular"
        }
    }
}
