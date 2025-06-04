//
//  AuthTokenEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import NodeKit

public struct AuthTokenEntity {
    public let token: String
    public let expiresAt: Date
}

extension AuthTokenEntity: DTOConvertible {
    public typealias DTO = AuthTokenEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(token: model.token, expiresAt: model.expiresAt)
    }

    public func toDTO() throws -> DTO {
        .init(token: token, expiresAt: expiresAt)
    }
}
