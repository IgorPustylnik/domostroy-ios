//
//  CreateOfferViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

// swiftlint:disable disclosure_of_view_details
protocol CreateOfferViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setCategories(_ items: [String], placeholder: String, initialIndex: Int)
    func setImages(_ images: [AddingImageCollectionViewCell.Model], canAddMore: Bool)
    func setCity(title: String)
    func setCalendarPlaceholder(active: Bool)
    func setActivity(isLoading: Bool)
}
