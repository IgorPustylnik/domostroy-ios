//
//  ChangePasswordEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

public struct ChangePasswordEntity {
    public let oldPassword: String
    public let newPassword: String
}

extension ChangePasswordEntity: DTOEncodable {
    public typealias DTO = ChangePasswordEntry

    public func toDTO() throws -> DTO {
        .init(previousPassword: oldPassword, newPassword: newPassword)
    }
}
