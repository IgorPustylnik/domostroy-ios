//
//  OffersPageEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct PageEntity<Entity: DTODecodable> where Entity.DTO: Decodable & RawDecodable {
    public let pagination: PaginationEntity
    public let data: [Entity]
}

// MARK: - DTOConvertible

extension PageEntity: DTODecodable {
    public typealias DTO = PageEntry<Entity.DTO>

    public static func from(dto model: DTO) throws -> Self {
        return try .init(
            pagination: .from(dto: model.pagination),
            data: model.content.map { try .from(dto: $0) }
        )
    }
}
