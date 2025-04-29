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
    public let lastName: String
    public let phoneNumber: String?
    public let offersAmount: Int?
    public let registrationDate: Date?
    public let isBanned: Bool
}

extension UserEntity: DTODecodable {
    public typealias DTO = UserEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            firstName: model.firstName,
            lastName: model.lastName,
            phoneNumber: model.phoneNumber,
            offersAmount: model.offersAmount,
            registrationDate: model.registrationDate,
            isBanned: model.isBanned
        )
    }
}
