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
        try .init(categories: model.categories.map { try .from(dto: $0) })
    }
}
