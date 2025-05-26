//
//  BriefOfferAdminEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.05.2025.
//

import Foundation
import NodeKit

public struct BriefOfferAdminEntity {
    public let id: Int
    public let title: String
    public let description: String
    public let price: PriceEntity
    public let city: String
    public let photoUrl: URL
    public let isBanned: Bool
    public let banReason: String?
}

// MARK: - DTOConvertible

extension BriefOfferAdminEntity: DTODecodable {
    public typealias DTO = BriefOfferAdminEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            title: model.title,
            description: model.description,
            price: .init(value: model.price, currency: .init(rawValue: model.currency)),
            city: model.city,
            photoUrl: model.photoUrl,
            isBanned: model.isBanned,
            banReason: model.banReason
        )
    }
}
