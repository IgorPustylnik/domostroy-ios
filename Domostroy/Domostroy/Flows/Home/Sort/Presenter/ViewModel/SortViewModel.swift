//
//  SortViewModel.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

public enum SortViewModel: CaseIterable {
    case `default`
    case priceAscending
    case priceDescending
    case newest
    case oldest

    var description: String {
        switch self {
        case .default:
            return L10n.Localizable.Sort.default
        case .priceAscending:
            return L10n.Localizable.Sort.priceAscending
        case .priceDescending:
            return L10n.Localizable.Sort.priceDescending
        case .newest:
            return L10n.Localizable.Sort.newest
        case .oldest:
            return L10n.Localizable.Sort.oldest
        }
    }

    var toSortEntity: SortEntity? {
        switch self {
        case .default:
            return nil
        case .priceAscending:
            return .init(property: .price, direction: .ascending)
        case .priceDescending:
            return .init(property: .price, direction: .descending)
        case .newest:
            return .init(property: .date, direction: .descending)
        case .oldest:
            return .init(property: .date, direction: .ascending)
        }
    }
}
