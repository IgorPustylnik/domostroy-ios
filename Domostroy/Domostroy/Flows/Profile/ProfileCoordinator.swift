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
        case profile, auth, banned
    }

    let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    // MARK: - Private Properties

    private var instructor: LaunchInstructor {
        let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
        if secureStorage?.loadToken() != nil {
            if let banned = basicStorage?.get(for: .amBanned), banned {
                return .banned
            }
            return .profile
        }
        return .auth
    }

    override func start() {
        switch instructor {
        case .profile:
            showProfile()
        case .auth:
            showUnauthorized()
        case .banned:
            showBanned()
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
            self?.runAdminPanelFlow()
        }
        output.onSettings = { [weak self] in
            self?.showSettings()
        }
        output.onShowBanned = { [weak self] in
            self?.showBanned()
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
        output.onDismiss = { [weak self] in
            self?.router.popModule()
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
        let (view, output) = SettingsModuleConfigurator().configure()
        output.onDismiss = { [weak self] in
            self?.router.popModule()
        }
        router.push(view)
    }

    func showUnauthorized() {
        let (view, output) = ProfileUnauthorizedModuleConfigurator().configure()
        output.onAuthorize = { [weak self] in
            self?.runAuthFlow()
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showBanned() {
        let (view, output) = ProfileBannedModuleConfigurator().configure()
        output.onUnbanned = { [weak self] in
            self?.start()
        }
        output.onLogout = { [weak self] in
            self?.onChangeAuthState?()
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

    func runAdminPanelFlow() {
        let coordinator = AdminPanelCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

}
