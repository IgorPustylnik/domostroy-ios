//
//  CategoryEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct CategoryEntry: Codable {
    public let id: Int
    public let name: String
}

extension CategoryEntry: RawMappable {
    public typealias Raw = Json
}
