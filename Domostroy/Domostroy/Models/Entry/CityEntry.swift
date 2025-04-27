//
//  CityEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct CityEntry: Codable {
    public let id: Int
    public let name: String
}

extension CityEntry: RawMappable {
    public typealias Raw = Json

    public func toRaw() throws -> Raw {
        try JSONEncoder().encodeJson(self)
    }

    public static func from(raw: Raw) throws -> Self {
        try JSONDecoder().decodeJson(raw: raw)
    }
}
