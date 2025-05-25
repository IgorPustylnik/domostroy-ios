//
//  EditOfferCalendarEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 24.05.2025.
//

import Foundation
import NodeKit

public struct EditOfferCalendarEntity {
    public let offerId: Int
    public let availableDates: [Date]
}

extension EditOfferCalendarEntity: DTOEncodable {
    public typealias DTO = EditOfferCalendarEntry

    public func toDTO() throws -> DTO {
        .init(offerId: offerId, availableDates: availableDates)
    }
}
