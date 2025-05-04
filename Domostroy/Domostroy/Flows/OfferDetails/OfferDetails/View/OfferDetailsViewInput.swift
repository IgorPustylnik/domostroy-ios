//
//  OfferDetailsViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

// swiftlint:disable disclosure_of_view_details
protocol OfferDetailsViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setupFavoriteToggle(initialState: Bool, toggleAction: ToggleAction?)
    func setLoading(_ isLoading: Bool)
    func configureOffer(viewModel: OfferDetailsView.ViewModel)
    func configurePictures(with viewModels: [ImageCollectionViewCell.ViewModel])
}
