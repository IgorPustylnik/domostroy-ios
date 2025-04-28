//
//  OffersPageEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct OffersPageEntity {
    public let pagination: PaginationEntity
    public let data: [OfferEntity]
}

// MARK: - DTOConvertible

extension OffersPageEntity: DTOConvertible {
    public typealias DTO = OffersPageEntry

    public func toDTO() throws -> DTO {
        return try .init(
            pagination: pagination.toDTO(),
            data: data.map { try $0.toDTO() }
        )
    }
    public static func from(dto model: DTO) throws -> Self {
        return try .init(
            pagination: .from(dto: model.pagination),
            data: model.data.map { try .from(dto: $0) }
        )
    }
}
