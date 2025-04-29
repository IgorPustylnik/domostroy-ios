//
//  CityEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct CityEntry {
    public let id: Int
    public let name: String
}

extension CityEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
