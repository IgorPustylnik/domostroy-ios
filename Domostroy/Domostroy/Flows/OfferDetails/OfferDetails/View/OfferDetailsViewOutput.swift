//
//  OfferDetailsViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OfferDetailsViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func openFullScreenImages(initialIndex: Int)
    func rent()
}
