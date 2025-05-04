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
    case recent

    var description: String {
        switch self {
        case .default:
            return L10n.Localizable.Sort.default
        case .priceAscending:
            return L10n.Localizable.Sort.priceAscending
        case .priceDescending:
            return L10n.Localizable.Sort.priceDescending
        case .recent:
            return L10n.Localizable.Sort.recent
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
        case .recent:
            return .init(property: .date, direction: .descending)
        }
    }
}
