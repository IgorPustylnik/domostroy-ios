//
//  CreateRequestViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol CreateRequestViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func configure(with viewModel: CreateRequestView.ViewModel)
    func configureCalendar(with description: String)
    func configureTotalCost(with totalCost: String?)
    func setSubmissionActivity(isLoading: Bool)
}
