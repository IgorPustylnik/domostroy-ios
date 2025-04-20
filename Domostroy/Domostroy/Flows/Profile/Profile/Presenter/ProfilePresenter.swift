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

final class ProfilePresenter: ProfileModuleOutput {

    // MARK: - ProfileModuleOutput

    var onEdit: EmptyClosure?
    var onAdminPanel: EmptyClosure?
    var onLogout: EmptyClosure?

    // MARK: - Properties

    weak var view: ProfileViewInput?
}

// MARK: - ProfileModuleInput

extension ProfilePresenter: ProfileModuleInput {

}

// MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {
    func viewLoaded() {
        view?.setLoading(true)
        Task {
            let profile = await fetchProfile()
            DispatchQueue.main.async { [weak self] in
                self?.view?.setLoading(false)
                self?.view?.setupInitialState()
                self?.configure(with: profile)
            }
        }
    }

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url, placeholder: UIImage.Mock.makita)
        }
    }

    func refresh() {
        Task {
            let profile = await fetchProfile()
            DispatchQueue.main.async { [weak self] in
                self?.view?.endRefreshing()
                self?.configure(with: profile)
            }
        }
    }

    func edit() {
        onEdit?()
    }

    func adminPanel() {
        onAdminPanel?()
    }

    func logout() {
        // actually do log out
        onLogout?()
    }
}

// MARK: - Private methods

private extension ProfilePresenter {
    func fetchProfile() async -> MyProfile {
        return await _Temporary_Mock_NetworkService().fetchMyProfile()
    }

    func configure(with profile: MyProfile) {
        view?.configure(
            with: .init(
                imageUrl: nil,
                loadImage: { [weak self] url, imageView in
                    self?.loadImage(url: url, imageView: imageView)
                },
                name: {
                    if let lastName = profile.lastName {
                        return "\(profile.firstName) \(lastName)"
                    }
                    return "\(profile.firstName)"
                }(),
                phoneNumber: profile.phoneNumber,
                email: profile.email,
                isAdmin: profile.isAdmin
            )
        )
    }
}
