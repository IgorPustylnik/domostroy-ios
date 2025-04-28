//
//  OfferEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct OfferEntity {
    public let id: Int
    public let title: String
    public let description: String
    public let category: CategoryEntity
    public let price: PriceEntity
    public let createdAt: Date
    public let userId: Int
    public let cityId: Int
    public let calendarId: Int
    public let isFavorite: Bool
    public let photos: [URL]
}

// MARK: - DTOConvertible

extension OfferEntity: DTOConvertible {
    public typealias DTO = OfferEntry

    public static func from(dto model: DTO) throws -> Self {
        try .init(
            id: model.id,
            title: model.title,
            description: model.description,
            category: .from(dto: model.category),
            price: .from(dto: model.price),
            createdAt: model.createdAt,
            userId: model.userId,
            cityId: model.cityId,
            calendarId: model.calendarId,
            isFavorite: model.isFavorite,
            photos: model.photos
        )
    }

    public func toDTO() throws -> DTO {
        try .init(
            id: id,
            title: title,
            description: description,
            category: category.toDTO(),
            price: price.toDTO(),
            createdAt: createdAt,
            userId: userId,
            cityId: cityId,
            calendarId: calendarId,
            isFavorite: isFavorite,
            photos: photos
        )
    }
}
