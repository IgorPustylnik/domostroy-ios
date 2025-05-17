//
//  RequestsCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

private enum LaunchInstructor {
    case requests
    case auth

    static func configure(isAuthorized: Bool) -> LaunchInstructor {
        switch isAuthorized {
        case true:
            return .requests
        case false:
            return .auth
        }
    }
}

final class RequestsCoordinator: BaseCoordinator, RequestsCoordinatorOutput {

    // MARK: - RequestsCoordinatorOutput

    var onChangeAuthState: EmptyClosure?

    // MARK: - Private Properties

    private let router: Router

    private var instructor: LaunchInstructor {
        let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
        if secureStorage?.loadToken() != nil {
            return .configure(isAuthorized: true)
        }
        return .configure(isAuthorized: false)
    }

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        switch instructor {
        case .requests:
            showRequests()
        case .auth:
            showUnauthorized()
        }
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
        output.onDismiss = { [weak self] in
            self?.router.popModule()
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
        output.onDismiss = { [weak self] in
            self?.router.popModule()
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

    func showUnauthorized() {
        let (view, output) = ProfileUnauthorizedModuleConfigurator().configure()
        output.onAuthorize = { [weak self] in
            self?.runAuthFlow()
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func runAuthFlow() {
        let coordinator = AuthCoordinator(router: router)
        coordinator.onComplete = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        coordinator.onSuccessfulAuth = { [weak self] in
            self?.onChangeAuthState?()
        }
        addDependency(coordinator)
        coordinator.start()
    }

}
