//
//  FilterEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct FilterEntry {
    public let filterKey: String
    public let operation: String
    public let value: AnyEncodable
}

extension FilterEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}
