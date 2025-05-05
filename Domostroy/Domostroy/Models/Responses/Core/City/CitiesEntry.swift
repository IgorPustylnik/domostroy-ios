//
//  CitiesEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

public struct CitiesEntry {
    public let cities: [CityEntry]
}

extension CitiesEntry: Codable, RawMappable {
    public typealias Raw = Json
}
