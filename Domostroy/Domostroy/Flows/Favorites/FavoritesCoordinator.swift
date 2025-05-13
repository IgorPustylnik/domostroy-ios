//
//  FavoritesCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class FavoritesCoordinator: BaseCoordinator, FavoritesCoordinatorOutput {

    // MARK: - FavoritesCoordinatorOutput

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
            showFavorites()
        case .auth:
            showUnauthorized()
        }
    }

}

// MARK: - Private methods

private extension FavoritesCoordinator {

    func showFavorites() {
        let (view, output, input) = FavoritesModuleConfigurator().configure()
        output.onOpenOffer = { [weak self] id in
            self?.runOfferDetailsFlow(id: id)
        }
        output.onOpenSort = { [weak self, weak input] sort in
            self?.showSort(sort: sort, favoritesInput: input)
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func runOfferDetailsFlow(id: Int) {
        let coordinator = OfferDetailsCoordinator(router: router)
        coordinator.onComplete = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(with: id)
    }

    func showSort(sort: SortViewModel, favoritesInput: FavoritesModuleInput?) {
        let (view, output, input) = SortModuleConfigurator().configure()
        input.setup(initialSort: sort)
        output.onApply = { [weak favoritesInput] sort in
            favoritesInput?.setSort(sort)
        }
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .pageSheet
        router.present(navigationControllerWrapper)
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
