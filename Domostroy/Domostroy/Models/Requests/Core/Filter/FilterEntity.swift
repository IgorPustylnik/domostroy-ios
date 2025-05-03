//
//  FilterEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct FilterEntity {
    public let filterKey: FilterKey
    public let operation: FilterOperation
    public let value: AnyEncodable

    public enum FilterKey: String {
        case title = "title"
        case description = "description"
        case cityId = "cityId"
        case categoryId = "categoryId"
        case userId = "userId"
    }

    public enum FilterOperation: String {
        case equals = "eq"
        case contains = "cn"
        case greaterThan = "gt"
        case greaterThanEqual = "ge"
        case lessThan = "lt"
        case lessThanEqual = "le"
    }
}

extension FilterEntity: DTOEncodable {
    public typealias DTO = FilterEntry

    public func toDTO() throws -> FilterEntry {
        .init(filterKey: filterKey.rawValue, operation: operation.rawValue, value: value)
    }
}
