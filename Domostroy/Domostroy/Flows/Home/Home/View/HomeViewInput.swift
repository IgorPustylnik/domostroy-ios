//
//  HomeViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

// swiftlint:disable disclosure_of_view_details
protocol HomeViewInput: AnyObject, Loadable, EmptyStateable {
    /// Method for setup initial state of view
    func setupInitialState()
    func setSearchOverlay(active: Bool)
    func fillFirstPage(with viewModels: [OfferCollectionViewCell.ViewModel])
    func fillNextPage(with viewModels: [OfferCollectionViewCell.ViewModel])
}
