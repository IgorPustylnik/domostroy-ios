//
//  CategoriesEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

public struct CategoriesEntity {
    public let categories: [CategoryEntity]
}

extension CategoriesEntity: DTODecodable {
    public typealias DTO = CategoriesEntry

    public static func from(dto model: DTO) throws -> Self {
        var categories = model.categories
        if let first = categories.first {
            categories.removeFirst()
            categories.append(first)
        }
        return try .init(categories: categories.map { try .from(dto: $0) })
    }
}
