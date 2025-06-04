//
//  OfferIdEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.05.2025.
//

import Foundation
import NodeKit

public struct OfferIdEntity {
    public let offerId: Int
}

// MARK: - DTOConvertible

extension OfferIdEntity: DTODecodable {
    public typealias DTO = OfferIdEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            offerId: model.offerId
        )
    }
}
