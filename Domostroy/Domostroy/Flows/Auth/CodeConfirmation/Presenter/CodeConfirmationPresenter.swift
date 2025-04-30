//
//  CodeConfirmationPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Combine

final class CodeConfirmationPresenter: CodeConfirmationModuleOutput {

    // MARK: - CodeConfirmationModuleOutput

    var onCompleteRegistration: ((LoginEntity) -> Void)?

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
        authService?.postConfirmRegister(
            confirmRegisterEntity: .init(
                email: registerEntity.email,
                password: registerEntity.password,
                confirmationCode: code
            )
        )
        .sink { [weak self] result in
            switch result {
            case .success:
                guard let self else {
                    return
                }
                self.onCompleteRegistration?(.init(email: registerEntity.email, password: registerEntity.password))
            case .failure(let error):
                print(error)
            }
        }
        .store(in: &cancellables)
    }

}
