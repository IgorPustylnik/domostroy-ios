//
//  OfferCalendarEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.05.2025.
//

import Foundation
import NodeKit

public struct OfferCalendarEntity {
    public let dates: [OfferCalendarDateEntity]
}

extension OfferCalendarEntity: DTODecodable {
    public typealias DTO = OfferCalendarEntry

    public static func from(dto model: DTO) throws -> Self {
        try .init(dates: model.dates.map { try .from(dto: $0) })
    }
}

public struct OfferCalendarDateEntity {
    let date: Date
    let isBooked: Bool
}

extension OfferCalendarDateEntity: DTODecodable {
    public typealias DTO = OfferCalendarDateEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(date: model.date, isBooked: model.isBooked)
    }
}
