//
//  FullScreenImagesViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation

// swiftlint:disable disclosure_of_view_details
protocol FullScreenImagesViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setup(with images: [FullScreenImageCollectionViewCell.ViewModel], initialIndex: Int)
}
