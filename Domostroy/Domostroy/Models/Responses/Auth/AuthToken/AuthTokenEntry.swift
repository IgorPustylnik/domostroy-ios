//
//  AuthTokenEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import NodeKit

public struct AuthTokenEntry: Codable {
    public let token: String
}

extension AuthTokenEntry: RawMappable {
    public typealias Raw = Json
}
