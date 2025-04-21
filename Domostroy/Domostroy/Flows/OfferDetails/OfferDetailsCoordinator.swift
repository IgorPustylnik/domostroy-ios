//
//  OfferDetailsCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class OfferDetailsCoordinator: BaseCoordinator, OfferDetailsCoordinatorOutput {

    // MARK: - OfferDetailsCoordinatorOutput

    var onComplete: EmptyClosure?

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    func start(with offerId: Int) {
        showOfferDetails(id: offerId)
    }

}

// MARK: - Private methods

private extension OfferDetailsCoordinator {
    func showOfferDetails(id: Int) {
        let (view, output, input) = OfferDetailsModuleConfigurator().configure()
        input.set(offerId: id)
        output.onOpenUser = { [weak self] id in

        }
        output.onRent = { [weak self] in
            self?.showCreateRequest(offerId: id)
        }
        output.onDeinit = { [weak self] in
            self?.onComplete?()
        }
        router.push(view, animated: true)
    }

    func showCreateRequest(offerId: Int) {
        let (view, output, input) = CreateRequestModuleConfigurator().configure()
        input.setOfferId(offerId)
        output.onShowCalendar = { [weak self, weak input] config in
            guard let config else {
                return
            }
            self?.showRequestCalendar(config: config, createRequestInput: input)
        }

        router.push(view)
    }

    func showRequestCalendar(config: RequestCalendarConfig, createRequestInput: CreateRequestModuleInput?) {
        let (view, output, input) = RequestCalendarModuleConfigurator().configure()
        input.configure(with: config)
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        output.onApply = { dayComponentsRange in
            createRequestInput?.setSelectedDates(dayComponentsRange)
        }

        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        if let sheet = navigationControllerWrapper.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = 10
            sheet.prefersGrabberVisible = true
        }
        router.present(navigationControllerWrapper)
    }

    func runAuthFlow() {
        let coordinator = AuthCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

}
