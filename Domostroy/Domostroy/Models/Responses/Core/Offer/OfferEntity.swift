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
    public let city: CityEntity
    public let calendarId: Int
    public let isFavorite: Bool
    public let photos: [URL]
}

public struct PriceEntity: Codable {
    public let value: Double
    public let currency: Currency
}

// MARK: - DTOConvertible

extension OfferEntity: DTODecodable {
    public typealias DTO = OfferEntry

    public static func from(dto model: DTO) throws -> Self {
        try .init(
            id: model.id,
            title: model.title,
            description: model.description,
            category: .from(dto: model.category),
            price: .init(value: model.price, currency: .init(rawValue: model.currency)),
            createdAt: model.createdAt,
            userId: model.userId,
            city: .from(dto: model.city),
            calendarId: model.calendarId,
            isFavorite: model.isFavorite,
            photos: model.photos
        )
    }
}
