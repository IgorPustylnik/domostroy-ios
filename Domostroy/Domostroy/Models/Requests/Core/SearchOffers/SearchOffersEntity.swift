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
    public let sorting: [SortEntity]
    public let searchCriteriaList: [FilterEntity]
    public let snapshot: Date
    public let seed: String?
}

extension SearchOffersEntity: DTOEncodable {
    public typealias DTO = SearchOffersEntry

    public func toDTO() throws -> SearchOffersEntry {
        try .init(
            pagination: pagination.toDTO(),
            sorting: sorting.toDTO(),
            searchCriteriaList: searchCriteriaList.toDTO(),
            snapshot: snapshot,
            seed: seed
        )
    }
}
