//
//  CreateOfferViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol CreateOfferViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setConditions(_ items: [String])
    func setCategories(_ items: [String])
    func updateImagesAmount(_ amount: Int)

}
