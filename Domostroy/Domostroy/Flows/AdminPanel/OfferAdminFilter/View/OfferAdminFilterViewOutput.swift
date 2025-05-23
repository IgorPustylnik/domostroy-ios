//
//  OfferAdminFilterViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OfferAdminFilterViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func selectCategory(index: Int)
    func setPriceFrom(_ from: String)
    func setPriceTo(_ to: String)
    func setStatus(_ status: OfferAdminFilterViewModel.OfferStatusViewModel)
    func apply()
    func dismiss()
}
