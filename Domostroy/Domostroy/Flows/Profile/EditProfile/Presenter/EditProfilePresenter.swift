//
//  EditProfilePresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Combine
import NodeKit

final class EditProfilePresenter: EditProfileModuleOutput {

    // MARK: - EditProfileModuleOutput

    var onShowChangePassword: EmptyClosure?
    var onSave: EmptyClosure?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: EditProfileViewInput?

    private let userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var firstName: String = ""
    private var lastName: String?
    private var phoneNumber: String = ""
}

// MARK: - EditProfileModuleInput

extension EditProfilePresenter: EditProfileModuleInput {

}

// MARK: - EditProfileViewOutput

extension EditProfilePresenter: EditProfileViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        view?.setLoading(true)
        loadUser()
    }

    func firstNameChanged(_ text: String) {
        self.firstName = text
    }

    func lastNameChanged(_ text: String) {
        self.lastName = text
    }

    func phoneNumberChanged(_ text: String) {
        self.phoneNumber = text
    }

    func showChangePassword() {
        onShowChangePassword?()
    }

    func save() {
        view?.setSavingActivity(isLoading: true)
        sendEditInfo(completion: { [weak self] in
            self?.view?.setSavingActivity(isLoading: false)
        }, handleResult: { [weak self] result in
            switch result {
            case .success:
                DropsPresenter.shared.showSuccess(subtitle: L10n.Localizable.Profile.Edit.Message.success)
                self?.onSave?()
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        })
    }

}

// MARK: - Private methods

private extension EditProfilePresenter {

    func loadUser(completion: EmptyClosure? = nil) {
        fetchUser(
            completion: { [weak self] in
                self?.view?.setLoading(false)
                completion?()
            },
            handleResult: { [weak self] result in
                switch result {
                case .success(let myUser):
                    self?.firstName = myUser.firstName
                    self?.lastName = myUser.lastName
                    self?.phoneNumber = myUser.phoneNumber
                    self?.configure(with: myUser)
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                    self?.onDismiss?()
                }
            }
        )
    }

    func fetchUser(completion: EmptyClosure?, handleResult: ((NodeResult<MyUserEntity>) -> Void)?) {
        userService?.getMyUser()
            .sink(receiveCompletion: { _ in
                completion?()
            }, receiveValue: { result in
                handleResult?(result)
            })
            .store(in: &cancellables)
    }

    func sendEditInfo(completion: EmptyClosure?, handleResult: ((NodeResult<Void>) -> Void)?) {
        if let lastName {
            if lastName.isEmpty {
                self.lastName = nil
            }
        }
        userService?.editInfo(
            editUserInfoEntity: .init(
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber
            )
        ).sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
        )
        .store(in: &cancellables)
    }

    func configure(with myUserEntity: MyUserEntity) {
        let viewModel = EditProfileView.ViewModel(
            avatarUrl: nil,
            loadAvatar: { url, imageView in
                imageView.loadAvatar(id: myUserEntity.id, name: myUserEntity.name, url: url)
            },
            firstName: myUserEntity.firstName,
            lastName: myUserEntity.lastName ?? "",
            phoneNumber: myUserEntity.phoneNumber
        )
        view?.configure(with: viewModel)
    }

}
