//
//  HomeModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol HomeModuleOutput: AnyObject {
    var onOpenOffer: ((Int) -> Void)? { get set }
    var onSearch: ((String?) -> Void)? { get set }
    var onSearchFilters: ((FiltersViewModel) -> Void)? { get set }
}
