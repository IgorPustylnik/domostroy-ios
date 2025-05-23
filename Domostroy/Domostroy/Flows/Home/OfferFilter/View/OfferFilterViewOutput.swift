//
//  OfferFilterViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OfferFilterViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func selectCategory(index: Int)
    func setPriceFrom(_ from: String)
    func setPriceTo(_ to: String)
    func apply()
    func dismiss()
}
