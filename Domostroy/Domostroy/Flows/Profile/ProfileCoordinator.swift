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
        if let token = secureStorage?.loadToken() {
            return .configure(isAuthorized: true)
        }
        return .configure(isAuthorized: false)
    }

    override func start() {
        switch instructor {
        case .profile:
            showProfile()
        case .auth:
            showAnauthorized()
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

        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showAnauthorized() {
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
        addDependency(coordinator)
        coordinator.start()
    }

}
