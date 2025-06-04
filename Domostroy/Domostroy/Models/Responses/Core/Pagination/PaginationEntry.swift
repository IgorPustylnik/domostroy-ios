//
//  PaginationEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct PaginationEntry {
    public let totalElements: Int
    public let totalPages: Int
}

extension PaginationEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
