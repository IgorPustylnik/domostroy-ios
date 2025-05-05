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
        if let _ = secureStorage?.loadToken() {
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
        let (view, output) = ProfileModuleConfigurator().configure()
        output.onEdit = { [weak self] in

        }
        output.onAdminPanel = { [weak self] in

        }
        output.onLogout = { [weak self] in
            self?.onChangeAuthState?()
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
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
