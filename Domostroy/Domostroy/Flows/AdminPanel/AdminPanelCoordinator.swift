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
        let (view, output, input) = AdminPanelModuleConfigurator().configure()

        usersOutput.onOpenUser = { [weak self] id in
            self?.showUser(id: id)
        }
        output.onPresentSegment = { [weak input] segment in
            switch segment {
            case .users:
                input?.present(usersView, as: segment, scrollView: usersView.collectionView)
                input?.setSearchQuery(usersOutput.getSearchQuery())
            case .offers:
            }
        }

        router.push(view)
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
