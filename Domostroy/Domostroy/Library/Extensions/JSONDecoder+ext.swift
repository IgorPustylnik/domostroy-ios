//
//  JSONDecoder+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

extension JSONDecoder {
    func decodeJson<T: Decodable>(raw: Json) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: raw)
        return try self.decode(T.self, from: data)
    }
}
