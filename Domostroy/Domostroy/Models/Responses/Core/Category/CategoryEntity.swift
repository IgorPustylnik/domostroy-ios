//
//  CategoryEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct CategoryEntity: Equatable {
    public let id: Int
    public let name: String
}

extension CategoryEntity: DTODecodable {
    public typealias DTO = CategoryEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            name: model.name
        )
    }
}
