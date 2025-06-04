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
    private let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()

    private var onTapCenterControl: EmptyClosure?

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        setupTokenExpirationHandler()

        let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()
        if let banned = basicStorage?.get(for: .amBanned), banned {
            showTabBar(initialTab: .profile)
            return
        }

        showTabBar()
    }

    override func start(with deepLinkOption: DeepLinkOption?) {
        setupTokenExpirationHandler()

        let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()
        if let banned = basicStorage?.get(for: .amBanned), banned {
            showTabBar(initialTab: .profile)
            return
        }

        guard let deepLinkOption else {
            start()
            return
        }
        switch deepLinkOption {
        case .home:
            showTabBar(initialTab: .home)
        case .favorites:
            showTabBar(initialTab: .favorites)
        case .myOffers:
            showTabBar(initialTab: .myOffers)
        case .requests:
            showTabBar(initialTab: .requests)
        case .profile:
            showTabBar(initialTab: .profile)
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
        output.onRequestsFlowSelect = { [weak self] isInitial in
            self?.runRequestsFlow(isInitial: isInitial)
        }
        output.onProfileFlowSelect = { [weak self] isInitial in
            self?.runProfileFlow(isInitial: isInitial)
        }
        output.onTapCenterControl = { [weak self] in
            self?.onTapCenterControl?()
        }
        output.onShowSelectServerHost = { [weak self] in
            self?.showSelectServerHostAlert()
        }

        router.setRootModule(view, animated: true)
        input.selectTab(initialTab)
    }

    func runHomeFlow(isInitial: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = HomeCoordinator(router: router)
        coordinator.onChangeAuthState = { [weak self] in
            self?.childCoordinators.forEach { self?.removeDependency($0) }
            self?.start(with: .home)
        }
        addDependency(coordinator)
        coordinator.start()
    }

    func runFavoritesFlow(isInitial: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = FavoritesCoordinator(router: router)
        coordinator.onChangeAuthState = { [weak self] in
            self?.childCoordinators.forEach { self?.removeDependency($0) }
            self?.start(with: .favorites)
        }
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
        coordinator.onChangeAuthState = { [weak self] in
            self?.childCoordinators.forEach { self?.removeDependency($0) }
            self?.start(with: .myOffers)
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
        coordinator.onChangeAuthState = { [weak self] in
            self?.childCoordinators.forEach { self?.removeDependency($0) }
            self?.start(with: .requests)
        }
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

    func showSelectServerHostAlert() {
        let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()
        let address = InfoPlist.serverHost
        let alert = UIAlertController(title: "Server address", message: nil, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.text = address
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "Save", style: .default) { _ in
            let inputText = alert.textFields?.first?.text
            guard let inputText, !inputText.isEmpty else {
                basicStorage?.remove(for: .serverHost)
                return
            }
            basicStorage?.set(inputText, for: .serverHost)
        }

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        router.present(alert)
    }

}
