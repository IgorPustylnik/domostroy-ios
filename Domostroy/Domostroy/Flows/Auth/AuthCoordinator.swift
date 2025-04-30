//
//  AuthCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {

    // MARK: - AuthCoordinatorOutput

    var onComplete: EmptyClosure?
    var onSuccessfulAuth: EmptyClosure?

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showAuth()
    }

}

// MARK: - Private methods

private extension AuthCoordinator {

    func showAuth() {
        let (view, output) = AuthModuleConfigurator().configure()
        output.onLogin = { [weak self] in self?.showLogin() }
        output.onRegister = { [weak self] in self?.showRegister() }
        output.onDeinit = { [weak self] in self?.onComplete?() }
        view.modalPresentationStyle = .pageSheet
        router.present(view)
    }

    func showLogin() {
        let (view, output) = LoginModuleConfigurator().configure()
        output.onDismiss = { [weak view] in
            view?.dismiss(animated: true)
        }
        output.onLoggedIn = { [weak self] in
            self?.onSuccessfulAuth?()
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .fullScreen
        router.present(navigationControllerWrapper)
    }

    func showRegister() {
        let (view, output) = RegisterModuleConfigurator().configure()
        output.onReceiveCode = { [weak self] registerEntity in
            self?.showCodeConfirmation(registerEntity: registerEntity)
        }
        output.onDismiss = { [weak view] in
            view?.dismiss(animated: true)
        }
        let navigationControllerWrapper = UINavigationController(rootViewController: view)
        navigationControllerWrapper.modalPresentationStyle = .fullScreen
        router.present(navigationControllerWrapper)
    }

    func showCodeConfirmation(registerEntity: RegisterEntity) {
        let (view, output) = CodeConfirmationModuleConfigurator().configure(registerEntity: registerEntity)
        output.onCompleteRegistration = { [weak self] loginEntity in
            // TODO: Autologin
            self?.onSuccessfulAuth?()
        }
        router.push(view, animated: true)
    }

}
