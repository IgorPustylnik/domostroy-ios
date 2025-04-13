//
//  SearchViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SearchViewInput: AnyObject {
    /// Method for setup initial state of view
    func set(query: String?)
    func set(city: String?)
    func set(sort: String)
    func set(hasFilters: Bool)
    func showLoader()
    func hideLoader()
    func setSearchOverlay(active: Bool)
}
