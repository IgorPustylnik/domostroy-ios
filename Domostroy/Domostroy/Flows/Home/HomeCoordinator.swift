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
            self?.runOfferDetailsFlow(id)
        }
        output.onSearch = { [weak self] query in
            self?.showSearch(query: query)
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func runOfferDetailsFlow(_ id: Int) {
        let coordinator = OfferDetailsCoordinator(router: router)
        coordinator.onComplete = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(with: id)
    }

    func showSearch(query: String?) {
        let (view, output, input) = SearchModuleConfigurator().configure()
        input.setQuery(query)
        output.onOpenOffer = { [weak self] id in
            self?.runOfferDetailsFlow(id)
        }
        output.onOpenCity = { [weak self, weak input] city in
            self?.showCity(city: city, input: input)
        }
        output.onOpenSort = { [weak self, weak input] sort in
            self?.showSort(sort: sort, input: input)
        }
        output.onOpenFilters = { [weak self, weak input] filter in
            self?.showFilters(filter: filter, input: input)
        }
        router.push(view, animated: true)
    }

    func showCity(city: City?, input: SearchModuleInput?) {

    }

    func showSort(sort: Sort, input: SearchModuleInput?) {

    }

    func showFilters(filter: Filter?, input: SearchModuleInput?) {

    }

}
