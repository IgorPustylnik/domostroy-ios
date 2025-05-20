//
//  Page1Entry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 05.05.2025.
//

import Foundation
import NodeKit

public struct Page1Entry<Entry: Decodable & RawDecodable> {
    public let totalElements: Int
    public let totalPages: Int
    public let content: [Entry]
}

extension Page1Entry: Decodable, RawDecodable {
    public typealias Raw = Json

    public static func from(raw: Raw) throws -> Self {
        guard let totalElements = raw["totalElements"] as? Int,
              let totalPages = raw["totalPages"] as? Int,
              let contentRaw = raw["content"] as? [Entry.Raw] else {
            throw NSError(domain: "Invalid format", code: 1)
        }

        let content = try contentRaw.map { try Entry.from(raw: $0) }

        return Page1Entry(
            totalElements: totalElements,
            totalPages: totalPages,
            content: content
        )
    }
}
