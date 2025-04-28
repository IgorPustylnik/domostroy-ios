//
//  PriceEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct PriceEntity {
    public let value: Double
    public let currency: Currency
}

extension PriceEntity: DTOConvertible {
    public func toDTO() throws -> PriceEntry {
        .init(
            value: value,
            currency: currency
        )
    }

    public static func from(dto model: PriceEntry) throws -> PriceEntity {
        .init(
            value: model.value,
            currency: model.currency
        )
    }
}
