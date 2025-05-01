//
//  CityEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct CityEntity: Equatable {
    public let id: Int
    public let name: String
}

extension CityEntity: DTODecodable {
    public typealias DTO = CityEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            name: model.name
        )
    }
}
