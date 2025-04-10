//
//  HomeCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class HomeCoordinator: BaseCoordinator, HomeCoordinatorOutput {

    // MARK: - HomeCoordinatorOutput

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showHome()
    }

}

// MARK: - Private methods

private extension HomeCoordinator {

    func showHome() {
        let (view, output) = HomeModuleConfigurator().configure()
        output.onOpenOffer = { [weak self] id in
            self?.showOfferDetails(id)
        }
        output.onSearch = { [weak self] query in
            print(query)
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showOfferDetails(_ id: Int) {
        let (view, output) = OfferDetailsModuleConfigurator().configure(offerId: id)
        router.push(view, animated: true)
    }

}
