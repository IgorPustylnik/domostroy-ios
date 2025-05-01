//
//  MyUserEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct MyUserEntry {
    public let id: Int
    public let firstName: String
    public let lastName: String?
    public let email: String
    public let phoneNumber: String
    public let isAdmin: Bool
    public let isBanned: Bool
}

extension MyUserEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
