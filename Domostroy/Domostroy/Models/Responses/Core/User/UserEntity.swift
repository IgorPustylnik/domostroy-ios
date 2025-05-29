//
//  UserEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct UserEntity {
    public let id: Int
    public let firstName: String
    public let lastName: String?
    public let phoneNumber: String
    public let offersAmount: Int
    public let registrationDate: Date
    public let role: Role
    public let isBanned: Bool

    public var name: String {
        if let lastName = lastName {
            return "\(firstName) \(lastName)"
        }
        return "\(firstName)"
    }
}

extension UserEntity: DTODecodable {
    public typealias DTO = UserEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.userId,
            firstName: model.firstName,
            lastName: model.lastName,
            phoneNumber: model.phoneNumber,
            offersAmount: model.numOfOffers,
            registrationDate: model.createdAt,
            role: model.role,
            isBanned: model.isBanned
        )
    }
}
