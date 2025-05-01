//
//  SelectCityViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

// swiftlint:disable disclosure_of_view_details
protocol SelectCityViewInput: AnyObject, Loadable {
    /// Method for setup initial state of view
    func setupInitialState()
    func setItems(with viewModels: [CityTableViewCell.ViewModel])
}
