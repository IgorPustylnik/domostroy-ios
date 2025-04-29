//
//  ConfirmRegisterEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import NodeKit

public struct ConfirmRegisterEntry {
    public let email: String
    public let password: String
    public let confirmationCode: String
}

extension ConfirmRegisterEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}
