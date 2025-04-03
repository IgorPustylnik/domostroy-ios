//
//  ProfileCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class ProfileCoordinator: BaseCoordinator, ProfileCoordinatorOutput {

    // MARK: - ProfileCoordinatorOutput

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showProfile()
    }

}

// MARK: - Private methods

private extension ProfileCoordinator {

    func showProfile() {
        let (view, output) = ProfileModuleConfigurator().configure()
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

}
