//
//  UserEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct UserEntry {
    public let userId: Int
    public let firstName: String
    public let lastName: String?
    public let phoneNumber: String
    public let numOfOffers: Int
    public let createdAt: Date
}

extension UserEntry: Decodable, RawDecodable {
    public typealias Raw = Json

    public static func from(raw: Json) throws -> UserEntry {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyymmdd)
        let data = try JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted)
        return try decoder.decode(Self.self, from: data)
    }
}
