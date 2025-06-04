//
//  AuthPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class AuthPresenter: AuthModuleOutput {

    // MARK: - AuthModuleOutput

    var onLogin: EmptyClosure?
    var onRegister: EmptyClosure?
    var onDeinit: EmptyClosure?

    // MARK: - Properties

    weak var view: AuthViewInput?

    deinit {
        onDeinit?()
    }
}

// MARK: - AuthModuleInput

extension AuthPresenter: AuthModuleInput {

}

// MARK: - AuthViewOutput

extension AuthPresenter: AuthViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

    func login() {
        onLogin?()
    }

    func register() {
        onRegister?()
    }

}
