//
//  OnboardingViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 31/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OnboardingViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func fillPages(with models: [OnboardingPageModel])
    func setPage(index: Int, isLast: Bool)
}
