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
    public let description: String
    public let price: PriceEntity
    public let city: String
    public let photoUrl: URL
    public let isBanned: Bool
    public let banReason: String
    public let isFavorite: Bool
}

// MARK: - DTOConvertible

extension BriefOfferEntity: DTODecodable {
    public typealias DTO = BriefOfferEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            title: model.title,
            // TODO: Fetch from server
            description: "nil",
            price: .init(value: model.price, currency: .init(rawValue: model.currency)),
            city: model.city,
            photoUrl: model.photoUrl,
            isBanned: Int.random(in: 0..<2) < 1,
            banReason: "nil ban reason",
            isFavorite: model.isFavourite
        )
    }
}
