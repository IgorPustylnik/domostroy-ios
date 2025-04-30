//
//  RegisterPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class RegisterPresenter: RegisterModuleOutput {

    // MARK: - RegisterModuleOutput

    var onReceiveCode: ((RegisterEntity) -> Void)?
    var onDismiss: EmptyClosure?

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

    func register(registerEntity: RegisterEntity) {
        onReceiveCode?(registerEntity)
    }

    func dismiss() {
        onDismiss?()
    }

}
