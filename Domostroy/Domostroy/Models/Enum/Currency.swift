//
//  Currency.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation

public enum Currency: String, Codable {
    case rub = "RUB"
    case unknown

    public init(rawValue: String) {
        switch rawValue {
        case Currency.rub.rawValue:
            self = .rub
        default:
            self = .unknown
        }
    }

    var description: String {
        switch self {
        case .rub:
            return "₽"
        case .unknown:
            return "?"
        }
    }
}
