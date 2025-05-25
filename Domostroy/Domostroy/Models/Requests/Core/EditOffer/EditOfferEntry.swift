//
//  EditOfferEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 24.05.2025.
//

import Foundation
import NodeKit

public struct EditOfferEntry {
    public let metadata: EditOfferMetadataEntry
    public let file: [Data]
}

extension EditOfferEntry: RawEncodable {
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
            payloadModel: [:],
            files: filesDict
        )

    }
}
