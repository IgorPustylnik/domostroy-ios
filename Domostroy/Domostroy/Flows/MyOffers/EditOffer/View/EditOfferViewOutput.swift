//
//  EditOfferViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation

protocol EditOfferViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func titleChanged(_ text: String)
    func descriptionChanged(_ text: String)
    func setSelectedCategory(index: Int)
    func takeAPhoto()
    func chooseFromLibrary()
    func deleteImage(uuid: UUID)
    func showCities()
    func isPriceNegotiableChanged(_ isNegotiable: Bool)
    func priceChanged(_ text: String)
    func save()
    func delete()
    func close()
}
