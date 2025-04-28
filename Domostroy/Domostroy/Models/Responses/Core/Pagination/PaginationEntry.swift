//
//  PaginationEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct PaginationEntry: Codable {
    public let totalCount: Int
    public let totalPages: Int
    public let perPage: Int
}

extension PaginationEntry: RawMappable {
    public typealias Raw = Json
}
