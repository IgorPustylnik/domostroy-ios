//
//  RegisterEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct RegisterEntry {
    public let firstName: String
    public let lastName: String?
    public let phoneNumber: String
    public let email: String
    public let password: String
}

extension RegisterEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}
