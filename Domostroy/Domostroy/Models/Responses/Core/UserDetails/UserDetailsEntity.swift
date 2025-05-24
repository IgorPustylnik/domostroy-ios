//
//  UserDetailsEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 21.05.2025.
//

import Foundation
import NodeKit

public struct UserDetailsEntity {
    public let id: Int
    public let name: String
    public let email: String
    public let phoneNumber: String
    public let offersAmount: Int
    public let isBanned: Bool
    public let isAdmin: Bool
    public let registrationDate: Date
}

extension UserDetailsEntity: DTODecodable {
    public typealias DTO = UserDetailsEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            name: model.name,
            email: model.email,
            phoneNumber: model.phoneNumber,
            offersAmount: model.numOfOffers,
            isBanned: model.isBanned,
            isAdmin: model.isAdmin,
            registrationDate: model.createdAt
        )
    }
}
