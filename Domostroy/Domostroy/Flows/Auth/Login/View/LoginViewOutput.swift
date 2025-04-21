//
//  LoginViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol LoginViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func login(email: String, password: String)
    func dismiss()
}
