//
//  MyUserEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct MyUserEntity {
    public let id: Int
    public let firstName: String
    public let lastName: String
    public let email: String
    public let phoneNumber: String
    public let isAdmin: Bool
}

extension MyUserEntity: DTOConvertible {
    public typealias DTO = MyUserEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            firstName: model.firstName,
            lastName: model.lastName,
            email: model.email,
            phoneNumber: model.phoneNumber,
            isAdmin: model.isAdmin
        )
    }

    public func toDTO() throws -> DTO {
        .init(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            isAdmin: isAdmin
        )
    }
}
