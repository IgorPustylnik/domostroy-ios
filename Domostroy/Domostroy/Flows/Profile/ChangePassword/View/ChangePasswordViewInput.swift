//
//  ChangePasswordViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol ChangePasswordViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setSavingActivity(isLoading: Bool)
}
