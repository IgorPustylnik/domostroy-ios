//
//  EditProfileViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol EditProfileViewInput: AnyObject, Loadable {
    /// Method for setup initial state of view
    func setupInitialState()
    func configure(with viewModel: EditProfileView.ViewModel)
    func setSavingActivity(isLoading: Bool)
}
