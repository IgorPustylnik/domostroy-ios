//
//  RegisterPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Combine

final class RegisterPresenter: RegisterModuleOutput {

    // MARK: - RegisterModuleOutput

    var onReceiveCode: ((RegisterEntity) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: RegisterViewInput?

    private let authService: AuthService? = ServiceLocator.shared.resolve()
    private var cancellables: [AnyCancellable] = []

}

// MARK: - RegisterModuleInput

extension RegisterPresenter: RegisterModuleInput {

}

// MARK: - RegisterViewOutput

extension RegisterPresenter: RegisterViewOutput {

    func viewLoaded() {
        AnalyticsEvent.openRegistration.send()
        view?.setupInitialState()
    }

    func register(registerEntity: RegisterEntity) {
        var lastName: String?
        if let lastNameNonNil = registerEntity.lastName {
            lastName = lastNameNonNil.isEmpty ? nil : lastNameNonNil
        }
        let normalizedRegisterEntity = RegisterEntity(
            firstName: registerEntity.firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName?.trimmingCharacters(in: .whitespaces),
            phoneNumber: registerEntity.phoneNumber.trimmingCharacters(in: .whitespaces),
            email: registerEntity.email.lowercased().trimmingCharacters(in: .whitespaces),
            password: registerEntity.password.trimmingCharacters(in: .whitespaces)
        )
        view?.setActivity(isLoading: true)
        authService?.postRegister(
            registerEntity: normalizedRegisterEntity
        )
        .sink { [weak self] result in
            self?.view?.setActivity(isLoading: false)
            switch result {
            case .success:
                self?.onReceiveCode?(normalizedRegisterEntity)
            case .failure(let error):
                DropsPresenter.shared.showError(title: L10n.Localizable.Auth.Register.Error.failed, error: error)
            }
        }
        .store(in: &cancellables)
    }

    func dismiss() {
        onDismiss?()
    }

}
