//
//  LoginEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct LoginEntry: Codable {
    public let email: String
    public let password: String
}

extension LoginEntry: RawMappable {
    public typealias Raw = Json
}
