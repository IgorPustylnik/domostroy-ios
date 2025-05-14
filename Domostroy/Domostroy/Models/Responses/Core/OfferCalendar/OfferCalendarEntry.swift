//
//  OfferCalendarEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.05.2025.
//

import Foundation
import NodeKit

public struct OfferCalendarEntry {
    public let dates: [OfferCalendarDateEntry]
}

extension OfferCalendarEntry: Decodable, RawDecodable {
    public typealias Raw = Json

    public static func from(raw: Raw) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyymmdd)
        let data = try JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted)
        return try decoder.decode(Self.self, from: data)
    }
}

public struct OfferCalendarDateEntry {
    public let date: Date
    public let isBooked: Bool
}

extension OfferCalendarDateEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
