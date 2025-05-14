//
//  SortEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct SortEntity {
    public let property: SortProperty
    public let direction: SortDirection

    public enum SortType {
        case priceAscending
    }

    public enum SortProperty: String {
        case date = "createdAt"
        case price = "price"
        case resolutionDate = "resolvedAt"
    }

    public enum SortDirection: String {
        case ascending = "ASC"
        case descending = "DESC"
    }
}

extension SortEntity: DTOEncodable {
    public typealias DTO = SortEntry

    public func toDTO() throws -> DTO {
        .init(property: property.rawValue, direction: direction.rawValue)
    }
}
