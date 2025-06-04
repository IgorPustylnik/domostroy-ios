//
//  EditUserInfoEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

public struct EditUserInfoEntry {
    public let firstName: String
    public let lastName: String?
    public let phoneNumber: String
}

extension EditUserInfoEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}
