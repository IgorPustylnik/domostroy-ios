//
//  LoginViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol LoginViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setActivity(isLoading: Bool)
}
