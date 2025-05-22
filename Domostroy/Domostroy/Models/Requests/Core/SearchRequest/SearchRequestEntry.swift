//
//  SearchOffersEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import NodeKit
import UIKit

public struct SearchRequestEntry {
    private let pas: PaginationAndSortingEntry
    public let searchCriteriaList: [FilterEntry]

    init(
        pagination: PaginationRequestEntry,
        sorting: [SortEntry],
        searchCriteriaList: [FilterEntry],
        snapshot: Date,
        seed: String?
    ) {
        self.pas = .init(pagination: pagination, sorting: sorting, snapshot: snapshot, seed: seed)
        self.searchCriteriaList = searchCriteriaList
    }
}

extension SearchRequestEntry: Encodable, RawEncodable {
    public typealias Raw = Json

    public func toRaw() throws -> Json {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let dict = jsonObject as? [String: Any] else {
            throw RawMappableCodableError.cantMapObjectToRaw
        }
        return dict
    }
}

private struct PaginationAndSortingEntry: Encodable {
    let pagination: PaginationRequestEntry
    let sorting: [SortEntry]
    let snapshot: Date
    let seed: String?
}
