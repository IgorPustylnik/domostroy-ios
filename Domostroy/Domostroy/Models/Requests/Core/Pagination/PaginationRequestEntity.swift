//
//  PaginationRequestEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.05.2025.
//

import Foundation
import NodeKit

public struct PaginationRequestEntity {
    public let page: Int
    public let size: Int
}

extension PaginationRequestEntity: DTOEncodable {
    public typealias DTO = PaginationRequestEntry

    public func toDTO() throws -> PaginationRequestEntry {
        .init(page: page, size: size)
    }
}
