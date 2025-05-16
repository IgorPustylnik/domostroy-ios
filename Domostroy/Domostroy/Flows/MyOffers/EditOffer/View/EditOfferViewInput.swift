//
//  EditOfferViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

// swiftlint:disable disclosure_of_view_details
protocol EditOfferViewInput: AnyObject, Loadable {
    /// Method for setup initial state of view
    func setupInitialState()
    func configure(with model: EditOfferViewModel)
    func setCategories(_ items: [String], placeholder: String, initialIndex: Int)
    func setImages(_ images: [AddingImageCollectionViewCell.Model], canAddMore: Bool)
    func setCity(title: String)
    func setSavingActivity(isLoading: Bool)
    func setDeletingActivity(isLoading: Bool)
}
