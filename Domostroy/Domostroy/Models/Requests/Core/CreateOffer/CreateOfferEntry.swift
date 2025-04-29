//
//  CreateOfferEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import NodeKit

public struct CreateOfferEntry {
    public let metadata: CreateOfferMetadataEntry
    public let photos: [Data]
}

extension CreateOfferEntry: RawEncodable {
    public typealias Raw = MultipartModel<[String: Data]>

    public func toRaw() throws -> Raw {
        return .init(
            payloadModel: [
                "metadata": try JSONSerialization.data(withJSONObject: metadata.toRaw(), options: [])
            ],
            files: Dictionary(
                uniqueKeysWithValues: self.photos.enumerated().map { index, photoData in
                    (
                        "\(index)",
                        .data(data: photoData, filename: "photo\(index)", mimetype: "jpg")
                    )
                }
            )
        )
    }
}
