//
//  BriefOfferEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct BriefOfferEntry {
    public let id: Int
    public let title: String
    public let price: Double
    public let currency: String
    public let city: String
    public let photoUrl: URL
    public let isFavourite: Bool
}

extension BriefOfferEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
