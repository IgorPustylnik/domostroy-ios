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
    var onChangeAuthState: EmptyClosure?

    // MARK: - Private Properties

    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()

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
    func showOfferDetails(id: Int, isShownFromOwnersProfile: Bool = false) {
        let (view, output, input) = OfferDetailsModuleConfigurator().configure()
        input.set(offerId: id)
        output.onOpenUser = { [weak self] id in
            if isShownFromOwnersProfile {
                self?.router.popModule()
            } else {
                self?.showUser(id: id)
            }
        }
        output.onRent = { [weak self] in
            guard let secureStorage = self?.secureStorage else {
                return
            }
            guard let _ = secureStorage.loadToken() else {
                self?.runAuthFlow()
                return
            }
            self?.showCreateRequest(offerId: id)
        }
        output.onDeinit = { [weak self] in
            if !isShownFromOwnersProfile {
                self?.onComplete?()
            }
        }
        output.onDismiss = { [weak self] in
            self?.router.popModule()
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
        router.present(navigationControllerWrapper)
    }

    func showUser(id: Int) {
        let (view, output, input) = UserProfileModuleConfigurator().configure()
        input.setUserId(id)
        output.onOpenOffer = { [weak self] offerId in
            self?.showOfferDetails(id: offerId, isShownFromOwnersProfile: true)
        }
        router.push(view)
    }

    func runAuthFlow() {
        let coordinator = AuthCoordinator(router: router)
        coordinator.onSuccessfulAuth = { [weak self] in
            self?.onChangeAuthState?()
        }
        addDependency(coordinator)
        coordinator.start()
    }

}
