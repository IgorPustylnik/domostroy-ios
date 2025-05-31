//
//  OnboardingViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 31/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OnboardingViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func next()
    func setPage(index: Int)
}
