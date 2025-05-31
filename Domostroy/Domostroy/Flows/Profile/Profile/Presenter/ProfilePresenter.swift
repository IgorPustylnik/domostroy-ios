//
//  ProfilePresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Combine
import NodeKit

final class ProfilePresenter: ProfileModuleOutput {

    // MARK: - ProfileModuleOutput

    var onEdit: EmptyClosure?
    var onAdminPanel: EmptyClosure?
    var onSettings: EmptyClosure?
    var onLogout: EmptyClosure?

    // MARK: - Properties

    weak var view: ProfileViewInput?

    private let userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: [AnyCancellable] = []

    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
    private let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()

}

// MARK: - ProfileModuleInput

extension ProfilePresenter: ProfileModuleInput {
    func reload() {
        view?.setLoading(true)
        loadUser()
    }
}

// MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {
    func viewLoaded() {
        view?.setupInitialState()
        view?.setLoading(true)
        loadUser()
    }

    func refresh() {
        loadUser { [weak self] in
            self?.view?.endRefreshing()
        }
    }

    func edit() {
        onEdit?()
    }

    func adminPanel() {
        onAdminPanel?()
    }

    func settings() {
        onSettings?()
    }

    func logout() {
        secureStorage?.deleteToken()
        basicStorage?.remove(for: .myRole)
        onLogout?()
    }
}

// MARK: - Private methods

private extension ProfilePresenter {

    func loadUser(completion: EmptyClosure? = nil) {
        fetchUser(
            completion: { [weak self] in
                self?.view?.setLoading(false)
                completion?()
            },
            handleResult: { [weak self] result in
                switch result {
                case .success(let myUser):
                    self?.configure(with: myUser)
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
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

    func configure(with myUser: MyUserEntity) {
        view?.configure(
            with: .init(
                imageUrl: nil,
                loadImage: { url, imageView in
                    imageView.loadAvatar(id: myUser.id, name: myUser.name, url: url)
                },
                name: myUser.name,
                phoneNumber: RussianPhoneTextFieldFormatter.format(phoneNumber: myUser.phoneNumber),
                email: myUser.email,
                isAdmin: myUser.role == .admin
            )
        )
    }
}
