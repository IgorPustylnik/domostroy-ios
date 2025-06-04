//
//  OffersPageEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct PageEntity<Entity: DTOEncodable> {
    public let pagination: PaginationEntity
    public let offers: [Entity]
}

// MARK: - DTOConvertible

extension PageEntity: DTODecodable {
    public typealias DTO = PageEntry

    public static func from(dto model: DTO) throws -> Self {
        return try .init(
            pagination: .from(dto: model.pagination),
            offers: model.data.map { try .from(dto: $0) }
        )
    }
}
