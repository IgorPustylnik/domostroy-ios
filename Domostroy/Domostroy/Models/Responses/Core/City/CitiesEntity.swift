//
//  CitiesEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

public struct CitiesEntity: Equatable {
    public let cities: [CityEntity]
}

extension CitiesEntity: DTODecodable {
    public typealias DTO = CitiesEntry

    public static func from(dto model: DTO) throws -> Self {
        try .init(cities: model.cities.map { try .from(dto: $0) })
    }
}
