//
//  CodeConfirmationPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Combine
import Foundation

final class CodeConfirmationPresenter: CodeConfirmationModuleOutput {

    // MARK: - CodeConfirmationModuleOutput

    var onCompleteRegistration: EmptyClosure?

    // MARK: - Properties

    weak var view: CodeConfirmationViewInput?

    private var registerEntity: RegisterEntity

    private let authService: AuthService? = ServiceLocator.shared.resolve()
    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()

    private var cancellables: [AnyCancellable] = []

    // MARK: - Init

    init(registerEntity: RegisterEntity) {
        self.registerEntity = registerEntity
    }
}

// MARK: - CodeConfirmationModuleInput

extension CodeConfirmationPresenter: CodeConfirmationModuleInput {

}

// MARK: - CodeConfirmationViewOutput

extension CodeConfirmationPresenter: CodeConfirmationViewOutput {

    func viewLoaded() {
        view?.setupInitialState(length: 6, email: registerEntity.email)
    }

    func confirmRegister(code: String) {
        let loginEntity = LoginEntity(email: registerEntity.email, password: registerEntity.password)
        authService?.postConfirmRegister(
            confirmRegisterEntity: .init(
                email: registerEntity.email,
                password: registerEntity.password,
                confirmationCode: code
            )
        )
        .flatMap { result -> AnyPublisher<Result<AuthTokenEntity, Error>, Never> in
            switch result {
            case .success:
                return self.authService?.postLogin(loginEntity: loginEntity)
                ?? Just(.failure(NSError())).eraseToAnyPublisher()
            case .failure(let error):
                DropsPresenter.shared.showError(
                    title: L10n.Localizable.Auth.CodeConfirmation.Error.failed, error: error
                )
                return Just(.failure(error)).eraseToAnyPublisher()
            }
        }
        .sink { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let token):
                AnalyticsEvent.registrationCompleted.send()
                secureStorage?.saveToken(token)
                onCompleteRegistration?()
            case .failure(let error):
                DropsPresenter.shared.showError(
                    title: L10n.Localizable.Auth.Login.Error.failed, error: error
                )
            }
        }
        .store(in: &cancellables)
    }
}
