//
//  CreateRequestEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.05.2025.
//

import Foundation
import NodeKit
import UIKit

public struct CreateRequestEntity {
    public let offerId: Int
    public let dates: [Date]
}

extension CreateRequestEntity: DTOEncodable {
    public typealias DTO = CreateRequestEntry

    public func toDTO() throws -> DTO {
        .init(offerId: offerId, dates: dates)
    }
}
