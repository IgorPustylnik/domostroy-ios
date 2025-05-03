//
//  BriefOfferEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct BriefOfferEntity {
    public let id: Int
    public let title: String
    public let price: PriceEntity
    public let city: CityEntity
    public let photoUrl: URL
    public let isFavorite: Bool
}

// MARK: - DTOConvertible

extension BriefOfferEntity: DTODecodable {
    public typealias DTO = BriefOfferEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            title: model.title,
            price: .init(value: model.price, currency: .init(rawValue: model.currency)),
            city: try .from(dto: model.city),
            photoUrl: model.photoUrl,
            isFavorite: model.isFavorite
        )
    }
}
