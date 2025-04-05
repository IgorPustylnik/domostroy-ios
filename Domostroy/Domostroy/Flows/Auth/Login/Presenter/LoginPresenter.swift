//
//  LoginPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class LoginPresenter: LoginModuleOutput {

    // MARK: - LoginModuleOutput

    // MARK: - Properties

    weak var view: LoginViewInput?
}

// MARK: - LoginModuleInput

extension LoginPresenter: LoginModuleInput {

}

// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

    func login(email: String, password: String) {
        guard
            TextValidator.email.validate(email).isValid,
            TextValidator.required(nil).validate(password).isValid
        else {
            return
        }
    }

}
