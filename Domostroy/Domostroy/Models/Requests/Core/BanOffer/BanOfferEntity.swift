//
//  BanOfferEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 26.05.2025.
//

import Foundation
import NodeKit

public struct BanOfferEntity {
    let offerId: Int
    let banReason: String?
}

extension BanOfferEntity: DTOEncodable {
    public typealias DTO = BanOfferEntry

    public func toDTO() throws -> BanOfferEntry {
        .init(offerId: offerId, banReason: banReason)
    }
}
