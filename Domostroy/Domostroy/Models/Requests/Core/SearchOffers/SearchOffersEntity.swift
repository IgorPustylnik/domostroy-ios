//
//  SearchOffersEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import NodeKit

public struct SearchOffersEntity {
    public let pagination: PaginationRequestEntity
    public let sorting: [SortItemRequestEntity]
    public let searchCriteriaList: SearchCriteriaListRequestEntity
}

extension SearchOffersEntity: DTOEncodable {
    public typealias DTO = SearchOffersEntry

    public func toDTO() throws -> SearchOffersEntry {
        .init(
            pas: .init(
                pagination: .init(page: pagination.page, size: pagination.size),
                sorting: sorting.map { .init(property: $0.property, direction: $0.direction) }
            ),
            searchCriteriaList: .init(
                filterKey: searchCriteriaList.filterKey,
                operation: searchCriteriaList.operation,
                value: searchCriteriaList.value
            )
        )
    }

}

public struct SearchCriteriaListRequestEntity: Encodable {
    public let filterKey: String
    public let operation: String
    public let value: String
}

public struct PaginationRequestEntity: Encodable {
    public let page: Int
    public let size: Int
}

public struct SortItemRequestEntity: Encodable {
    public let property: String
    public let direction: String
}
