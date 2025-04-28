//
//  RegisterEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct RegisterEntry: Codable {
    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
    public let email: String
    public let password: String
}

extension RegisterEntry: RawMappable {
    public typealias Raw = Json
}
