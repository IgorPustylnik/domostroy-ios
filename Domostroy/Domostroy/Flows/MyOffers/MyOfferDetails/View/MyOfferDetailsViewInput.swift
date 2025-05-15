//
//  MyOfferDetailsViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

// swiftlint:disable disclosure_of_view_details
protocol MyOfferDetailsViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setLoading(_ isLoading: Bool)
    func setupMoreActions(_ actions: [UIAction])
    func configureOffer(viewModel: MyOfferDetailsView.ViewModel)
    func configurePictures(with viewModels: [ImageCollectionViewCell.ViewModel])
}
