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
    public let file: [Data]
}

extension CreateOfferEntry: RawEncodable {
    public typealias Raw = MultipartModel<[String: Data]>

    public func toRaw() throws -> Raw {
        var filesDict = Dictionary(
            uniqueKeysWithValues: self.file.enumerated().map { index, photoData in
                (
                    "\(index)",
                    MultipartFileProvider.data(data: photoData, filename: "file", mimetype: "image/jpeg")
                )
            }
        )

        filesDict["metadata"] = MultipartFileProvider.data(
            data: try JSONSerialization.data(withJSONObject: metadata.toRaw()),
            filename: "metadata",
            mimetype: "application/json"
        )
        return .init(
            payloadModel: [:
//                "metadata": try JSONSerialization.data(withJSONObject: metadata.toRaw(), options: [])
            ],
            files: filesDict
        )

    }
}
