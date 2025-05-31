//
//  RentalRequest1Entry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 18.05.2025.
//

import Foundation
import NodeKit

public struct RentalRequest1Entry {
    public let id: Int
    public let status: RequestStatus
    public let dates: [Date]
    public let createdAt: Date
    public let resolvedAt: Date?
    public let offerId: Int
    public let title: String
    public let photoUrl: URL
    public let price: Double
    public let currency: String
    public let city: String
    public let userId: Int
    public let name: String
    public let phoneNumber: String
}

extension RentalRequest1Entry: Decodable, RawDecodable {
    public typealias Raw = Json

    public static func from(raw: Raw) throws -> Self {
        guard let id = raw["id"] as? Int,
              let statusRaw = raw["status"] as? String,
              let status = RequestStatus(rawValue: statusRaw),
              let datesRaw = raw["dates"] as? [String],
              let createdAtStr = raw["createdAt"] as? String,
              let offerId = raw["offerId"] as? Int,
              let title = raw["title"] as? String,
              let photoUrlRaw = raw["photoUrl"] as? String,
              let photoUrl = URL(string: photoUrlRaw),
              let price = raw["price"] as? Double,
              let currency = raw["currency"] as? String,
              let city = raw["city"] as? String,
              let userId = raw["userId"] as? Int,
              let name = raw["name"] as? String,
              let phoneNumber = raw["phoneNumber"] as? String
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
            guard let resolvedAtParsed = DateFormatter.iso8601WithMicroseconds.date(from: resolvedAtRaw) else {
                throw ResponseDataParserNodeError.cantDeserializeJson(resolvedAtRaw)
            }
            resolvedAt = resolvedAtParsed
        }
        return .init(
            id: id,
            status: status,
            dates: dates,
            createdAt: createdAt,
            resolvedAt: resolvedAt,
            offerId: offerId,
            title: title,
            photoUrl: photoUrl,
            price: price,
            currency: currency,
            city: city,
            userId: userId,
            name: name,
            phoneNumber: phoneNumber
        )
    }
}
