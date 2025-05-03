//
//  CategoryUrlRoute.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

enum CategoryUrlRoute {
    case base
}

extension CategoryUrlRoute: URLRouteProvider {
    func url() throws -> URL {
        guard let baseUrlString = InfoPlist.serverHost else {
            throw URLError(.badURL)
        }
        let base = URL(string: baseUrlString + "/core/category")
        switch self {
        case .base:
            guard let base else {
                throw URLError(.badURL)
            }
            return base
        }
    }
}
