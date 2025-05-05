//
//  MyOfferEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct MyOfferEntity {
    public let id: Int
    public let title: String
    public let description: String
    public let price: PriceEntity
    public let createdAt: Date
    public let photoUrl: URL
}

// MARK: - DTOConvertible

extension MyOfferEntity: DTODecodable {
    public typealias DTO = MyOfferEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            title: model.title,
            description: model.description,
            price: .init(value: model.price, currency: .init(rawValue: model.currency)),
            createdAt: model.createdAt,
            photoUrl: model.photoUrl
        )
    }
}
