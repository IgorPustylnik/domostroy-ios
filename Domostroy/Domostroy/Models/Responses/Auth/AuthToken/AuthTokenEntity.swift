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
}

extension AuthTokenEntity: DTOConvertible {
    public typealias DTO = AuthTokenEntry

    public func toDTO() throws -> DTO {
        .init(token: token)
    }

    public static func from(dto model: DTO) throws -> Self {
        .init(token: model.token)
    }
}
