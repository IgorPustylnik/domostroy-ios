//
//  OffersAdminModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OffersAdminModuleInput: AnyObject {
    func search(_ query: String?)
    func setCity(_ city: CityEntity?)
    func setSort(_ sort: SortViewModel)
    func setFilters(_ filters: FiltersViewModel)
    func setAdminPanelModuleInput(_ input: AdminPanelModuleInput?)
    func openCities()
    func openSort()
    func openFilters()
}
