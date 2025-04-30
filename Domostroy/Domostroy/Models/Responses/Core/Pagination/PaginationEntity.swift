//
//  PaginationEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct PaginationEntity {
    public let totalElements: Int
    public let totalPages: Int
}

extension PaginationEntity: DTODecodable {
    public typealias DTO = PaginationEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            totalElements: model.totalElements,
            totalPages: model.totalPages
        )
    }
}
