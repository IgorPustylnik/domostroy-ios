//
//  ConfirmRegisterEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import NodeKit

public struct ConfirmRegisterEntity {
    public let email: String
    public let password: String
    public let confirmationCode: Int
}

extension ConfirmRegisterEntity: DTOConvertible {
    public typealias DTO = ConfirmRegisterEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            email: model.email,
            password: model.password,
            confirmationCode: model.confirmationCode
        )
    }
    
    public func toDTO() throws -> DTO {
        .init(
            email: email,
            password: password,
            confirmationCode: confirmationCode
        )
    }
}

