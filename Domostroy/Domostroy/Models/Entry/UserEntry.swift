//
//  UserEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct UserEntry: Codable {
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
}

extension UserEntry: RawMappable {
    public typealias Raw = Json

    public func toRaw() throws -> Raw {
        try JSONEncoder().encodeJson(self)
    }

    public static func from(raw: Raw) throws -> Self {
        try JSONDecoder().decodeJson(raw: raw)
    }
}
