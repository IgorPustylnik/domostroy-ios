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
    public let confirmationCode: String
}

extension ConfirmRegisterEntity: DTOEncodable {
    public typealias DTO = ConfirmRegisterEntry

    public func toDTO() throws -> DTO {
        .init(
            email: email,
            password: password,
            confirmationCode: confirmationCode
        )
    }
}
