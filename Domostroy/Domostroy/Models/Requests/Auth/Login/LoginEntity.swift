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

extension LoginEntity: DTOEncodable {
    public typealias DTO = LoginEntry

    public func toDTO() throws -> DTO {
        .init(
            email: email,
            password: password
        )
    }
}
