//
//  SearchViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

// swiftlint:disable disclosure_of_view_details
protocol SearchViewInput: AnyObject, Loadable, EmptyStateable {
    /// Method for setup initial state of view
    func setQuery(_ query: String?)
    func setCity(_ city: String?)
    func setSort(_ sort: String)
    func setHasFilters(_ hasFilters: Bool)
    func setSearchOverlay(active: Bool)
    func fillFirstPage(with viewModels: [OfferCollectionViewCell.ViewModel])
    func fillNextPage(with viewModels: [OfferCollectionViewCell.ViewModel])
}
