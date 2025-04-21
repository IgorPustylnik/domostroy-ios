//
//  MyOffersCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import PhotosUI

private enum LaunchInstructor {
    case auth
    case offers

    static func configure(userState: UserState) -> LaunchInstructor {
        switch userState {
        case .authorized:
            return .offers
        case .unauthorized:
            return .auth
        }
    }
}

final class MyOffersCoordinator: BaseCoordinator, MyOffersCoordinatorOutput {

    // MARK: - MyOffersCoordinatorOutput

    var onSetTabBarCenterControlEnabled: ((Bool) -> Void)?

    // MARK: - Private Properties

    private let router: Router

    private var onTapCenterControl: EmptyClosure?

    private var instructor: LaunchInstructor {
        // TODO: Get from UserDefaults
        let state = UserState.authorized
        return .configure(userState: state)
    }

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    // MARK: - Coordinator

    override func start() {
        switch instructor {
        case .auth:
            runAuthFlow()
        case .offers:
            showMyOffers()
        }
    }

}

extension MyOffersCoordinator: MyOffersCoordinatorInput {

    func didTapCenterControl() {
        onTapCenterControl?()
    }

}

// MARK: - Private methods

private extension MyOffersCoordinator {

    func runAuthFlow() {
        let coordinator = AuthCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

    func showMyOffers() {
        let (view, output, input) = MyOffersModuleConfigurator().configure()
        self.onTapCenterControl = { [weak input] in
            input?.didTapCenterControl()
        }
        output.onSetCenterControlEnabled = { [weak self] enabled in
            self?.onSetTabBarCenterControlEnabled?(enabled)
        }
        output.onAdd = { [weak self] in
            self?.showCreateOffer()
        }
        output.onOpenOffer = { [weak self] id in
            self?.runOfferDetailsFlow(id: id)
        }
        output.onEditOffer = { [weak self] id in
            self?.editOffer(id: id)
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showCreateOffer() {
        let (view, output) = CreateOfferModuleConfigurator().configure()
        output.onAddImages = { [weak self] delegate, limit in
            self?.showImagePicker(delegate: delegate, limit: limit)
        }
        output.onClose = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalPresentationStyle = .fullScreen
        router.present(navigationController)
    }

    func showImagePicker(delegate: PHPickerViewControllerDelegate, limit: Int) {
        var config = PHPickerConfiguration()
        config.selectionLimit = limit
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = delegate
        router.present(picker, animated: true, completion: nil)
    }

    func runOfferDetailsFlow(id: Int) {
        let coordinator = OfferDetailsCoordinator(router: router)
        coordinator.onComplete = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(with: id)
    }

    func editOffer(id: Int) {
        print("edit offer id: \(id)")
    }

}
