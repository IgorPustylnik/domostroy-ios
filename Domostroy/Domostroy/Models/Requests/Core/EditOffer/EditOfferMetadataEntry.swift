//
//  EditOfferMetadataEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 24.05.2025.
//

import Foundation
import NodeKit

public struct EditOfferMetadataEntry: Codable {
    public let id: Int
    public let title: String
    public let description: String?
    public let categoryId: Int
    public let price: Double
    public let currency: String
    public let cityId: Int
    public let photoIds: [Int]
}

extension EditOfferMetadataEntry: RawMappable {
    public typealias Raw = Json

    public func toRaw() throws -> Json {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.yyyymmdd)

        let data = try encoder.encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let dict = jsonObject as? [String: Any] else {
            throw RawMappableCodableError.cantMapObjectToRaw
        }
        return dict
    }
}
