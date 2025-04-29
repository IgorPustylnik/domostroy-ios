//
//  OfferEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct OfferEntry {
    public let id: Int
    public let title: String
    public let description: String
    public let category: CategoryEntry
    public let price: Double
    public let currency: String
    public let createdAt: Date
    public let userId: Int
    public let city: CityEntry
    public let calendarId: Int
    public let isFavorite: Bool
    public let photos: [URL]
}

extension OfferEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
