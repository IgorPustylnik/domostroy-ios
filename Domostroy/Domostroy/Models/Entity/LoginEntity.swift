//
//  LoginEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct LoginEntity {
    public let email: String
    public let password: String
}

extension LoginEntity: DTOConvertible {
    public typealias DTO = LoginEntry

    public func toDTO() throws -> DTO {
        .init(
            email: email,
            password: password
        )
    }

    public static func from(dto model: DTO) throws -> Self {
        .init(
            email: model.email,
            password: model.password
        )
    }
}
