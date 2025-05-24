//
//  SearchModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SearchModuleInput: AnyObject {
    func setQuery(_ query: String?)
    func setCity(_ city: CityEntity?)
    func setSort(_ sort: SortViewModel)
    func setFilters(_ filters: OfferFilterViewModel)
}
