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
    public let pas: PaginationAndSortRequestEntry
    public let searchCriteriaList: SearchCriteriaListRequestEntry
}

extension SearchOffersEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}

public struct PaginationAndSortRequestEntry: Encodable {
    public let pagination: PaginationRequestEntry
    public let sorting: [SortItemRequestEntry]
}

public struct SearchCriteriaListRequestEntry: Encodable {
    public let filterKey: String
    public let operation: String
    public let value: String
}

public struct PaginationRequestEntry: Encodable {
    public let page: Int
    public let size: Int
}

public struct SortItemRequestEntry: Encodable {
    public let property: String
    public let direction: String
}
