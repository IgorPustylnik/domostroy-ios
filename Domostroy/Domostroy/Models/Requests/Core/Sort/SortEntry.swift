//
//  SortEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct SortEntry {
    public let property: String
    public let direction: String
}

extension SortEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}
