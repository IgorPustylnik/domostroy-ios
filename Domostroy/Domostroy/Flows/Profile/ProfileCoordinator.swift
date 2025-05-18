//
//  ProfileCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

enum AuthState {
    case authorized, unauthorized
}

final class ProfileCoordinator: BaseCoordinator, ProfileCoordinatorOutput {

    // MARK: - ProfileCoordinatorOutput

    var onChangeAuthState: EmptyClosure?

    // MARK: - Private Properties

    private enum LaunchInstructor {
        case profile, auth

        static func configure(isAuthorized: Bool) -> LaunchInstructor {
            switch isAuthorized {
            case true:
                return .profile
            case false:
                return .auth
            }
        }
    }

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    // MARK: - Private Properties

    private var instructor: LaunchInstructor {
        let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
        if secureStorage?.loadToken() != nil {
            return .configure(isAuthorized: true)
        }
        return .configure(isAuthorized: false)
    }

    override func start() {
        switch instructor {
        case .profile:
            showProfile()
        case .auth:
            showUnauthorized()
        }
    }
}

// MARK: - Private methods

private extension ProfileCoordinator {

    func showProfile() {
        let (view, output, input) = ProfileModuleConfigurator().configure()
        output.onEdit = { [weak self, weak input] in
            self?.showEditProfile(profileModuleInput: input)
        }
        output.onAdminPanel = { [weak self] in

        }
        output.onSettings = { [weak self] in
        }
        output.onLogout = { [weak self] in
            self?.onChangeAuthState?()
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showEditProfile(profileModuleInput: ProfileModuleInput?) {
        let (view, output) = EditProfileModuleConfigurator().configure()
        output.onSave = { [weak self, weak profileModuleInput] in
            self?.router.popModule()
            profileModuleInput?.reload()
        }
        output.onShowChangePassword = { [weak self] in
            self?.showChangePassword()
        }
        router.push(view)
    }

    func showChangePassword() {
        let (view, output) = ChangePasswordModuleConfigurator().configure()
        output.onSave = { [weak self] in
            self?.router.popPreviousView()
            self?.router.popModule()
        }
        router.push(view)
    }

    func showSettings() {
    }

    func showUnauthorized() {
        let (view, output) = ProfileUnauthorizedModuleConfigurator().configure()
        output.onAuthorize = { [weak self] in
            self?.runAuthFlow()
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func runAuthFlow() {
        let coordinator = AuthCoordinator(router: router)
        coordinator.onComplete = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        coordinator.onSuccessfulAuth = { [weak self] in
            self?.onChangeAuthState?()
        }
        addDependency(coordinator)
        coordinator.start()
    }

}
