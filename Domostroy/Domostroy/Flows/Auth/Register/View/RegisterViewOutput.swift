//
//  RegisterViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol RegisterViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func register(
        name: String,
        surname: String,
        phoneNumber: String,
        email: String,
        password: String,
        repeatPassword: String
    )
}
