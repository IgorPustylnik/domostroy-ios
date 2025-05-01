//
//  MainTabBarCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class MainTabBarCoordinator: BaseCoordinator, MainTabBarCoordinatorOutput {

    // MARK: - MainTabBarCoordinatorOutput

    // MARK: - Private Properties

    private let router: Router

    private lazy var tokenExpirationHandler = {
        $0.onExpire = { [weak self] in self?.start() }
        return $0
    }(TokenExpirationHandler())
    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()

    private var onTapCenterControl: EmptyClosure?

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        setupTokenExpirationHandler()
        showTabBar()
    }

    override func start(with deepLinkOption: DeepLinkOption?) {
        setupTokenExpirationHandler()
        if let deepLinkOption {
            switch deepLinkOption {
            case .profile:
                showTabBar(initialTab: .profile)
            }
        }
    }

}

// MARK: - Private methods

private extension MainTabBarCoordinator {

    func showTabBar(initialTab: MainTab = .home) {
        let (view, output, input) = MainTabBarModuleConfigurator().configure()

        output.onHomeFlowSelect = { [weak self] isInitial in
            self?.runHomeFlow(isInitial: isInitial)
        }
        output.onFavoritesFlowSelect = { [weak self] isInitial in
            self?.runFavoritesFlow(isInitial: isInitial)
        }
        output.onMyOffersFlowSelect = { [weak self, weak input] isInitial in
            self?.runMyOffersFlow(isInitial: isInitial, mainTabBarModuleInput: input)
        }
        output.onRequestsFlowSelect = runRequestsFlow
        output.onProfileFlowSelect = runProfileFlow
        output.onTapCenterControl = { [weak self] in
            self?.onTapCenterControl?()
        }

        router.setRootModule(view, animated: true)
        input.selectTab(initialTab)
    }

    func runHomeFlow(isInitial: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = HomeCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

    func runFavoritesFlow(isInitial: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = FavoritesCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

    func runMyOffersFlow(isInitial: Bool, mainTabBarModuleInput: MainTabBarModuleInput?) {
        guard isInitial else {
            return
        }
        let coordinator = MyOffersCoordinator(router: router)
        coordinator.onSetTabBarCenterControlEnabled = { [weak mainTabBarModuleInput] enabled in
            mainTabBarModuleInput?.setCenterControl(enabled: enabled)
        }
        onTapCenterControl = { [weak coordinator] in
            coordinator?.didTapCenterControl()
        }
        addDependency(coordinator)
        coordinator.start()
    }

    func runRequestsFlow(isInitial: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = RequestsCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

    func runProfileFlow(isInitial: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = ProfileCoordinator(router: router)
        coordinator.onChangeAuthState = { [weak self] in
            self?.childCoordinators.forEach { self?.removeDependency($0) }
            self?.start(with: .profile)
        }
        addDependency(coordinator)
        coordinator.start()
    }

    func setupTokenExpirationHandler() {
        tokenExpirationHandler.cancel()
        if let token = secureStorage?.loadToken() {
            tokenExpirationHandler.scheduleExpiration(for: token)
        }
    }

}
