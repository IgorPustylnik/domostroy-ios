//
//  UserEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct UserEntry {
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let phoneNumber: String?
    public let offersAmount: Int?
    public let registrationDate: Date?
    public let isBanned: Bool
}

extension UserEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
