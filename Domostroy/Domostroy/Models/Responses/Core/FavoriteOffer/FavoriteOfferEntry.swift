//
//  FavoriteOfferEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct FavoriteOfferEntry {
    public let id: Int
    public let title: String
    public let description: String?
    public let price: Double
    public let currency: String
    public let photoUrl: URL
    public let lessorId: Int
}

extension FavoriteOfferEntry: Decodable, RawDecodable {
    public typealias Raw = Json

    public static func from(raw: Raw) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyymmdd)
        let data = try JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted)
        return try decoder.decode(Self.self, from: data)
    }
}
