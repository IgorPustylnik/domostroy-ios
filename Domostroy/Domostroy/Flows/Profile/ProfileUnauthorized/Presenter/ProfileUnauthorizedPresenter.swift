//
//  ProfileUnauthorizedPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class ProfileUnauthorizedPresenter: ProfileUnauthorizedModuleOutput {

    // MARK: - ProfileUnauthorizedModuleOutput

    var onAuthorize: EmptyClosure?

    // MARK: - Properties

    weak var view: ProfileUnauthorizedViewInput?
}

// MARK: - ProfileUnauthorizedModuleInput

extension ProfileUnauthorizedPresenter: ProfileUnauthorizedModuleInput {

}

// MARK: - ProfileUnauthorizedViewOutput

extension ProfileUnauthorizedPresenter: ProfileUnauthorizedViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

    func authorize() {
        onAuthorize?()
    }

}
