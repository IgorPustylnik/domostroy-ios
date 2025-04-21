//
//  SearchViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SearchViewInput: AnyObject, Loadable, EmptyStateable {
    /// Method for setup initial state of view
    func setQuery(_ query: String?)
    func setCity(_ city: String?)
    func setSort(_ sort: String)
    func setHasFilters(_ hasFilters: Bool)
    func setSearchOverlay(active: Bool)
}
