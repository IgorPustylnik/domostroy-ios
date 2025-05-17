//
//  FilterViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol FilterViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setCategories(_ items: [String], placeholder: String, initialIndex: Int)
    func setPriceFilter(from: String, to: String)
}
