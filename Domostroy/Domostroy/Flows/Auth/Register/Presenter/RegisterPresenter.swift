//
//  RegisterPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class RegisterPresenter: RegisterModuleOutput {

    // MARK: - RegisterModuleOutput

    // MARK: - Properties

    weak var view: RegisterViewInput?
}

// MARK: - RegisterModuleInput

extension RegisterPresenter: RegisterModuleInput {

}

// MARK: - RegisterViewOutput

extension RegisterPresenter: RegisterViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

    func register(
        name: String,
        surname: String,
        phoneNumber: String,
        email: String,
        password: String,
        repeatPassword: String
    ) {

    }

}
