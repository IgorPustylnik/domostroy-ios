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
                    print(error)
                }
            })
            .store(in: &cancellables)
    }

    func loadAvatar(id: Int, name: String, url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url, placeholder: UIImage.initialsAvatar(name: name, hashable: id))
        }
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
                    print(error)
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
    func fetchProfile() async -> MyProfile {
        return await _Temporary_Mock_NetworkService().fetchMyProfile()
    }

    func configure(with myUser: MyUserEntity) {
        view?.configure(
            with: .init(
                imageUrl: nil,
                loadImage: { [weak self] url, imageView in
                    self?.loadAvatar(id: myUser.id, name: myUser.name, url: url, imageView: imageView)
                },
                name: myUser.name,
                phoneNumber: "+\(myUser.phoneNumber)",
                email: myUser.email,
                isAdmin: false
            )
        )
    }
}
