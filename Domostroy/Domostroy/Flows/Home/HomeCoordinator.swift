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
            self?.showCity(city: city, searchInput: input)
        }
        output.onOpenSort = { [weak self, weak input] sort in
            self?.showSort(sort: sort, searchInput: input)
        }
        output.onOpenFilters = { [weak self, weak input] filters in
            self?.showFilters(filters: filters, searchInput: input)
        }
        router.push(view, animated: true)
    }

    func showCity(city: CityEntity?, searchInput: SearchModuleInput?) {
        let (view, output, input) = SelectCityModuleConfigurator().configure()
        input.setInitial(city: city)
        input.setAllowAllCities(true)
        output.onApply = { [weak self, weak searchInput] city in
            searchInput?.setCity(city)
            self?.router.dismissModule()
        }
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .pageSheet
        router.present(navigationControllerWrapper)
    }

    func showSort(sort: Sort, searchInput: SearchModuleInput?) {
        let (view, output, input) = SortModuleConfigurator().configure()
        input.setup(initialSort: sort)
        output.onApply = { [weak searchInput] sort in
            searchInput?.setSort(sort)
        }
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .pageSheet
        router.present(navigationControllerWrapper)
    }

    func showFilters(filters: Filters, searchInput: SearchModuleInput?) {
        let (view, output, input) = FilterModuleConfigurator().configure()
        input.setFilters(filters)
        output.onApply = { [weak searchInput] newFilter in
            searchInput?.setFilters(newFilter)
        }
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .pageSheet
        router.present(navigationControllerWrapper)
    }

}
