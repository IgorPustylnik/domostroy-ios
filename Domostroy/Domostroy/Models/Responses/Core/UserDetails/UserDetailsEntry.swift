//
//  UserDetailsEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 21.05.2025.
//

import Foundation
import NodeKit

public struct UserDetailsEntry {
    public let id: Int
    public let name: String
    public let email: String
    public let phoneNumber: String
    public let numOfOffers: Int
    public let role: Role
    public let isBanned: Bool
    public let createdAt: Date
}

extension UserDetailsEntry: Decodable, RawDecodable {
    public typealias Raw = Json

    public static func from(raw: Json) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyymmdd)
        let data = try JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted)
        return try decoder.decode(Self.self, from: data)
    }
}
