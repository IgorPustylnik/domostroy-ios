//
//  RequestsCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class RequestsCoordinator: BaseCoordinator, RequestsCoordinatorOutput {

    // MARK: - RequestsCoordinatorOutput

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
    }

}

// MARK: - Private methods

private extension RequestsCoordinator {

}
