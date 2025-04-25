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

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showFavorites()
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

    func showSort(sort: Sort, favoritesInput: FavoritesModuleInput?) {
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

}
