//
//  PaginationRequestEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct PaginationRequestEntry {
    public let page: Int
    public let size: Int
}

extension PaginationRequestEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}
