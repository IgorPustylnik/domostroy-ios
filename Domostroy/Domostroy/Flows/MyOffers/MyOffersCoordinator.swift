//
//  MyOffersCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class MyOffersCoordinator: BaseCoordinator, MyOffersCoordinatorOutput {

    // MARK: - MyOffersCoordinatorOutput

    var onSetTabBarCenterControlEnabled: ((Bool) -> Void)?

    // MARK: - Private Properties

    private let router: Router

    private var onTapCenterControl: EmptyClosure?

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showMyOffers()
    }

}

extension MyOffersCoordinator: MyOffersCoordinatorInput {

    func didTapCenterControl() {
        onTapCenterControl?()
    }

}

// MARK: - Private methods

private extension MyOffersCoordinator {

    func showMyOffers() {
        let (view, output, input) = MyOffersModuleConfigurator().configure()
        self.onTapCenterControl = { [weak input] in
            input?.didTapCenterControl()
        }
        output.onSetCenterControlEnabled = { [weak self] enabled in
            self?.onSetTabBarCenterControlEnabled?(enabled)
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

}
