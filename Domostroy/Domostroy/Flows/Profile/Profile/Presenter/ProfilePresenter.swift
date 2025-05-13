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

final class ProfilePresenter: ProfileModuleOutput {

    // MARK: - ProfileModuleOutput

    var onEdit: EmptyClosure?
    var onAdminPanel: EmptyClosure?
    var onLogout: EmptyClosure?

    // MARK: - Properties

    weak var view: ProfileViewInput?

    private let userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: [AnyCancellable] = []

    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()

}

// MARK: - ProfileModuleInput

extension ProfilePresenter: ProfileModuleInput {

}

// MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {
    func viewLoaded() {
        view?.setupInitialState()
        view?.setLoading(true)
        userService?.getMyUser()
            .sink(receiveCompletion: { [weak self] completion in
                self?.view?.setLoading(false)
            }, receiveValue: { [weak self] result in
                switch result {
                case .success(let myUser):
                    self?.view?.setLoading(false)
                    self?.configure(with: myUser)
                case .failure(let error):
                    self?.view?.setLoading(false)
                    DropsPresenter.shared.showError(error: error)
                }
            })
            .store(in: &cancellables)
    }

    func refresh() {
        userService?.getMyUser()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.view?.endRefreshing()
            }, receiveValue: { [weak self] result in
                switch result {
                case .success(let myUser):
                    self?.view?.endRefreshing()
                    self?.configure(with: myUser)
                case .failure(let error):
                    self?.view?.setLoading(false)
                    DropsPresenter.shared.showError(error: error)
                }
            })
            .store(in: &cancellables)
    }

    func edit() {
        onEdit?()
    }

    func adminPanel() {
        onAdminPanel?()
    }

    func logout() {
        secureStorage?.deleteToken()
        onLogout?()
    }
}

// MARK: - Private methods

private extension ProfilePresenter {
    func configure(with myUser: MyUserEntity) {
        view?.configure(
            with: .init(
                imageUrl: nil,
                loadImage: { url, imageView in
                    imageView.loadAvatar(id: myUser.id, name: myUser.name, url: url)
                },
                name: myUser.name,
                phoneNumber: "+\(myUser.phoneNumber)",
                email: myUser.email,
                isAdmin: false
            )
        )
    }
}
