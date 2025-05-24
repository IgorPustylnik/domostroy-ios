//
//  RentalRequest1Entity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 18.05.2025.
//

import Foundation
import NodeKit

public struct RentalRequest1Entity {
    public let id: Int
    public let status: RequestStatus
    public let dates: [Date]
    public let createdAt: Date
    public let resolvedAt: Date?
    public let offerId: Int
    public let title: String
    public let photoUrl: URL
    public let price: PriceEntity
    public let city: String
    public let userId: Int
    public let name: String
    public let phoneNumber: String
}

extension RentalRequest1Entity: DTODecodable {
    public typealias DTO = RentalRequest1Entry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            status: model.status,
            dates: model.dates,
            createdAt: model.createdAt,
            resolvedAt: model.resolvedAt,
            offerId: model.offerId,
            title: model.title,
            photoUrl: model.photoUrl,
            price: .init(value: model.price, currency: .init(rawValue: model.currency)),
            city: model.city,
            userId: model.userId,
            name: model.name,
            phoneNumber: model.phoneNumber
        )
    }
}
