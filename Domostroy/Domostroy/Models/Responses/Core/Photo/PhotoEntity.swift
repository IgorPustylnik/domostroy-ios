//
//  PhotoEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.05.2025.
//

import Foundation
import NodeKit

public struct PhotoEntity {
    let id: Int
    let url: URL
}

extension PhotoEntity: DTODecodable {
    public typealias DTO = PhotoEntry

    public static func from(dto model: DTO) throws -> PhotoEntity {
        .init(id: model.id, url: model.url)
    }
}
