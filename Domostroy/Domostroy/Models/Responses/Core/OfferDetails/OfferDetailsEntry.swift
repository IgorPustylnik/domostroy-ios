//
//  OfferDetailsEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct OfferDetailsEntry {
    public let id: Int
    public let title: String
    public let description: String?
    public let category: Int
    public let price: Double
    public let currency: String
    public let createdAt: Date
    public let userId: Int
    public let cityId: Int
    public let isFavourite: Bool
    public let isBanned: Bool
    public let banReason: String?
    public let photos: [PhotoEntry]
}

extension OfferDetailsEntry: Decodable, RawDecodable {
    public typealias Raw = Json

    public static func from(raw: Raw) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601WithMicroseconds)
        let data = try JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted)
        return try decoder.decode(Self.self, from: data)
    }
}
