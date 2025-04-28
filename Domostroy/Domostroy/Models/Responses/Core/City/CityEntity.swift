//
//  CityEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct CityEntity {
    public let id: Int
    public let name: String
}

extension CityEntity: DTOConvertible {
    public typealias DTO = CityEntry

    public func toDTO() throws -> DTO {
        .init(
            id: id,
            name: name
        )
    }

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            name: model.name
        )
    }
}
