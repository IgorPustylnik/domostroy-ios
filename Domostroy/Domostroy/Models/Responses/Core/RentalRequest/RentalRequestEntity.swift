//
//  RentalRequestEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 11.05.2025.
//

import Foundation
import NodeKit

public struct RentalRequestEntity {
    public let id: Int
    public let status: RequestStatus
    public let dates: Set<Date>
    public let createdAt: Date
    public let resolvedAt: Date?
    public let offer: RentalRequestOfferEntity
    public let user: RentalRequestUserEntity
}

extension RentalRequestEntity: DTODecodable {
    public typealias DTO = RentalRequestEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            status: model.status,
            dates: .init(model.dates),
            createdAt: model.createdAt,
            resolvedAt: model.resolvedAt,
            offer: try .from(dto: model.offer),
            user: try .from(dto: model.user)
        )
    }
}

public struct RentalRequestOfferEntity {
    public let id: Int
    public let title: String
    public let photoUrl: URL
    public let price: PriceEntity
    public let city: String
}

extension RentalRequestOfferEntity: DTODecodable {
    public typealias DTO = RentalRequestOfferEntry

    public static func from(dto model: DTO) throws -> Self {
        return .init(
            id: model.id,
            title: model.title,
            photoUrl: model.photoUrl,
            price: .init(value: model.price, currency: .init(rawValue: model.currency)),
            city: model.city
        )
    }
}

public struct RentalRequestUserEntity {
    public let id: Int
    public let firstName: String
    public let lastName: String?
    public let phoneNumber: String

    public var name: String {
        if let lastName = lastName {
            return "\(firstName) \(lastName)"
        }
        return "\(firstName)"
    }
}

extension RentalRequestUserEntity: DTODecodable {
    public typealias DTO = RentalRequestUserEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(
            id: model.id,
            firstName: model.firstName,
            lastName: model.lastName,
            phoneNumber: model.phoneNumber
        )
    }
}
