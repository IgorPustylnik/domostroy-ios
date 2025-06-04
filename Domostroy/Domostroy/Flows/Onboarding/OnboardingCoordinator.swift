//
//  OnboardingCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 31/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class OnboardingCoordinator: BaseCoordinator, OnboardingCoordinatorOutput {

    // MARK: - OnboardingCoordinatorOutput

    var onComplete: EmptyClosure?

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showOnboarding()
    }

}

// MARK: - Private methods

private extension OnboardingCoordinator {

    func showOnboarding() {
        let (view, output) = OnboardingModuleConfigurator().configure()
        output.onComplete = { [weak self] in
            self?.onComplete?()
        }
        router.setRootModule(view)
    }

}
