//
//  OfferDetailsEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct OfferDetailsEntity {
    public let id: Int
    public let title: String
    public let description: String
    public let category: CategoryEntity
    public let price: PriceEntity
    public let createdAt: Date
    public let userId: Int
    public let cityId: Int
//    public let calendarId: Int
    public let isFavorite: Bool
    public let photos: [URL]
}

// MARK: - DTOConvertible

extension OfferDetailsEntity: DTODecodable {
    public typealias DTO = OfferDetailsEntry

    public static func from(dto model: DTO) throws -> Self {
        try .init(
            id: model.id,
            title: model.title,
            description: model.description,
            // TODO: Load category name
            category: .init(id: model.category, name: "placeholder"),
            price: .init(value: model.price, currency: .init(rawValue: model.currency)),
            createdAt: model.createdAt,
            userId: model.userId,
            cityId: model.cityId,
//            calendarId: model.calendarId,
            isFavorite: model.isFavourite,
            photos: model.photos
        )
    }
}
