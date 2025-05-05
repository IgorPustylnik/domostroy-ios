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

    static func configure(isAuthorized: Bool) -> LaunchInstructor {
        switch isAuthorized {
        case true:
            return .offers
        case false:
            return .auth
        }
    }
}

final class MyOffersCoordinator: BaseCoordinator, MyOffersCoordinatorOutput {

    // MARK: - MyOffersCoordinatorOutput

    var onSetTabBarCenterControlEnabled: ((Bool) -> Void)?
    var onChangeAuthState: EmptyClosure?

    // MARK: - Private Properties

    private let router: Router

    private var onTapCenterControl: EmptyClosure?

    private var instructor: LaunchInstructor {
        let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
        if let _ = secureStorage?.loadToken() {
            return .configure(isAuthorized: true)
        }
        return .configure(isAuthorized: false)
    }

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    // MARK: - Coordinator

    override func start() {
        switch instructor {
        case .auth:
            showUnauthorized()
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
        coordinator.onSuccessfulAuth = { [weak self] in
            self?.onChangeAuthState?()
        }
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
        let (view, output, input) = CreateOfferModuleConfigurator().configure()
        output.onAddImages = { [weak self] delegate, limit in
            self?.showImagePicker(delegate: delegate, limit: limit)
        }
        output.onShowCalendar = { [weak self] config in
            self?.showLessorCalendar(config: config, createOfferInput: input)
        }
        output.onShowCities = { [weak self, weak input] city in
            self?.showSelectCity(initialCity: city, createOfferInput: input)
        }
        output.onClose = { [weak self] in
            self?.router.dismissModule()
        }
        output.onSuccess = { [weak self] offerId in
            self?.start()
            self?.runOfferDetailsFlow(id: offerId)
        }
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalPresentationStyle = .fullScreen
        router.present(navigationController)
    }

    func showSelectCity(initialCity: CityEntity?, createOfferInput: CreateOfferModuleInput?) {
        let (view, output, input) = SelectCityModuleConfigurator().configure()
        input.setInitial(city: initialCity)
        input.setAllowAllCities(false)
        output.onApply = { [weak self, weak createOfferInput] city in
            createOfferInput?.setCity(city)
            self?.router.dismissModule()
        }
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .pageSheet
        router.present(navigationControllerWrapper)
    }

    func showLessorCalendar(config: LessorCalendarConfig, createOfferInput: CreateOfferModuleInput) {
        let (view, output, input) = LessorCalendarModuleConfigurator().configure()
        input.configure(with: config)
        output.onApply = { [weak createOfferInput] dates in
            createOfferInput?.setSelectedDates(dates)
        }
        output.onDismiss = { [weak self] in
            self?.router.dismissModule()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        router.present(navigationControllerWrapper)
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

    func showUnauthorized() {
        let (view, output) = ProfileUnauthorizedModuleConfigurator().configure()
        output.onAuthorize = { [weak self] in
            self?.runAuthFlow()
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

}
