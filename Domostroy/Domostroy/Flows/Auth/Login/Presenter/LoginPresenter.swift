//
//  LoginPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Combine
import Foundation

final class LoginPresenter: LoginModuleOutput {

    // MARK: - LoginModuleOutput

    var onDismiss: EmptyClosure?
    var onLoggedIn: EmptyClosure?

    // MARK: - Properties

    weak var view: LoginViewInput?

    private let authService: AuthService? = ServiceLocator.shared.resolve()
    private let userService: UserService? = ServiceLocator.shared.resolve()
    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
    private var cancellables: [AnyCancellable] = []

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
            RequiredValidator(EmailValidator()).validate(email).isValid else {
            return
        }
        view?.setActivity(isLoading: true)
        authService?.postLogin(loginEntity: .init(email: email.lowercased(), password: password))
            .sink(receiveValue: { [weak self] result in
                self?.view?.setActivity(isLoading: false)
                switch result {
                case .success(let token):
                    if !token.token.isEmpty, let saved = self?.secureStorage?.saveToken(token), saved {
                        self?.loadUser { success in
                            if success {
                                self?.onLoggedIn?()
                            }
                        }
                    }
                case .failure(let error):
                    DropsPresenter.shared.showError(title: L10n.Localizable.Auth.Login.Error.failed, error: error)
                }
            })
            .store(in: &cancellables)
    }

    func loadUser(completion: @escaping (Bool) -> Void) {
        userService?.getMyUser(
        ).sink(
            receiveValue: { result in
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    DropsPresenter.shared.showError(title: L10n.Localizable.Auth.Login.Error.failed, error: error)
                }
            }
        ).store(in: &cancellables)
    }

    func dismiss() {
        onDismiss?()
    }

}
