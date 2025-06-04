//
//  UserProfileViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 24/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

// swiftlint:disable disclosure_of_view_details
protocol UserProfileViewInput: AnyObject, Loadable {
    /// Method for setup initial state of view
    func setupInitialState()
    func fillUser(with viewModel: UserProfileInfoCollectionViewCell.ViewModel, isBanned: Bool)
    func fillFirstPage(with viewModels: [OfferCollectionViewCell.ViewModel])
    func fillNextPage(with viewModels: [OfferCollectionViewCell.ViewModel])
    func setupMoreActions(_ actions: [UIAction])
}
