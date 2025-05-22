//
//  SearchRequestEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import NodeKit

public struct SearchRequestEntity {
    public let pagination: PaginationRequestEntity
    public let sorting: [SortEntity]
    public let searchCriteriaList: [FilterEntity]
    public let snapshot: Date
    public let seed: String?
}

extension SearchRequestEntity: DTOEncodable {
    public typealias DTO = SearchRequestEntry

    public func toDTO() throws -> SearchRequestEntry {
        try .init(
            pagination: pagination.toDTO(),
            sorting: sorting.toDTO(),
            searchCriteriaList: searchCriteriaList.toDTO(),
            snapshot: snapshot,
            seed: seed
        )
    }
}
