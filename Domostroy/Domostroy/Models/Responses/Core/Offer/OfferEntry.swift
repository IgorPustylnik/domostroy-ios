//
//  OfferEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct OfferEntry: Codable {
    public let id: Int
    public let title: String
    public let description: String
    public let category: CategoryEntry
    public let price: PriceEntry
    public let createdAt: Date
    public let userId: Int
    public let cityId: Int
    public let calendarId: Int
    public let isFavorite: Bool
    public let photos: [URL]
}

extension OfferEntry: RawMappable {
    public typealias Raw = Json
}
