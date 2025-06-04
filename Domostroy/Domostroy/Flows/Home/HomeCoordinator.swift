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

    var onChangeAuthState: EmptyClosure?

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
        output.onSearchFilters = { [weak self] filters in
            self?.showSearch(query: nil, filters: filters)
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func runOfferDetailsFlow(_ id: Int) {
        let coordinator = OfferDetailsCoordinator(router: router)
        coordinator.onComplete = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        coordinator.onChangeAuthState = { [weak self] in
            self?.onChangeAuthState?()
        }
        addDependency(coordinator)
        coordinator.start(with: id)
    }

    func showSearch(query: String?, filters: OfferFilterViewModel? = nil) {
        let (view, output, input) = SearchModuleConfigurator().configure()
        input.setQuery(query)
        if let filters {
            input.setFilters(filters)
        }
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

    func showSort(sort: SortViewModel, searchInput: SearchModuleInput?) {
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

    func showFilters(filters: OfferFilterViewModel, searchInput: SearchModuleInput?) {
        let (view, output, input) = OfferFilterModuleConfigurator().configure()
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
