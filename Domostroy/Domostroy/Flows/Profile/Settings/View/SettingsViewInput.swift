//
//  SettingsViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 18/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SettingsViewInput: AnyObject, Loadable {
    /// Method for setup initial state of view
    func setupInitialState()
    func configure(with model: SettingsViewModel)
}
