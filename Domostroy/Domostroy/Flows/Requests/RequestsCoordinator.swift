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
        showRequests()
    }

}

// MARK: - Private methods

private extension RequestsCoordinator {

    func showRequests() {
        let (view, output, input) = RequestsModuleConfigurator().configure()

        let (incomingView, incomingOutput) = IncomingRequestsModuleConfigurator().configure()
        let (outgoingView, outgoingOutput) = OutgoingRequestsModuleConfigurator().configure()

        output.onPresentSegment = { [weak input] segment in
            switch segment {
            case .incoming:
                input?.present(incomingView, scrollView: incomingView.collectionView)
            case .outgoing:
                input?.present(outgoingView, scrollView: outgoingView.collectionView)
            }
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

}
