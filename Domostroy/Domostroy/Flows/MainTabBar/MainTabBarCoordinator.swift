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

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showTabBar()
    }

}

// MARK: - Private methods

private extension MainTabBarCoordinator {

    func showTabBar() {
        let (view, output) = MainTabBarModuleConfigurator().configure()

        output.onHomeFlowSelect = runHomeFlow
        output.onFavoritesFlowSelect = runFavoritesFlow
        output.onMyOffersFlowSelect = runMyOffersFlow
        output.onRequestsFlowSelect = runRequestsFlow
        output.onProfileFlowSelect = runProfileFlow
        output.onAdd = {
            print("on add")
        }

        router.setRootModule(view)
        runHomeFlow(isInitial: true)
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

    func runMyOffersFlow(isInitial: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = MyOffersCoordinator(router: router)
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
        addDependency(coordinator)
        coordinator.start()
    }

}
