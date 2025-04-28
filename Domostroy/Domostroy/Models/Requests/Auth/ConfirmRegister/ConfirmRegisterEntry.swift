//
//  ConfirmRegisterEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import NodeKit

public struct ConfirmRegisterEntry: Codable {
    public let email: String
    public let password: String
    public let confirmationCode: Int
}

extension ConfirmRegisterEntry: RawMappable {
    public typealias Raw = Json
}
