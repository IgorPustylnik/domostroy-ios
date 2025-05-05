//
//  FavoriteOfferEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct FavoriteOfferEntity {
    public let id: Int
    public let title: String
    public let description: String
    public let price: PriceEntity
    public let photoUrl: URL
    public let userId: Int
}

// MARK: - DTOConvertible

extension FavoriteOfferEntity: DTODecodable {
    public typealias DTO = FavoriteOfferEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            title: model.title,
            description: model.description,
            price: .init(value: model.price, currency: .init(rawValue: model.currency)),
            photoUrl: model.photoUrl,
            userId: model.lessorId
        )
    }
}
