//
//  ChangePasswordEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

public struct ChangePasswordEntry {
    public let previousPassword: String
    public let newPassword: String
}

extension ChangePasswordEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}
