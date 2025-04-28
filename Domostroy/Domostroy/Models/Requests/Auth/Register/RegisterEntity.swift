//
//  RegisterEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct RegisterEntity {
    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
    public let email: String
    public let password: String
}

extension RegisterEntity: DTOConvertible {
    public typealias DTO = RegisterEntry

    public func toDTO() throws -> DTO {
        .init(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            email: email,
            password: password
        )
    }

    public static func from(dto model: DTO) throws -> Self {
        .init(
            firstName: model.email,
            lastName: model.lastName,
            phoneNumber: model.phoneNumber,
            email: model.email,
            password: model.password
        )
    }
}
