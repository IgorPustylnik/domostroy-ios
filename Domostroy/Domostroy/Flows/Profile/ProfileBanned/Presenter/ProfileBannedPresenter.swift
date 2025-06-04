//
//  ProfileBannedPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Combine
import NodeKit

final class ProfileBannedPresenter: ProfileBannedModuleOutput {

    // MARK: - ProfileBannedModuleOutput

    var onLogout: EmptyClosure?
    var onUnbanned: EmptyClosure?

    // MARK: - Properties

    weak var view: ProfileBannedViewInput?

    private let userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: [AnyCancellable] = []

    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
    private let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()

}

// MARK: - ProfileBannedModuleInput

extension ProfileBannedPresenter: ProfileBannedModuleInput {
}

// MARK: - ProfileBannedViewOutput

extension ProfileBannedPresenter: ProfileBannedViewOutput {
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

    func logout() {
        secureStorage?.deleteToken()
        basicStorage?.remove(for: .myRole)
        basicStorage?.remove(for: .amBanned)
        onLogout?()
    }
}

// MARK: - Private methods

private extension ProfileBannedPresenter {

    func loadUser(completion: EmptyClosure? = nil) {
        fetchUser(
            completion: { [weak self] in
                self?.view?.setLoading(false)
                completion?()
            },
            handleResult: { [weak self] result in
                switch result {
                case .success(let myUser):
                    self?.handleUserInfo(user: myUser)
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

    func handleUserInfo(user: MyUserEntity) {
        if !user.isBanned {
            onUnbanned?()
        }
    }
}
