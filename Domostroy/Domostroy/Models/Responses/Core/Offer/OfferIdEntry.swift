//
//  OfferIdEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.05.2025.
//

import Foundation
import NodeKit

public struct OfferIdEntry {
    public let offerId: Int
}

extension OfferIdEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
