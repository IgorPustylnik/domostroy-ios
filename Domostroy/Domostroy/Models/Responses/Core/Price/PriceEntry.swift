//
//  PriceEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct PriceEntry: Codable {
    public let value: Double
    public let currency: Currency
}

extension PriceEntry: RawMappable {
    public typealias Raw = Json
}
