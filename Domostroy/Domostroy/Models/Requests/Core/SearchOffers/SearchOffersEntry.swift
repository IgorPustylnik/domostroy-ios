//
//  SearchOffersEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import NodeKit
import UIKit

public struct SearchOffersEntry {
    private let pas: PaginationAndSortingEntry
    public let searchCriteriaList: [FilterEntry]

    init(pagination: PaginationRequestEntry, sorting: [SortEntry], searchCriteriaList: [FilterEntry]) {
        self.pas = .init(pagination: pagination, sorting: sorting)
        self.searchCriteriaList = searchCriteriaList
    }
}

extension SearchOffersEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}

private struct PaginationAndSortingEntry: Encodable {
    let pagination: PaginationRequestEntry
    let sorting: [SortEntry]
}
