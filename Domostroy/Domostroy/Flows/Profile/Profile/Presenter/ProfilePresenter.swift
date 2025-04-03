//
//  ProfilePresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class ProfilePresenter: ProfileModuleOutput {

    // MARK: - ProfileModuleOutput

    // MARK: - Properties

    weak var view: ProfileViewInput?
}

// MARK: - ProfileModuleInput

extension ProfilePresenter: ProfileModuleInput {

}

// MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

}
