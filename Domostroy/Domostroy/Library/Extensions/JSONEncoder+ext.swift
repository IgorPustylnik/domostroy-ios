//
//  JSONEncoder+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

extension JSONEncoder {
    func encodeJson<T: Encodable>(_ value: T) throws -> Json {
        let data = try self.encode(value)
        guard let json = try JSONSerialization.jsonObject(with: data) as? Json else {
            throw NSError(domain: "EncodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode \(T.self)"])
        }
        return json
    }
}
