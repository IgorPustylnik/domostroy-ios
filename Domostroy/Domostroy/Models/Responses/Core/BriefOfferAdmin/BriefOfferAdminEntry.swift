//
//  BriefOfferAdminEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.05.2025.
//

import Foundation
import NodeKit

public struct BriefOfferAdminEntry {
    public let id: Int
    public let title: String
    public let description: String
    public let price: Double
    public let currency: String
    public let city: String
    public let photoUrl: URL
    public let isBanned: Bool
    public let banReason: String?
}

extension BriefOfferAdminEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
