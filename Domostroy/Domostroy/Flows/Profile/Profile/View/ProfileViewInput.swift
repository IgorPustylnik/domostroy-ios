//
//  ProfileViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol ProfileViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func configure(with viewModel: ProfileView.ViewModel)
    func setLoading(_ isLoading: Bool)
    func endRefreshing()
}
