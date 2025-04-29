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
}
