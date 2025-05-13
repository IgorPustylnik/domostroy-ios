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
        incomingOutput.onShowRequestDetails = { [weak self] requestId in
            self?.showIncomingRequestDetails(id: requestId)
        }
        outgoingOutput.onShowRequestDetails = { [weak self] requestId in
            self?.showOutgoingRequestDetails(id: requestId)
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showIncomingRequestDetails(id: Int) {
        let (view, output, input) = IncomingRequestDetailsModuleConfigurator().configure()
        input.setRequestId(id)
        output.onOpenOffer = { [weak self] id in
            self?.showOfferDetails(id: id)
        }
        output.onOpenUser = { [weak self] id in
            self?.showUser(id: id)
        }
        router.push(view)
    }

    func showOutgoingRequestDetails(id: Int) {
        let (view, output, input) = OutgoingRequestDetailsModuleConfigurator().configure()
        input.setRequestId(id)
        output.onOpenOffer = { [weak self] id in
            self?.showOfferDetails(id: id)
        }
        output.onOpenUser = { [weak self] id in
            self?.showUser(id: id)
        }
        router.push(view)
    }

    func showOfferDetails(id: Int) {
        let coordinator = OfferDetailsCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start(with: id)
    }

    func showUser(id: Int) {
        let (view, output, input) = UserProfileModuleConfigurator().configure()
        input.setUserId(id)
        output.onOpenOffer = { [weak self] id in
            self?.showOfferDetails(id: id)
        }
        output.onDismiss = { [weak self] in
            self?.router.popModule()
        }
        router.push(view)
    }

}
