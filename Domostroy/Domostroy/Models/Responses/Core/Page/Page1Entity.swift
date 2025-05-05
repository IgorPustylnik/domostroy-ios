//
//  Page1Entity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 05.05.2025.
//

import Foundation
import NodeKit

public struct Page1Entity<Entity: DTODecodable> where Entity.DTO: Decodable & RawDecodable {
    public let totalElements: Int
    public let totalPages: Int
    public let content: [Entity]
}

// MARK: - DTOConvertible

extension Page1Entity: DTODecodable {
    public typealias DTO = Page1Entry<Entity.DTO>

    public static func from(dto model: DTO) throws -> Self {
        try .init(totalElements: model.totalElements,
                  totalPages: model.totalPages,
                  content: model.content.map { try .from(dto: $0) }
        )
    }
}
