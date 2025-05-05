//
//  CategoriesEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import NodeKit

public struct CategoriesEntry {
    public let categories: [CategoryEntry]
}

extension CategoriesEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
