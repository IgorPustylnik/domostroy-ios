//
//  PaginationEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct PaginationEntity {
    public let totalCount: Int
    public let totalPages: Int
    public let perPage: Int
}

extension PaginationEntity: DTOConvertible {
    public typealias DTO = PaginationEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            totalCount: model.totalCount,
            totalPages: model.totalPages,
            perPage: model.perPage
        )
    }

    public func toDTO() throws -> DTO {
        .init(
            totalCount: totalCount,
            totalPages: totalPages,
            perPage: perPage
        )
    }
}
