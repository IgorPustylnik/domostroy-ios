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
        let (view, output) = FavoritesModuleConfigurator().configure()
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

}
