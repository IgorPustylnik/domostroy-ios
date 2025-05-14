//
//  ChangePasswordPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Combine
import NodeKit

final class ChangePasswordPresenter: ChangePasswordModuleOutput {

    // MARK: - ChangePasswordModuleOutput

    var onSave: EmptyClosure?

    // MARK: - Properties

    weak var view: ChangePasswordViewInput?

    private let userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var oldPassword: String = ""
    private var newPassword: String = ""
}

// MARK: - ChangePasswordModuleInput

extension ChangePasswordPresenter: ChangePasswordModuleInput {

}

// MARK: - ChangePasswordViewOutput

extension ChangePasswordPresenter: ChangePasswordViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

    func oldPasswordChanged(_ text: String) {
        self.oldPassword = text
    }

    func newPasswordChanged(_ text: String) {
        self.newPassword = text
    }

    func save() {
        view?.setSavingActivity(isLoading: true)
        changePassword(completion: { [weak self] in
            self?.view?.setSavingActivity(isLoading: false)
        }, handleResult: { [weak self] result in
            switch result {
            case .success:
                self?.onSave?()
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        })
    }

}

// MARK: - Private methods

private extension ChangePasswordPresenter {
    func changePassword(completion: EmptyClosure?, handleResult: ((NodeResult<Void>) -> Void)?) {
        userService?.changePassword(
            changePasswordEntity: .init(oldPassword: oldPassword, newPassword: newPassword)
        ).sink(receiveCompletion: { _ in completion?() },
               receiveValue: { handleResult?($0) }
        )
        .store(in: &cancellables)
    }
}
