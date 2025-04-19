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
            self?.showSearch(query: query)
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showOfferDetails(_ id: Int) {
        let (view, output, input) = OfferDetailsModuleConfigurator().configure()
        input.set(offerId: id)
        output.onOpenUser = { [weak self] id in

        }
        output.onRent = { [weak self] in
            self?.showCreateRequest(offerId: id)
        }
        router.push(view, animated: true)
    }

    func showCreateRequest(offerId: Int) {
        let (view, output, input) = CreateRequestModuleConfigurator().configure()
        input.set(offerId: offerId)
        output.onShowCalendar = { [weak self] config in
            guard let config else {
                return
            }
            self?.showRequestCalendar(config: config)
        }

        router.push(view)
    }

    func showRequestCalendar(config: RequestCalendarConfig) {
        let (view, output, input) = RequestCalendarModuleConfigurator().configure()
        input.configure(with: config)
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        if let sheet = navigationControllerWrapper.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = 10
            sheet.prefersGrabberVisible = true
        }
        router.present(navigationControllerWrapper)
    }

    func showSearch(query: String?) {
        let (view, output, input) = SearchModuleConfigurator().configure()
        input.set(query: query)
        output.onOpenOffer = { [weak self] id in
            self?.showOfferDetails(id)
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
