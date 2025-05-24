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

    public static func from(raw: Raw) throws -> Self {
        guard let id = raw["id"] as? Int,
              let statusRaw = raw["status"] as? String,
              let status = RequestStatus(rawValue: statusRaw),
              let datesRaw = raw["dates"] as? [String],
              let createdAtStr = raw["createdAt"] as? String,
              let offerRaw = raw["offer"] as? Json,
              let userRaw = raw["user"] as? Json
        else {
            throw NSError(domain: "Invalid format", code: 1)
        }
        let resolvedAtRaw = raw["resolvedAt"] as? String
        let dates: [Date] = try datesRaw.compactMap {
            guard let date = DateFormatter.yyyymmdd.date(from: $0) else {
                throw ResponseDataParserNodeError.cantDeserializeJson($0)
            }
            return date
        }
        guard let createdAt: Date = DateFormatter.iso8601WithMicroseconds.date(from: createdAtStr) else {
            throw ResponseDataParserNodeError.cantDeserializeJson(createdAtStr)
        }
        var resolvedAt: Date?
        if let resolvedAtRaw {
            guard let resolvedAt = DateFormatter.iso8601WithMicroseconds.date(from: resolvedAtRaw) else {
                throw ResponseDataParserNodeError.cantDeserializeJson(resolvedAtRaw)
            }
        }
        return .init(
            id: id,
            status: status,
            dates: dates,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            offer: try .from(raw: offerRaw),
            user: try .from(raw: userRaw)
        )
    }
}

public struct RentalRequestOfferEntry {
    public let offerId: Int
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
