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

        static func configure(authState: AuthState) -> LaunchInstructor {
            switch authState {
            case .authorized:
                return .profile
            case .unauthorized:
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
        // TODO: Get from UserDefaults
        let state = AuthState.unauthorized
        return .configure(authState: state)
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
