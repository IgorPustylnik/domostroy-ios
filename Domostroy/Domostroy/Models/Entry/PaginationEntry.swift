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

    public func toRaw() throws -> Raw {
        try JSONEncoder().encodeJson(self)
    }

    public static func from(raw: Raw) throws -> Self {
        try JSONDecoder().decodeJson(raw: raw)
    }
}
