//
//  OffersPageEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct OffersPageEntry: Codable {
    public let pagination: PaginationEntry
    public let data: [OfferEntry]
}

extension OffersPageEntry: RawMappable {
    public typealias Raw = Json
}
