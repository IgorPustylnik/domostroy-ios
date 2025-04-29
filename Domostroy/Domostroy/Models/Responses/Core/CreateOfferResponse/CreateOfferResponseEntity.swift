//
//  CreateOfferResponseEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 30.04.2025.
//

import Foundation
import NodeKit

public struct CreateOfferResponseEntity {
}

extension CreateOfferResponseEntity: DTODecodable {
    public typealias DTO = CreateOfferResponseEntry

    public static func from(dto: CreateOfferResponseEntry) throws -> Self {
        .init()
    }
}
