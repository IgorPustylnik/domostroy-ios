//
//  CreateRequestEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.05.2025.
//

import Foundation
import NodeKit

public struct CreateRequestEntry {
    let offerId: Int
    let dates: [Date]
}

extension CreateRequestEntry: Encodable, RawEncodable {
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
