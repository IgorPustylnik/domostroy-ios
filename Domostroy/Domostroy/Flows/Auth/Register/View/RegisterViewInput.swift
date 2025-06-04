//
//  RegisterViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol RegisterViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setActivity(isLoading: Bool)
}
