//
//  RentalRequestEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 11.05.2025.
//

import Foundation
import NodeKit

public struct RentalRequestEntry {
    public let id: Int
    public let status: RequestStatus
    public let dates: [Date]
    public let createdAt: Date
    public let resolvedAt: Date?
    public let offer: RentalRequestOfferEntry
    public let user: RentalRequestUserEntry
}

extension RentalRequestEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}

public struct RentalRequestOfferEntry {
    public let id: Int
    public let title: String
    public let photoUrl: URL
    public let price: Double
    public let currency: String
    public let city: String
}

extension RentalRequestOfferEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}

public struct RentalRequestUserEntry {
    public let id: Int
    public let name: String
    public let phoneNumber: String
}

extension RentalRequestUserEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
