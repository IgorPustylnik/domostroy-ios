//
//  AdminPanelCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class AdminPanelCoordinator: BaseCoordinator, AdminPanelCoordinatorOutput {

    // MARK: - AdminPanelCoordinatorOutput

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showAdminPanel()
    }

}

// MARK: - Private methods

private extension AdminPanelCoordinator {

    func showAdminPanel() {
        let (usersView, usersOutput, usersInput) = UsersAdminModuleConfigurator().configure()
        let (offersView, offersOutput, offersInput) = OffersAdminModuleConfigurator().configure()
        let (view, output, input) = AdminPanelModuleConfigurator().configure()

        input.setOffersAdminModuleInput(offersInput)

        offersInput.setAdminPanelModuleInput(input)

        usersOutput.onOpenUser = { [weak self] id in
            self?.showUser(id: id)
        }
        output.onSearch = { [weak usersInput, weak offersInput] query, segment in
            switch segment {
            case .users:
                usersInput?.search(query)
            case .offers:
                offersInput?.search(query)
            }
        }

        output.onPresentSegment = { [weak input] segment in
            switch segment {
            case .users:
                input?.present(usersView, as: segment, scrollView: usersView.collectionView)
                input?.setSearchQuery(usersOutput.getSearchQuery())
            case .offers:
                input?.present(offersView, as: segment, scrollView: offersView.collectionView)
                input?.setSearchQuery(offersOutput.getSearchQuery())
                break
            }
        }

        offersOutput.onOpenCity = { [weak self, weak offersInput] city in
            self?.showCity(city: city, offersInput: offersInput)
        }
        offersOutput.onOpenSort = { [weak self, weak offersInput] sort in
            self?.showSort(sort: sort, offersInput: offersInput)
        }
        offersOutput.onOpenFilters = { [weak self, weak offersInput] filters in
            self?.showFilters(filters: filters, offersInput: offersInput)
        }
        offersOutput.onOpenOffer = { [weak self] id in
            self?.runOfferDetailsFlow(id)
        }

        router.push(view)
    }

    func showCity(city: CityEntity?, offersInput: OffersAdminModuleInput?) {
        let (view, output, input) = SelectCityModuleConfigurator().configure()
        input.setInitial(city: city)
        input.setAllowAllCities(true)
        output.onApply = { [weak self, weak offersInput] city in
            offersInput?.setCity(city)
            self?.router.dismissModule()
        }
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .pageSheet
        router.present(navigationControllerWrapper)
    }

    func showSort(sort: SortViewModel, offersInput: OffersAdminModuleInput?) {
        let (view, output, input) = SortModuleConfigurator().configure()
        input.setup(initialSort: sort)
        output.onApply = { [weak offersInput] sort in
            offersInput?.setSort(sort)
        }
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .pageSheet
        router.present(navigationControllerWrapper)
    }

    func showFilters(filters: OfferAdminFilterViewModel, offersInput: OffersAdminModuleInput?) {
        let (view, output, input) = OfferAdminFilterModuleConfigurator().configure()
        input.setFilters(filters)
        output.onApply = { [weak offersInput] newFilter in
            offersInput?.setFilters(newFilter)
        }
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .pageSheet
        router.present(navigationControllerWrapper)
    }

    func showUser(id: Int) {
        let (view, output, input) = UserProfileModuleConfigurator().configure()
        input.setUserId(id)
        output.onOpenOffer = { [weak self] offerId in
            self?.runOfferDetailsFlow(offerId)
        }
        output.onDismiss = { [weak self] in
            self?.router.popModule()
        }
        router.push(view)
    }

    func runOfferDetailsFlow(_ id: Int) {
        let coordinator = OfferDetailsCoordinator(router: router)
        coordinator.onComplete = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(with: id)
    }

}
