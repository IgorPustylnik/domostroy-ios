//
//  OfferDetailsViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

// swiftlint:disable disclosure_of_view_details
protocol OfferDetailsViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setupFavoriteToggle(initialState: Bool, toggleAction: ToggleClosure?)
    func setLoading(_ isLoading: Bool)
    func configureOffer(viewModel: OfferDetailsView.ViewModel)
    func configurePictures(with viewModels: [ImageCollectionViewCell.ViewModel])
    func scrollToImage(at index: Int)
    func setupMoreActions(_ actions: [UIAction])
}
