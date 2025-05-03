//
//  EditUserInfoEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

public struct EditUserInfoEntity {
    public let firstName: String
    public let lastName: String?
    public let phoneNumber: String
}

extension EditUserInfoEntity: DTOEncodable {
    public typealias DTO = EditUserInfoEntry

    public func toDTO() throws -> DTO {
        .init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
    }
}
