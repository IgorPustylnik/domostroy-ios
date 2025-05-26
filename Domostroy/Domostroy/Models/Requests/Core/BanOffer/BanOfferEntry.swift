//
//  BanOfferEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 26.05.2025.
//

import Foundation
import NodeKit

public struct BanOfferEntry {
    let offerId: Int
    let banReason: String?
}

extension BanOfferEntry: Encodable, RawEncodable {
    public typealias Raw = Json
}
