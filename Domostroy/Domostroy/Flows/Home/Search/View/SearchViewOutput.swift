//
//  SearchViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SearchViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func setSearch(active: Bool)
    func search(query: String?)
    func cancelSearch()
    func openLocation()
    func openSort()
    func openFilters()
}
