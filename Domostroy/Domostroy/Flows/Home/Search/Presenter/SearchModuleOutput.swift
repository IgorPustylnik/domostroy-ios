//
//  SearchModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SearchModuleOutput: AnyObject {
    var onOpenOffer: ((Int) -> Void)? { get set }
    var onOpenCity: ((CityEntity?) -> Void)? { get set }
    var onOpenSort: ((Sort) -> Void)? { get set }
    var onOpenFilters: ((Filters) -> Void)? { get set }
}
