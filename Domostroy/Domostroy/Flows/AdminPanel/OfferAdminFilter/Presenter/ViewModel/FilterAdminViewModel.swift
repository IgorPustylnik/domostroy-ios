//
//  OfferAdminFilterViewModel.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 23.05.2025.
//

import Foundation

struct OfferAdminFilterViewModel {
    var categoryFilter: PickerModel<CategoryEntity>
    var priceFilter: (from: PriceEntity?, to: PriceEntity?)
    var statusFilter: OfferStatusViewModel

    var isNotEmpty: Bool {
        categoryFilter.selected != nil
        || priceFilter.from != nil
        || priceFilter.to != nil
        || statusFilter != .all
    }

    enum OfferStatusViewModel: CaseIterable {
        case all
        case active
        case banned

        var description: String {
            switch self {
            case .all:
                return L10n.Localizable.AdminPanel.Offers.Filter.Status.all
            case .active:
                return L10n.Localizable.AdminPanel.Offers.Filter.Status.active
            case .banned:
                return L10n.Localizable.AdminPanel.Offers.Filter.Status.banned
            }
        }

        var toFilterEntity: FilterEntity? {
            switch self {
            case .all:
                return nil
            case .active:
                return .init(filterKey: .isBanned, operation: .equals, value: AnyEncodable(false))
            case .banned:
                return .init(filterKey: .isBanned, operation: .equals, value: AnyEncodable(true))
            }
        }
    }

}
