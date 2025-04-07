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
    func register(registerDTO: RegisterDTO)
}
