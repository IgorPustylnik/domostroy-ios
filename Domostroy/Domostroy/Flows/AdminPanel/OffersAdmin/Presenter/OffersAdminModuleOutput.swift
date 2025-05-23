//
//  OffersAdminModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OffersAdminModuleOutput: AnyObject {
    var onOpenCity: ((CityEntity?) -> Void)? { get set }
    var onOpenSort: ((SortViewModel) -> Void)? { get set }
    var onOpenFilters: ((FiltersViewModel) -> Void)? { get set }
    var onOpenOffer: ((Int) -> Void)? { get set }
    func getSearchQuery() -> String?
}
