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
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyymmdd)
        let data = try JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted)
        return try decoder.decode(Self.self, from: data)
    }
}
