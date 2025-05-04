//
//  AuthTokenEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import NodeKit

public struct AuthTokenEntry {
    public let token: String
    public let expiresAt: Date
}

extension AuthTokenEntry: Codable, RawMappable {
    public typealias Raw = Json

    public static func from(raw: Json) throws -> AuthTokenEntry {
        let decoder = JSONDecoder()
        let data = try JSONSerialization.data(withJSONObject: raw, options: .prettyPrinted)
        decoder.dateDecodingStrategy = .formatted(.iso8601WithMicroseconds)
        return try decoder.decode(AuthTokenEntry.self, from: data)
    }

    public func toRaw() throws -> Json {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.iso8601WithMicroseconds)
        let data = try encoder.encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? Json
        return json ?? [:]
    }
}
