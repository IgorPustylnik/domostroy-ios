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
        if secureStorage?.loadToken() != nil {
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
        output.onAdd = { [weak self, weak input] in
            self?.showCreateOffer(reloadables: [input])
        }
        output.onOpenOffer = { [weak self, weak input] id in
            self?.showMyOfferDetails(id: id, reloadables: [input])
        }
        output.onEditOffer = { [weak self, weak input] id in
            self?.editOffer(id: id, reloadables: [input])
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showCreateOffer(reloadables: [Reloadable?]) {
        let (view, output, input) = CreateOfferModuleConfigurator().configure()
        output.onChooseFromLibrary = { [weak self] delegate, limit in
            self?.showImagePicker(delegate: delegate, limit: limit)
        }
        output.onTakeAPhoto = { [weak self] delegate in
            self?.openCamera(delegate: delegate)
        }
        output.onCameraPermissionRequest = { [weak self] in
            self?.showCameraPermissionRequest()
        }
        output.onShowCalendar = { [weak self] config in
            self?.showLessorCalendar(config: config, createOfferInput: input)
        }
        output.onShowCities = { [weak self, weak input] city in
            self?.showSelectCity(initialCity: city, citySettable: input)
        }
        output.onClose = { [weak self] in
            self?.router.dismissModule()
        }
        output.onSuccess = { [weak self] offerId in
            self?.start()
            self?.showMyOfferDetails(id: offerId, reloadables: reloadables)
        }
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalPresentationStyle = .fullScreen
        router.present(navigationController)
    }

    func showSelectCity(initialCity: CityEntity?, citySettable: CitySettable?) {
        let (view, output, input) = SelectCityModuleConfigurator().configure()
        input.setInitial(city: initialCity)
        input.setAllowAllCities(false)
        output.onApply = { [weak self, weak citySettable] city in
            citySettable?.setCity(city)
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

    func showMyOfferDetails(id: Int, reloadables: [Reloadable?]) {
        let (view, output, input) = MyOfferDetailsModuleConfigurator().configure()
        input.set(offerId: id)
        output.onEdit = { [weak self, weak input] id in
            var reloadables = reloadables
            reloadables.append(input)
            self?.editOffer(id: id, reloadables: reloadables)
        }
        output.onDeleted = { [weak self] in
            self?.router.popModule()
            reloadables.forEach { $0?.reload() }
        }
        output.onCalendar = { [weak self] offerId in
            print("calendar offer \(offerId)")
        }
        output.onDismiss = { [weak self] in
            self?.router.popModule()
        }
        router.push(view)
    }

    func editOffer(id: Int, reloadables: [Reloadable?]) {
        let (view, output, input) = EditOfferModuleConfigurator().configure()
        input.setOfferId(id)
        output.onChooseFromLibrary = { [weak self] delegate, limit in
            self?.showImagePicker(delegate: delegate, limit: limit)
        }
        output.onTakeAPhoto = { [weak self] delegate in
            self?.openCamera(delegate: delegate)
        }
        output.onCameraPermissionRequest = { [weak self] in
            self?.showCameraPermissionRequest()
        }
        output.onShowCities = { [weak self, weak input] city in
            self?.showSelectCity(initialCity: city, citySettable: input)
        }
        output.onClose = { [weak self] in
            self?.router.dismissModule()
        }
        output.onChanged = { [weak self] in
            self?.router.popModule()
            reloadables.forEach { $0?.reload() }
        }
        output.onSuccess = { [weak self] offerId in
            self?.start()
            self?.showMyOfferDetails(id: offerId, reloadables: reloadables)
        }
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalPresentationStyle = .fullScreen
        router.present(navigationController)
    }

    func showUnauthorized() {
        let (view, output) = ProfileUnauthorizedModuleConfigurator().configure()
        output.onAuthorize = { [weak self] in
            self?.runAuthFlow()
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func openCamera(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = delegate
        picker.sourceType = .camera
        picker.allowsEditing = false
        router.present(picker)
    }

    func showCameraPermissionRequest() {
        let alert = UIAlertController(
            title: L10n.Localizable.NoCameraPermission.title,
            message: L10n.Localizable.NoCameraPermission.message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: L10n.Localizable.Common.Button.cancel, style: .cancel))
        alert.addAction(UIAlertAction(
            title: L10n.Localizable.NoCameraPermission.Action.openSettins,
            style: .default,
            handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            })
        )

        router.present(alert)
    }

}
