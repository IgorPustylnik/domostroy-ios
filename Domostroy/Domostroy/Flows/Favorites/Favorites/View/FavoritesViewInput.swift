//
//  FavoritesViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

// swiftlint:disable disclosure_of_view_details
protocol FavoritesViewInput: EmptyStateable, AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setLoading(_ isLoading: Bool)
    func setSort(_ sort: String?)
    func fillFirstPage(with viewModels: [FavoriteOfferCollectionViewCell.ViewModel])
    func fillNextPage(with viewModels: [FavoriteOfferCollectionViewCell.ViewModel])
}
