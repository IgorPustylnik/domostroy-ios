//
//  CreateOfferViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol CreateOfferViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func titleChanged(_ text: String)
    func descriptionChanged(_ text: String)
    func setSelectedCategory(index: Int)
    func showCities()
    func showCalendar()
    func priceChanged(_ text: String)
    func create()
    func close()
}
