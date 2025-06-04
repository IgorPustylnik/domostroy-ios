//
//  OfferFilterViewModel.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 23.05.2025.
//

struct OfferFilterViewModel {
    var categoryFilter: PickerModel<CategoryEntity>
    var priceFilter: (from: PriceEntity?, to: PriceEntity?)

    var isNotEmpty: Bool {
        categoryFilter.selected != nil
        || priceFilter.from != nil
        || priceFilter.to != nil
    }
}
